//
//  SettingsVC.swift
//  TJSocial
//
//  Created by Admin on 8/17/17.
//  Copyright © 2017 TJSchoost. All rights reserved.
//

import UIKit
import Firebase

class SettingsVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var usernameTxt: FancyField!
    @IBOutlet weak var profilePicture: CircleView!
    @IBOutlet weak var message: UILabel!
    
    var settingsImgPicker: UIImagePickerController!
    var settingsImgSelected = true

    override func viewDidLoad() {
        super.viewDidLoad()

        settingsImgPicker = UIImagePickerController()
        settingsImgPicker.allowsEditing = true
        settingsImgPicker.delegate = self
        
        usernameTxt.delegate = self
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            profilePicture.image = image
            settingsImgSelected = true
        } else {
            print("MITCHELL: A valid image wasn't selected")
        }
        
        settingsImgPicker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func setUsernameBtn(_ sender: Any) {
        guard let username = usernameTxt.text, username != "" else {
            print("MITCHELL: Caption must be entered")
            message.text = "Caption must be entered"
            return
        }
        
        guard let img = profilePicture.image, settingsImgSelected == true else {
            print("MITCHELL: An image must be selected")
            message.text = "An image must be selected"
            return
        }
        
        if let imgData = UIImageJPEGRepresentation(img, 0.2) {
            
            let imgUid = NSUUID().uuidString
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            
            DataService.ds.REF_PROFILE_IMAGES.child(imgUid).putData(imgData, metadata: metadata, completion: { (metadata, error) in
                if error != nil {
                    print("MITCHELL: Unable to upload image to Firebase storage")
                } else {
                    print("MITCHELL: Successfully uploaded image to Firebase storage")
                    self.message.text = ""
                    self.usernameTxt.resignFirstResponder()
                    let downloadURL = metadata?.downloadURL()?.absoluteString
                    if let url = downloadURL {
                        self.postToFirebase(imgUrl: url)
                    }
                }
            })
        }
        
        performSegue(withIdentifier: SETTINGS_TO_FEED, sender: nil)
    }
    
    func postToFirebase(imgUrl: String) {
        let post: Dictionary<String, AnyObject> = [
            "username": usernameTxt.text! as AnyObject,
            "profile-pic": imgUrl as AnyObject,
        ]
        
        let firebasePost = DataService.ds.REF_USERS.childByAutoId()
        firebasePost.setValue(post)
        
        usernameTxt.text = ""
        settingsImgSelected = false
    }
    
    @IBAction func profileImgTapped(_ sender: Any) {
        present(settingsImgPicker, animated: true, completion: nil)
    }

}
