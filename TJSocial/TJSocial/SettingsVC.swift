//
//  SettingsVC.swift
//  TJSocial
//
//  Created by Admin on 8/17/17.
//  Copyright © 2017 TJSchoost. All rights reserved.
//

import UIKit

class SettingsVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var usernameTxt: FancyField!
    @IBOutlet weak var profilePicture: CircleView!
    
    var settingsImgPicker: UIImagePickerController!
    var settingsImgSelected = true

    override func viewDidLoad() {
        super.viewDidLoad()

        settingsImgPicker = UIImagePickerController()
        settingsImgPicker.allowsEditing = true
        settingsImgPicker.delegate = self
        
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
        
    }
    
    @IBAction func profileImgTapped(_ sender: Any) {
        present(settingsImgPicker, animated: true, completion: nil)
    }

}
