//
//  InformationController.swift
//  Converse
//
//  Created by Kareem Ismail on 7/16/18.
//  Copyright © 2018 Whatever. All rights reserved.
//

import UIKit

class AboutUsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var topView: CustomSizeUIView!
    

    @IBOutlet weak var textTableView: UITableView!
    
    
    let textArray = ["FM2APPS LLC, Founded in 2017 ,We are young passionate entrepreneurs that aim to enable startups’, small and medium size company to offer digital solutions to their customers while building, advancing their business model. FM2Apps is a software development company that provides digital services in a range of software’s, web application, web development, web design processes, Call Center management and technical management of your product and digital marketing strategies. We strive to make the optimum use of technology for providing the best when it comes to creating a strong brand awareness for our clients at several levels.", """
        We offer the technical and operation solution to your business . We serve as your sounding board to ensure quality and sustainable solution. We do understand the business challenges and we offer tailored solutions to your business. \n
        Our Products & Services Range:\n
        - Mobile App Solutions for Android & iOS
        - Website Design & Development
        - Social Media Management & SEO
        - Call Center Setup & Management
        - Creative Design
        ""","Get in touch and we’ll get back to you as soon as we can. We look forward to hearing from you!", "15 El Shahed Helmy Kamal St. , Heliopolis, Cairo , Egypt\nTel: +20226389355", "info@fm2apps.com", "- Sunday- Thursday\n- From : 09.00 AM - 05.00 PM" ]
    let titleArray = ["Who We Are ?", "Our Services", "Contact Us", "Head Office", "Email", "Working Hours"]
    override func viewDidLoad() {
        super.viewDidLoad()
        topView.configureSize()
        textTableView.estimatedRowHeight = 150
        textTableView.rowHeight = UITableViewAutomaticDimension
        textTableView.delegate = self
        textTableView.dataSource = self
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArray.count
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = textTableView.dequeueReusableCell(withIdentifier: "aboutUsCell", for: indexPath) as? AboutUsCell {
            cell.configureCell(titleArray[indexPath.row], text: textArray[indexPath.row])
            return cell

        } else {
            return UITableViewCell()
        }
       
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
}
