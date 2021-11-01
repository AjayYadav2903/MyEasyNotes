//
//  LoginVC.swift
//  Fingerprint
//
//  Created by admin on 03/06/20.
//  Copyright © 2020 admin. All rights reserved.
//

import UIKit


class LoginVC: UIViewController {
    
    @IBOutlet weak var lblWelcomeMsg : UILabel!
    @IBOutlet weak var txtFldName : UITextField!
    @IBOutlet weak var txtFldPassword : UITextField!
    @IBOutlet weak var btnSignUp: UIButton!
    @IBOutlet weak var btnLogin : UIButton!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        setUpUI()
        lblWelcomeMsg.text = "Hauseservices"
    }
    
    func setUpUI()  {
        btnLogin.backgroundColor = UIColor.white
        btnLogin.setTitleColor(UIColor.black, for: .normal)
        self.navigationController?.isNavigationBarHidden = true
        txtFldName.cornerRadius = txtFldName.frame.size.height/2
        txtFldPassword.cornerRadius = txtFldName.frame.size.height/2
        btnSignUp.cornerRadius = txtFldName.frame.size.height/2
        btnLogin.cornerRadius = txtFldName.frame.size.height/2
//        txtFldName.setIconOnTextFieldLeft(UIImage(named: "user")!)
//        txtFldPassword.setIconOnTextFieldLeft(UIImage(named: "password")!)
//        Utils.changePlaceholderColor(txtFld: txtFldPassword, text: "Password")
//        Utils.changePlaceholderColor(txtFld: txtFldName, text: "Employee ID")
        
    }
    
    @IBAction func btnActionSignUp(_ sender: UIButton) {
        //  btnSignUp.backgroundColor = UIColor.white
        //  btnSignUp.setTitleColor(UIColor.black, for: .normal)
        
        //  btnLogin.backgroundColor = UIColor.clear
        //  btnLogin.setTitleColor(UIColor.white, for: .normal)
        let loginStoryBoard = UIStoryboard(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "SignupVC") as! SignupVC
        self.navigationController?.pushViewController(loginStoryBoard, animated: true)
    }
    
    @IBAction func btnActionLogin(_ sender: UIButton) {
//        let loginStoryBoard = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "HomeInfoVC") as! HomeInfoVC
//        self.navigationController?.pushViewController(loginStoryBoard, animated: true)
      //  self.buildNavigationDrawer()
    }
    
 //   func buildNavigationDrawer()
//    {
//        let mainStoryBoard:UIStoryboard = UIStoryboard(name:"Home", bundle:nil)
//        var mainNavigationController = UIViewController()
//
//        mainNavigationController =  mainStoryBoard.instantiateViewController(withIdentifier: "HomeInfoVC") as! HomeInfoVC
//
//        let leftSideMenu : LeftSlideViewController = UIStoryboard(name: "Leftmenu", bundle: nil).instantiateViewController(withIdentifier: "LeftSlideViewController") as! LeftSlideViewController
//
//
//        // Wrap into Navigation controllers
//        let leftSideMenuNav = UINavigationController(rootViewController:leftSideMenu)
//        let centerNavigation = UINavigationController(rootViewController:mainNavigationController)
//
//        // Cerate MMDrawerController
//        //drawerContainer = MMDrawerController(center: mainPage, leftDrawerViewController: leftSideMenuNav)
//        appDelegate.drawerContainer = MMDrawerController(center: centerNavigation, leftDrawerViewController: leftSideMenuNav)
//        // app.mainNav = mainNavigationController
//        appDelegate.drawerContainer?.showsShadow = true
//
//        appDelegate.drawerContainer!.openDrawerGestureModeMask = MMOpenDrawerGestureMode.panningCenterView
//        appDelegate.drawerContainer!.closeDrawerGestureModeMask = MMCloseDrawerGestureMode.panningCenterView
//
//        appDelegate.drawerContainer!.openDrawerGestureModeMask = MMOpenDrawerGestureMode.panningNavigationBar
//        appDelegate.drawerContainer!.closeDrawerGestureModeMask = MMCloseDrawerGestureMode.panningCenterView
//
//        appDelegate.drawerContainer?.closeDrawerGestureModeMask = .tapCenterView
//        appDelegate.drawerContainer?.closeDrawerGestureModeMask = .all
//        // Assign MMDrawerController to our window's root ViewController
//
//        UIApplication.shared.windows.first?.rootViewController = appDelegate.drawerContainer
//        UIApplication.shared.windows.first?.makeKeyAndVisible()
//    }
}
