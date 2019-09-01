//
//  ViewController.swift
//  Elshaer Chat
//
//  Created by Mohamed Elshaer on 3/29/19.
//  Copyright © 2019 Mohamed Elshaer. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @objc func slideToSignUp(_ sender:UIButton){
        let indexPath = IndexPath(row: 1, section: 0)
        self.collectionView.scrollToItem(at: indexPath, at: [.centeredHorizontally], animated: true)
    }
    
    @objc func slideToLogin(_ sender:UIButton){
        let indexPath = IndexPath(row: 0, section: 0)
        self.collectionView.scrollToItem(at: indexPath, at: [.centeredHorizontally], animated: true)
    }
    
    @objc func signUp(_ sender:UIButton){
        let indexPath = IndexPath(row: 1, section: 0)
        let cell = self.collectionView.cellForItem(at: indexPath) as! CollectionViewCell
        guard let emailAddress = cell.emailAddress.text,let password = cell.password.text, let username = cell.userName.text else {
            return
        }
        if emailAddress.isEmpty == true || password.isEmpty == true || username.isEmpty == true{
            self.displayErrorAlert(errorText: "Please Fil The Empty Field", type: "Error")
        } else {
            Auth.auth().createUser(withEmail: emailAddress, password: password) { (result, error) in
                if error == nil {
                    guard let userID = result?.user.uid,let userName = cell.userName.text else {
                        return
                    }
                    let ref = Database.database().reference()
                    let users = ref.child("users").child(userID)
                    let dataArray:[String:Any] = ["username":userName]
                    users.setValue(dataArray)
                    self.dismiss(animated: true, completion: nil)
                    //self.displayErrorAlert(errorText: "You Have Been Sussfuly SignUp", type: "Done")
                } else {
                    self.displayErrorAlert(errorText: error as! String, type: "Error")
                }
            }
        }
    }
    
    @objc func login(_ sender:UIButton){
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = self.collectionView.cellForItem(at: indexPath) as! CollectionViewCell
        guard let emailAddress = cell.emailAddress.text,let password = cell.password.text else {
            return
        }
        if emailAddress.isEmpty == true || password.isEmpty == true {
            self.displayErrorAlert(errorText: "Please Fil The Empty Field", type: "Error")
        } else {
            Auth.auth().signIn(withEmail: emailAddress, password: password) { (result, error) in
                if error == nil {
                    self.dismiss(animated: true, completion: nil)
                } else {
                    self.displayErrorAlert(errorText: error as! String, type: "Error")
                }
            }
        }
    }

    func displayErrorAlert(errorText:String,type:String){
        let alert = UIAlertController.init(title: type, message: errorText, preferredStyle: .alert)
        let action = UIAlertAction(title: "Okay", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert,animated: true,completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "formCell", for: indexPath) as! CollectionViewCell
        if indexPath.row == 0 {
            cell.userNameCon.isHidden = true
            cell.actionButton.setTitle("Login", for: .normal)
            cell.slideButton.setTitle("Sign Up 👉", for: .normal)
            cell.slideButton.addTarget(self, action: #selector(slideToSignUp(_:)), for: .touchUpInside)
        } else {
            cell.userNameCon.isHidden = false
            cell.actionButton.setTitle("Sign Up", for: .normal)
            cell.slideButton.setTitle("Sign In 👈", for: .normal)
            cell.slideButton.addTarget(self, action: #selector(slideToLogin(_:)), for: .touchUpInside)
            cell.actionButton.addTarget(self, action: #selector(signUp(_:)), for: .touchUpInside)

        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }
    
}

