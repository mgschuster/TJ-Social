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
    
    @IBOutlet weak var emailField: FancyField!
    @IBOutlet weak var psswdField: FancyField!
    
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
    
    @IBAction func signInTapped(_ sender: Any) {
        if let email = emailField.text, !email.isEmpty, let password = psswdField.text, !password.isEmpty {
            Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
                if error == nil {
                    print("MITCHELL: Email user authenticated with Firebase")
                } else {
                    Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
                        if error != nil {
                            print("MITCHELL: Unable to authenticate with Firebase using email - \(error!)")
                        } else {
                            print("MITCHELL: Successfully authenticated with Firebase")
                        }
                    })
                }
            })
        }
    }
}
