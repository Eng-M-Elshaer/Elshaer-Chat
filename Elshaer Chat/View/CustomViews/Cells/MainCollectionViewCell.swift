//
//  MainCollectionViewCell.swift
//  Elshaer Chat
//
//  Created by Mohamed Elshaer on 3/29/19.
//  Copyright © 2019 Mohamed Elshaer. All rights reserved.
//

import UIKit

class MainCollectionViewCell: UICollectionViewCell {
    
    //MARK:- Outlet
    @IBOutlet weak var userNameView: UIView!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var emailAddressTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var slideButton: UIButton!
    
    func configuration(indexPath: Int){
        if indexPath == 0 {
            self.userNameView.isHidden = true
            self.actionButton.setTitle("Login", for: .normal)
            self.slideButton.setTitle("Sign Up 👉", for: .normal)
        } else {
            self.userNameView.isHidden = false
            self.actionButton.setTitle("Sign Up", for: .normal)
            self.slideButton.setTitle("Sign In 👈", for: .normal)
        }
    }
}
