//
//  AboutAppVC.swift
//  Movie
//
//  Created by Kareem Ismail on 7/19/18.
//  Copyright © 2018 FM2Apps LLC. All rights reserved.
//

import UIKit

class AboutAppVC: UIViewController {

    @IBOutlet weak var topView: CustomSizeUIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        //topView.configureSize()
    }


    @IBAction func backButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
