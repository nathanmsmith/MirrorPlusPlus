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
    
    @IBOutlet weak var previewView: AVCamPreviewView!
    
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
        
        previewView.session = session
        session.startRunning()
    }
}
