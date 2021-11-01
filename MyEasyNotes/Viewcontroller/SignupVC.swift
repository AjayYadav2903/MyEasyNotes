//
//  SignupVC.swift
//  MyEasyNotes
//
//  Created by admin on 12/10/20.
//  Copyright © 2020 admin. All rights reserved.
//

import UIKit

class SignupVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
    }
    
    @IBAction func btnBack(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
}
