//
//  SettingViewController.swift
//  Converse
//
//  Created by Kareem Ismail on 7/16/18.
//  Copyright © 2018 Whatever. All rights reserved.
//

import UIKit
import MessageUI

class HelpVC: UIViewController, UITableViewDelegate, UITableViewDataSource,MFMailComposeViewControllerDelegate {
    
    @IBOutlet weak var topView: CustomSizeUIView!
    
    @IBOutlet weak var helpTableView: UITableView!
    let settingsTableElements = ["About Movies Box", "About FM2Apps LLC", "Send Feedback"]
    let helpTableImages = [UIImage(named: "movie-icon"),UIImage(named: "FM2Apps"),UIImage(named: "feed-back")]
    override func viewDidLoad() {
        super.viewDidLoad()
        //topView.configureSize()
        helpTableView.delegate = self
        helpTableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsTableElements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = helpTableView.dequeueReusableCell(withIdentifier: "helpCell", for: indexPath) as? HelpCell {
            cell.configureCell(with: settingsTableElements[indexPath.row], with: helpTableImages[indexPath.row]!)
            return cell
            
        } else {
            return UITableViewCell()
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0 : performSegue(withIdentifier: TO_ABOUT_MOVIES, sender: nil)
        case 1 : performSegue(withIdentifier: TO_ABOUT_US, sender: nil)
        default : sendMail()
        }
        
    }
    func sendMail(){
        if MFMailComposeViewController.canSendMail(){
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["info@fm2apps.com"])
            mail.setSubject("Movies Box App Feedback")
            present(mail, animated: true)
        }
    }
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
}
