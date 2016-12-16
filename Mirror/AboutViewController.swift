//
//  AboutViewController.swift
//  Mirror++
//
//  Created by Nathan Smith on 12/15/16.
//  Copyright © 2016 Smith Industries. All rights reserved.
//

import UIKit
import MessageUI

class AboutViewController: UITableViewController, MFMailComposeViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        let versionNumber = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
        let buildNumber = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as! String
        
        if var info = infoText.text {
            info = info.replacingOccurrences(of: "VERSION_NUMBER", with: versionNumber)
            info = info.replacingOccurrences(of: "BUILD_NUMBER", with: buildNumber)
            infoText.text = info
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var infoText: UITextView!
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        var url:URL?
        
        print("Row Selected!")
        
        switch (indexPath.section, indexPath.row) {
        case (0, 0): // Send Feedback
            sendEmail()
        case (0, 1): // Rate on App Store
            print("Rate on App Store")
        case (1, 0): // Visit Website
            url = URL(string: "http://nathansmith.io/mirrorplusplus")
        case (1, 1): // See the Source Code
            url = URL(string: "https://github.com/nathunsmitty/MirrorPlusPlus")
        default:
            return
        }
        
        if url != nil {
            UIApplication.shared.openURL(url!)
        }
    }
    
    // MARK: Email
    func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["nathan@nathansmith.io"])
            mail.setSubject("Mirror++")
            
            present(mail, animated: true)
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
