//
//  QRCodeScannerViewController.swift
//  TajVendor
//
//  Created by ananadmahajan on 4/12/18.
//  Copyright © 2018 ananadmahajan. All rights reserved.
//

import UIKit
import AVFoundation

protocol QRCodeScannerViewControllerDelegate {
    func didSuccesfullyFetchedQRCode(qrcode:String)
}
class QRCodeScannerViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    @IBOutlet weak var vwBottom: UIView!
    var captureSession = AVCaptureSession()
    
    @IBOutlet weak var vwCamera: UIView!
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var qrCodeFrameView: UIView?
    var delegate:QRCodeScannerViewControllerDelegate?
    private let supportedCodeTypes = [AVMetadataObject.ObjectType.upce,AVMetadataObject.ObjectType.qr]
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        if AVCaptureDevice.authorizationStatus(for: .video) ==  .authorized {
            self.doOtherStuff()
        } else {
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
                if granted {
                    self.doOtherStuff()
                } else {
                    let alert = UIAlertController(title: appTitle,
                                                  message: "Camera access is denied, please go to settings & enable camera privacy",
                                                  preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Settings",
                                                  style: UIAlertActionStyle.default,
                                                  handler: {(alert: UIAlertAction!) in
                                                    guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else {
                                                        return
                                                    }
                                                    
                                                    if UIApplication.shared.canOpenURL(settingsUrl) {
                                                        if #available(iOS 10.0, *) {
                                                            UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                                                                print("Settings opened: \(success)") // Prints true
                                                            })
                                                        } else {
                                                            UIApplication.shared.openURL(settingsUrl)
                                                        }
                                                    }
                    }))
                    alert.addAction(UIAlertAction(title: "Cancel",
                                                  style: UIAlertActionStyle.destructive,
                                                  handler: {(alert: UIAlertAction!) in }))
                    self.present(alert, animated: true, completion: nil)
                }
            })
        }
    }
    
    @objc func deviceDidRotate(notification: Notification) {
        DispatchQueue.main.async {
            self.updateCameraLayer()
        }
    }
    
    func doOtherStuff() {
        let captureDevice = AVCaptureDevice.default(for: AVMediaType.video)
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice!)
            
            captureSession.addInput(input)
        
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession.addOutput(captureMetadataOutput)
            
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = supportedCodeTypes
            
            self.updateCameraLayer()
            NotificationCenter.default.addObserver(
                self,
                selector:  #selector(deviceDidRotate),
                name: .UIDeviceOrientationDidChange,
                object: nil
            )

        } catch {
            print(error)
            return
        }
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        videoPreviewLayer?.frame = (appDel.window?.frame)!
        view.layer.addSublayer(videoPreviewLayer!)
        view.bringSubview(toFront: self.vwBottom)
        videoPreviewLayer?.connection?.videoOrientation = AVCaptureVideoOrientation(rawValue: (UIApplication.shared.statusBarOrientation.rawValue))!
        qrCodeFrameView = UIView()
        
        if let qrCodeFrameView = qrCodeFrameView {
            qrCodeFrameView.layer.borderColor = UIColor.green.cgColor
            qrCodeFrameView.layer.borderWidth = 2
            view.addSubview(qrCodeFrameView)
            view.bringSubview(toFront: qrCodeFrameView)
        }
        captureSession.startRunning()
    }
   
    func updateCameraLayer() {
        videoPreviewLayer?.videoGravity = .resizeAspectFill
        videoPreviewLayer?.frame = (appDel.window?.frame)!

        let transform: CATransform3D = CATransform3DIdentity

        if .landscapeLeft == UIDevice.current.orientation {
//            videoPreviewLayer?.frame = CGRect(x: 0, y: 0, width: CGFloat(h), height: CGFloat(w))
//            transform = CATransform3DTranslate(transform, CGFloat((w - h) / 2), CGFloat((h - w) / 2), 0)
//            transform = CATransform3DRotate(transform, -.pi/2 , 0, 0, 1)
//            angle = .pi/2
//            videoPreviewLayer?.transform = transform
            
            videoPreviewLayer?.connection?.videoOrientation = .landscapeRight
        }
        else if .landscapeRight == UIDevice.current.orientation {
            videoPreviewLayer?.connection?.videoOrientation = .landscapeLeft
        }
        else if .portraitUpsideDown == UIDevice.current.orientation {
        }
        else if .portrait == UIDevice.current.orientation {
            videoPreviewLayer?.connection?.videoOrientation = .portrait
        }
        else if .faceUp == UIDevice.current.orientation {
            print("face up")
        }
        else if .faceDown == UIDevice.current.orientation {
            print("face down")
        } else{
              videoPreviewLayer?.frame = CGRect.init(x: 0, y: 0, width: CGFloat((appDel.window?.frame.size.width)!), height: CGFloat((appDel.window?.frame.size.height)!))
            videoPreviewLayer?.transform = transform
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)

    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    @IBAction func clickCancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func clickRetry(_ sender: Any) {
        captureSession.startRunning()
    }
}

extension QRCodeScannerViewController: AVCaptureMetadataOutputObjectsDelegate {
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        // Check if the metadataObjects array is not nil and it contains at least one object.

        if metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRect.zero
            return
        }
        // Get the metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if supportedCodeTypes.contains(metadataObj.type) {
            // If the found metadata is equal to the QR code metadata (or barcode) then update the status label's text and set the bounds
            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
            qrCodeFrameView?.frame = barCodeObject!.bounds
            
            if metadataObj.stringValue != nil {
                qrCodeFrameView?.frame = CGRect.zero
                captureSession.stopRunning()
                self.delegate?.didSuccesfullyFetchedQRCode(qrcode: metadataObj.stringValue! )
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
}
