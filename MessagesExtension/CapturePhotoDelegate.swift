//
//  CaptureOutput.swift
//  OCRMessenger
//
//  Created by Andrea Ruffino on 15/01/2017.
//  Copyright © 2017 Andrea Ruffino. All rights reserved.
//  Sample from BilalReffas : http://stackoverflow.com/questions/37869963/how-to-use-avcapturephotooutput
//

import Foundation
import AVFoundation
import UIKit

class CapturePhotoDelegate: NSObject, AVCapturePhotoCaptureDelegate {
    
    let cameraOutput = AVCapturePhotoOutput()
    
    private let capturingPhoto: (Bool) -> ()
    private let completed: CaptureResponder
    private var photoData: Data? = nil
    
    init(capturingPhoto: @escaping (Bool) -> (), completed: @escaping CaptureResponder) {
        self.capturingPhoto = capturingPhoto
        self.completed = completed
    }
    
    func capturePhoto() {
        
        let settings = AVCapturePhotoSettings()
        let previewPixelType = settings.availablePreviewPhotoPixelFormatTypes.first!
        let previewFormat = [kCVPixelBufferPixelFormatTypeKey as String: previewPixelType,
                             kCVPixelBufferWidthKey as String: 160,
                             kCVPixelBufferHeightKey as String: 160]
        settings.previewPhotoFormat = previewFormat
        self.cameraOutput.capturePhoto(with: settings, delegate: self)
    }
    
    private func didFinish() {
        completed(photoData)
    }
    
    // MARK: - AVCapturePhotoCaptureDelegate
    
    func capture(_ captureOutput: AVCapturePhotoOutput, willBeginCaptureForResolvedSettings resolvedSettings: AVCaptureResolvedPhotoSettings) {
        if resolvedSettings.livePhotoMovieDimensions.width > 0 && resolvedSettings.livePhotoMovieDimensions.height > 0 {
            capturingPhoto(true)
        }
    }
    
    func capture(_ captureOutput: AVCapturePhotoOutput, didFinishProcessingPhotoSampleBuffer photoSampleBuffer: CMSampleBuffer?, previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
        if let error = error {
            print(error.localizedDescription)
        }
        
        if let photoSampleBuffer = photoSampleBuffer {
            photoData = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: photoSampleBuffer, previewPhotoSampleBuffer: previewPhotoSampleBuffer)
            didFinish()
        }
        else {
            print("Error capturing photo: \(error)")
            return
        }
    }
}
