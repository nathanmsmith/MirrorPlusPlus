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
    
    let session = AVCaptureSession()
    var previewLayer: AVCaptureVideoPreviewLayer!
    
    let demirror = CATransform3DMakeScale(-1, 1, 1)
    let mirror = CATransform3DMakeScale(1, 1, 1)

    
    //@IBOutlet weak var previewView: AVCamPreviewView!
    @IBOutlet weak var mirrorOrientationLabel: UILabel!
    
    @IBAction func flipOrientation(sender: UIButton) {
        if isMirrored() {
            previewLayer.transform = demirror
        } else {
            previewLayer.transform = mirror
        }
        displayOrientation()
    }
    
    func isMirrored() -> Bool {
        if CATransform3DEqualToTransform(previewLayer.transform, mirror) {
            return true
        } else {
            return false
        }
    }
    
    func displayOrientation() {
        let text = isMirrored() ? "Mirrored" : "De-mirrored"
        
        mirrorOrientationLabel.alpha = 1
        UIView.animateWithDuration(3.0, animations: {
            self.mirrorOrientationLabel.text = text
            self.mirrorOrientationLabel.alpha = 0
        })
    }
    
    // If we find a device we'll store it here for later use
    var captureDevice: AVCaptureDevice?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /*NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: "displayOrientation:",
            name: UIApplicationDidBecomeActiveNotification,
            object: nil)*/
        
        print("loaded")
        
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
        
        displayOrientation()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

}
