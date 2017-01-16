//
//  CaptureView.swift
//  OCRMessenger
//
//  Created by Andrea Ruffino on 13/01/2017.
//  Copyright © 2017 Andrea Ruffino. All rights reserved.
//

import UIKit
import Foundation
import AVFoundation

class CaptureViewController : UIImageView {
    
    let captureSession = AVCaptureSession()
    var capturePhotoOutput : CapturePhotoDelegate?
    var captureDevice : AVCaptureDevice?
    var previewLayer : AVCaptureVideoPreviewLayer?
    var captureDidFinish : CaptureResponder?
    
    override init (frame : CGRect) {
        super.init(frame : frame)
    }
    
    convenience init () {
        self.init(frame:CGRect.zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSession()
    }
    
    func initSession (){
        captureSession.sessionPreset = AVCaptureSessionPresetHigh
        
        capturePhotoOutput = CapturePhotoDelegate(capturingPhoto: { (capturing) in
            print("is capturing : \(capturing)")
        }, completed: { (data) in
            if self.captureDidFinish != nil {
                self.captureDidFinish?(data)
            }
        })
        
        if captureSession.canAddOutput(capturePhotoOutput?.cameraOutput) {
            captureSession.addOutput(capturePhotoOutput?.cameraOutput)
        }
        
        if let discoverySession = AVCaptureDeviceDiscoverySession(
            deviceTypes: [.builtInWideAngleCamera],
            mediaType: AVMediaTypeVideo,
            position: .back) {
            
            captureDevice = discoverySession.devices.first
        }
        if captureDevice != nil {
            beginSession()
        }
    }
    
    func beginSession() {
        do { try captureSession.addInput(AVCaptureDeviceInput(device: captureDevice)) }
        catch { print ("Unable to instantiate AVCCaptureDeviceInput.") }
        
        do { try captureDevice?.lockForConfiguration() }
        catch { print ("Unable to lock device for focus.") }
        
        captureDevice?.isSmoothAutoFocusEnabled = true
        captureDevice?.focusMode = .continuousAutoFocus
        
        captureDevice?.unlockForConfiguration()
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        
        if previewLayer != nil {
            
            previewLayer?.frame = self.bounds
            previewLayer?.videoGravity = "AVLayerVideoGravityResizeAspectFill"
            
            self.layer.addSublayer(previewLayer!)
            captureSession.startRunning()
        }
    }
    
    func takePhoto() {
        capturePhotoOutput?.capturePhoto()
    }
}
