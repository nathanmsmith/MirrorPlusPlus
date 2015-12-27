//
//  ViewController.swift
//  Mirror++
//
//  Created by Nathan Smith on 12/26/15.
//  Copyright © 2015 Smith Industries. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    let ANIMATION_TIME:NSTimeInterval = 3.0
    
    let session = AVCaptureSession()
    var previewLayer: AVCaptureVideoPreviewLayer!

    
    //@IBOutlet weak var previewView: AVCamPreviewView!
    @IBOutlet weak var mirrorOrientation: UILabel!
    
    @IBAction func flipOrientation(sender: UIButton) {
        
        let demirror = CATransform3DMakeScale(-1, 1, 1)
        let mirror = CATransform3DMakeScale(1, 1, 1)
        
        if CATransform3DEqualToTransform(previewLayer.transform, mirror) {
            mirrorOrientation.alpha = 1
            previewLayer.transform = demirror
            UIView.animateWithDuration(ANIMATION_TIME, animations: {
                self.mirrorOrientation.text = "De-mirrored"
                self.mirrorOrientation.alpha = 0
            })
        } else {
            mirrorOrientation.alpha = 1
            previewLayer.transform = mirror
            UIView.animateWithDuration(ANIMATION_TIME, animations: {
                self.mirrorOrientation.text = "Mirrored"
                self.mirrorOrientation.alpha = 0
            })

        }
    }
    
    // If we find a device we'll store it here for later use
    var captureDevice: AVCaptureDevice?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        session.sessionPreset = AVCaptureSessionPresetHigh
        let devices = AVCaptureDevice.devices()
        
        // Loop through all the capture devices on this phone
        for device in devices {
            // Make sure this particular device supports video
            if (device.hasMediaType(AVMediaTypeVideo)) {
                // Finally check the position and confirm we've got the front camera
                if(device.position == AVCaptureDevicePosition.Front) {
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
        self.view.layer.insertSublayer(previewLayer, atIndex: 0)
        previewLayer.frame = self.view.layer.frame
        session.startRunning()
        
        UIView.animateWithDuration(ANIMATION_TIME, animations: {
            self.mirrorOrientation.text = "Mirrored"
            self.mirrorOrientation.alpha = 0
        })
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

}
