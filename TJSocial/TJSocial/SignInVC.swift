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
import SwiftKeychainWrapper

class SignInVC: UIViewController {
    
    @IBOutlet weak var emailField: FancyField!
    @IBOutlet weak var psswdField: FancyField!
    @IBOutlet weak var emailWarning: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let _ = KeychainWrapper.standard.string(forKey: KEY_UID) {
            performSegue(withIdentifier: SEGUE_FEED, sender: nil)
        }
    }

    @IBAction func facebookBtnTapped(_ sender: Any) {
        
        let facebookLogin = FBSDKLoginManager()
        
        facebookLogin.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if error != nil {
                print("MITCHELL Unable to authenticate with Facebook - \(error!)")
                self.emailWarning.text = "Unable to sign-in with Facebook"
            } else if result?.isCancelled == true {
                print("MITCHELL User cancelled Facebook authentication")
                self.emailWarning.text = "User cancelled Facebook authentication"
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
                self.emailWarning.text = "Unable to sign-in. Please try again"
            } else {
                print("MITCHELL Successfully authenticated with Firebase")
                if let user = user {
                    let userData = ["provider": credential.provider]
                    self.completeSignIn(id: user.uid, userData: userData)
                }
            }
        }
    }
    
    @IBAction func signInTapped(_ sender: Any) {
        if let email = emailField.text, !email.isEmpty, let password = psswdField.text, !password.isEmpty {
            Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
                if error == nil {
                    print("MITCHELL: Email user authenticated with Firebase")
                    if let user = user {
                        let userData = ["provider": user.providerID]
                        self.completeSignIn(id: user.uid, userData: userData)
                    }
                } else {
                    Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
                        if error != nil {
                            print("MITCHELL: Unable to authenticate with Firebase using email - \(error!)")
                            self.emailWarning.text = "Unable to sign-in. Password must be 6+ characters"
                        } else {
                            print("MITCHELL: Successfully authenticated with Firebase")
                            self.emailWarning.text = ""
                            if let user = user {
                                let userData = ["provider": user.providerID]
                                self.completeSignIn(id: user.uid, userData: userData)
                            }
                        }
                    })
                }
            })
        }
    }
    
    func completeSignIn(id: String, userData: Dictionary<String, String>) {
        
        DataService.ds.createFirebaseDBUser(uid: id, userData: userData)
        
        let keychainResult = KeychainWrapper.standard.set(id, forKey: KEY_UID)
        print("MITCHELL: Data saved to keychain \(keychainResult)")
        self.emailWarning.text = ""
        performSegue(withIdentifier: SEGUE_FEED, sender: nil)
    }
}
