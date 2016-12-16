//
//  MirrorViewController.swift
//  Mirror++
//
//  Created by Nathan Smith on 12/26/15.
//  Copyright © 2015 Smith Industries. All rights reserved.
//

import UIKit
import AVFoundation

class MirrorViewController: UIViewController {
    
    let session = AVCaptureSession()
    var previewLayer: AVCaptureVideoPreviewLayer!

    
    //@IBOutlet weak var previewView: AVCamPreviewView!
    @IBOutlet weak var mirrorOrientation: UILabel!
    
    @IBOutlet weak var flipButton: UIButton!
    
    @IBAction func flipOrientation(_ sender: UIButton) {
        
        let demirror = CATransform3DMakeScale(-1, 1, 1)
        let mirror = CATransform3DMakeScale(1, 1, 1)
        
        if CATransform3DEqualToTransform(previewLayer.transform, mirror) {
            //De-Mirror
            flipButton.isSelected = true
            previewLayer.transform = demirror
        } else {
            //Mirror
            flipButton.isSelected = false
            previewLayer.transform = mirror
        }
    }
    
    // If we find a device we'll store it here for later use
    var captureDevice: AVCaptureDevice?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        session.sessionPreset = AVCaptureSessionPresetHigh
        let devices = AVCaptureDevice.devices()
        
        // Loop through all the capture devices on this phone
        for device in devices! {
            // Make sure this particular device supports video
            if ((device as AnyObject).hasMediaType(AVMediaTypeVideo)) {
                // Finally check the position and confirm we've got the front camera
                if((device as AnyObject).position == AVCaptureDevicePosition.front) {
                    captureDevice = device as? AVCaptureDevice
                    if captureDevice != nil {
                        print("Capture device found!")
                        beginSession()
                    }
                }
            }
        }
    }
    
    func beginSession() {
        do {
            try session.addInput(AVCaptureDeviceInput(device: captureDevice))
        } catch {
            print("error: \(error)")
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: session)
        self.view.layer.insertSublayer(previewLayer, at: 0)
        previewLayer.frame = self.view.layer.frame
        session.startRunning()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let time:TimeInterval = 0.3
        
        for subview in self.viewIfLoaded!.subviews {
            if subview.alpha == 0 {
                UIView.animate(withDuration: time, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                    subview.alpha = 1
                    }, completion: nil)
            } else {
                UIView.animate(withDuration: time, delay: 0, options: UIViewAnimationOptions.curveEaseIn, animations: {
                    subview.alpha = 0
                    }, completion: nil)
            }
        }
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }

}
