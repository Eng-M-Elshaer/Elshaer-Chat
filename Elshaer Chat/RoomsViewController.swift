//
//  RoomsViewController.swift
//  Elshaer Chat
//
//  Created by Mohamed Elshaer on 3/29/19.
//  Copyright © 2019 Mohamed Elshaer. All rights reserved.
//

import UIKit
import Firebase

class RoomsViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var roomName: UITextField!
    
    var rooms = [Room]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        observeRooms()
        let ref =  Database.database().reference()
        let rooms = ref.child("Rooms").childByAutoId()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if Auth.auth().currentUser == nil {
            lOut()
        }
    }
    
    func observeRooms(){
        let ref =  Database.database().reference()
        ref.child("Rooms").observe(.childAdded) { (result) in
            if let data = result.value as? [String:Any] {
                if let room = data["roomName"] as? String {
                    let theRoom = Room.init(roomID: result.key, roomName: room)
                    self.rooms.append(theRoom)
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func lOut(){
        let LoginSreen = self.storyboard?.instantiateViewController(withIdentifier: "LoginSreen") as! ViewController
        self.present(LoginSreen,animated: true,completion: nil)
    }
    
    @IBAction func logOut(_ sender: Any) {
        try! Auth.auth().signOut()
        lOut()
    }
    
    @IBAction func createRoom(_ sender: Any) {
        guard let theRoomName = self.roomName.text, theRoomName.isEmpty == false else {
            return
        }
        let ref =  Database.database().reference()
        let rooms = ref.child("Rooms").childByAutoId()
        let dataArray:[String:Any] = ["roomName":theRoomName]
        rooms.setValue(dataArray) { (error, dataRef) in
            if error == nil {
                self.roomName.text = ""
            } else {
                
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chat = self.storyboard?.instantiateViewController(withIdentifier: "ChatRoom") as! ChatRoomViewController
        chat.room = self.rooms[indexPath.row]
        self.navigationController?.pushViewController(chat, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rooms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RoomCell")!
        cell.textLabel?.text = rooms[indexPath.row].roomName
        return cell
    }
    
}
