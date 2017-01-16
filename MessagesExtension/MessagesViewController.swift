//
//  MessagesViewController.swift
//  MessagesExtension
//
//  Created by Andrea Ruffino on 14/01/2017.
//  Copyright © 2017 Andrea Ruffino. All rights reserved.
//

import UIKit
import Messages
import TesseractOCR

class MessagesViewController: MSMessagesAppViewController {
    
    @IBOutlet var captureView: CaptureViewController!
    @IBOutlet var captureButton: UIButton!
    
    var tesseractEngine: G8Tesseract!
    var tesseractImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // tesseract
        tesseractEngine = G8Tesseract(language:"eng")
        tesseractEngine.delegate = self as? G8TesseractDelegate
        tesseractEngine.charWhitelist = charWhiteList
        
        captureView.captureDidFinish = { (data) in
            self.tesseractEngine.image = UIImage(data: data!);
            self.tesseractEngine.recognize();
            print("\(self.tesseractEngine.image.size)")
            print("\(self.tesseractEngine.recognizedText)");
        }
        
        // Do any additional setup after loading the view.
    }
    
    func progressImageRecognitionForTesseract(tesseract: G8Tesseract!) {
        print("\(tesseract.progress)");
    }
    
    func shouldCancelImageRecognitionForTesseract(tesseract: G8Tesseract!) -> Bool {
        return false;  // return true, if you need to interrupt tesseract before it finishes
    }
    
    @IBAction func onCapturePressed(_ sender: Any) {
        captureView.takePhoto()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Conversation Handling
    
    override func willBecomeActive(with conversation: MSConversation) {
        // Called when the extension is about to move from the inactive to active state.
        // This will happen when the extension is about to present UI.
        
        // Use this method to configure the extension and restore previously stored state.
    }
    
    override func didResignActive(with conversation: MSConversation) {
        // Called when the extension is about to move from the active to inactive state.
        // This will happen when the user dissmises the extension, changes to a different
        // conversation or quits Messages.
        
        // Use this method to release shared resources, save user data, invalidate timers,
        // and store enough state information to restore your extension to its current state
        // in case it is terminated later.
    }
   
    override func didReceive(_ message: MSMessage, conversation: MSConversation) {
        // Called when a message arrives that was generated by another instance of this
        // extension on a remote device.
        
        // Use this method to trigger UI updates in response to the message.
    }
    
    override func didStartSending(_ message: MSMessage, conversation: MSConversation) {
        // Called when the user taps the send button.
    }
    
    override func didCancelSending(_ message: MSMessage, conversation: MSConversation) {
        // Called when the user deletes the message without sending it.
    
        // Use this to clean up state related to the deleted message.
    }
    
    override func willTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
        // Called before the extension transitions to a new presentation style.
    
        // Use this method to prepare for the change in presentation style.
    }
    
    override func didTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
        // Called after the extension transitions to a new presentation style.
    
        // Use this method to finalize any behaviors associated with the change in presentation style.
    }

}
