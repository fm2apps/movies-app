//
//  TermsAndConditionsViewController.swift
//  Converse
//
//  Created by Kareem Ismail on 7/16/18.
//  Copyright © 2018 Whatever. All rights reserved.
//

import UIKit

class TermsAndConditionsVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var topView: CustomSizeUIView!
    @IBOutlet weak var tableView: UITableView!
    let titleArray = ["","Links To Other Web Sites", "Termination", "Governing Law", "Changes", "Contact Us"]
    let textArray = ["""
                        Last updated: July 16, 2018\n
                        Please read these Terms and Conditions ("Terms", "Terms and Conditions") carefully before using the www.fm2apps.com website (the "Service") operated by FM2Apps LLC ("us", "we", or "our").\n
                        Your access to and use of the Service is conditioned on your acceptance of and compliance with these Terms. These Terms apply to all visitors, users and others who access or use the Service.\n
                        By accessing or using the Service you agree to be bound by these Terms. If you disagree with any part of the terms then you may not access the Service. This Terms and Conditions agreement for FM2Apps LLC is generated by TermsFeed.
                        """, """
Our Service may contain links to third-party web sites or services that are not owned or controlled by FM2Apps LLC.\n
FM2Apps LLC has no control over, and assumes no responsibility for, the content, privacy policies, or practices of any third party web sites or services. You further acknowledge and agree that FM2Apps LLC shall not be responsible or liable, directly or indirectly, for any damage or loss caused or alleged to be caused by or in connection with use of or reliance on any such content, goods or services available on or through any such web sites or services.\n
We strongly advise you to read the terms and conditions and privacy policies of any third-party web sites or services that you visit.
""", """
We may terminate or suspend access to our Service immediately, without prior notice or liability, for any reason whatsoever, including without limitation if you breach the Terms.\n
All provisions of the Terms which by their nature should survive termination shall survive termination, including, without limitation, ownership provisions, warranty disclaimers, indemnity and limitations of liability.
""", """
These Terms shall be governed and construed in accordance with the laws of Egypt, without regard to its conflict of law provisions.\n
Our failure to enforce any right or provision of these Terms will not be considered a waiver of those rights. If any provision of these Terms is held to be invalid or unenforceable by a court, the remaining provisions of these Terms will remain in effect. These Terms constitute the entire agreement between us regarding our Service, and supersede and replace any prior agreements we might have between us regarding the Service.
""", """
We reserve the right, at our sole discretion, to modify or replace these Terms at any time. If a revision is material we will try to provide at least 30 days notice prior to any new terms taking effect. What constitutes a material change will be determined at our sole discretion.
By continuing to access or use our Service after those revisions become effective, you agree to be bound by the revised terms. If you do not agree to the new terms, please stop using the Service.
""", "If you have any questions about these Terms, please contact us at info@fm2app.com ."]
    //let textArray = ["","","","","",""]
    override func viewDidLoad() {
        super.viewDidLoad()
        topView.configureSize()
        tableView.estimatedRowHeight = 140
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "aboutUsCell", for: indexPath) as? AboutUsCell {
            cell.configureCell(titleArray[indexPath.row], text: textArray[indexPath.row])
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    
    
}