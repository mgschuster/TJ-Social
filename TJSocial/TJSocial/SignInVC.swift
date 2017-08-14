//
//  ViewController.swift
//  TJSocial
//
//  Created by Admin on 8/14/17.
//  Copyright © 2017 TJSchoost. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase

class SignInVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func facebookBtnTapped(_ sender: Any) {
        
        let facebookLogin = FBSDKLoginManager()
        
        facebookLogin.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if error != nil {
                print("MITCHELL Unable to authenticate with Facebook - \(error!)")
            } else if result?.isCancelled == true {
                print("MITCHELL User cancelled Facebook authentication")
            } else {
                print("MITCHELL Successfully authenticated with Facebook")
                let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                self.firebaseAuth(credential)
            }
        }
        
    }
    
    func firebaseAuth(_ credential: AuthCredential) {
        Auth.auth().signIn(with: credential) { (user, error) in
            if error != nil {
                print("MITCHELL Unable to authenticate with Firebase = \(error!)")
            } else {
                print("MITCHELL Successfully authenticated with Firebase")
            }
        }
    }

}

