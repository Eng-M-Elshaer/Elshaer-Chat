//
//  RoomsVC.swift
//  Elshaer Chat
//
//  Created by Mohamed Elshaer on 3/29/19.
//  Copyright © 2019 Mohamed Elshaer. All rights reserved.
//

import UIKit
import Firebase

class RoomsVC: UIViewController {
    
    //MARK:- Outlet
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var roomName: UITextField!
    
    //MARK:- Properties
    var rooms = [Room]()
    
    //MARK:- Lifecycle Method
    override func viewDidLoad() {
        super.viewDidLoad()
        observeRooms()
//        let reference = Database.database().reference()
//        let rooms = reference.child(Childs.rooms).childByAutoId()
    }
    override func viewDidAppear(_ animated: Bool) {
        if Auth.auth().currentUser == nil {
            logOut()
        }
    }
    
    //MARK:- Actions
    @IBAction func logOutBtnTapped(_ sender: UIButton) {
        try! Auth.auth().signOut()
        logOut()
    }
    @IBAction func createRoomBtnTapped(_ sender: UIButton) {
        guard let theRoomName = self.roomName.text,
              theRoomName.isEmpty == false else {return}
        let ref = Database.database().reference()
        let rooms = ref.child(Childs.rooms).childByAutoId()
        let dataArray: [String: Any] = ["roomName": theRoomName]
        rooms.setValue(dataArray) { (error, dataRef) in
            if error == nil {
                self.roomName.text = ""
            } else {
                
            }
        }
    }
}

//MARK:- Private Method
extension RoomsVC {
    private func observeRooms(){
        let ref =  Database.database().reference()
        ref.child(Childs.rooms).observe(.childAdded) { (result) in
            if let data = result.value as? [String: Any] {
                if let room = data["roomName"] as? String {
                    let theRoom = Room.init(roomID: result.key, roomName: room)
                    self.rooms.append(theRoom)
                    self.tableView.reloadData()
                }
            }
        }
    }
    private func logOut(){
        let LoginSreen = self.storyboard?.instantiateViewController(withIdentifier: "MainVC") as! MainVC
        self.present(LoginSreen,animated: true,completion: nil)
    }
}

//MARK:- UITableViewDataSource, UITableViewDelegate
extension RoomsVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chat = self.storyboard?.instantiateViewController(withIdentifier: "ChatRoom") as! ChatRoomVC
        chat.room = self.rooms[indexPath.row]
        self.navigationController?.pushViewController(chat, animated: true)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rooms.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Cells.roomCell)!
        cell.textLabel?.text = rooms[indexPath.row].roomName
        return cell
    }
}
