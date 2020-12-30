//
//  ChatRoomViewController.swift
//  Elshaer Chat
//
//  Created by Mohamed Elshaer on 4/5/19.
//  Copyright © 2019 Mohamed Elshaer. All rights reserved.
//

import UIKit
import Firebase

class ChatRoomViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var theMessage: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var room:Room?
    var message = [Message]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        observeMessages()
        title = room?.roomName
    }
    
    func observeMessages(){
        
        guard let theRoomID = self.room?.roomID,theRoomID.isEmpty == false else {
            return
        }
        let ref = Database.database().reference()
        ref.child("Rooms").child(theRoomID).child("Messages").observe(.childAdded) { (snap) in
            if let data = snap.value as? [String:Any] {
                guard let sender = data["SenderName"] as? String,let message =  data["Text"] as? String,let theSender =  data["SenderID"] as? String else {
                    return
                }
                let theMessage = Message.init(messageID: snap.key, senderName: sender, textMessage: message, senderID:theSender)
                self.message.append(theMessage)
                self.tableView.reloadData()
            }
        }
    }
    
    func getUserNameWithID(id:String,comp: @escaping (_ name:String?) -> Void ){
        
        let ref = Database.database().reference()
        let user = ref.child("users").child(id)
        user.child("username").observeSingleEvent(of: .value) { (snap) in
            if let userName = snap.value as? String {
                comp(userName)
            } else {
                comp(nil)
            }
        }
    }
    
    func sendMessage(text:String,userID:String,comp: @escaping (_ isSucess:Bool) -> Void ){
        
        let ref = Database.database().reference()
        getUserNameWithID(id: userID) { (user) in
            if let userName = user {
                if let roomID = self.room?.roomID , let senderID = Auth.auth().currentUser?.uid {
                    let data:[String:Any] = ["SenderName":userName,"Text":text,"SenderID":senderID]
                    let theRoom = ref.child("Rooms").child(roomID)
                    theRoom.child("Messages").childByAutoId().setValue(data, withCompletionBlock: { (error, ref) in
                        if error == nil {
                            comp(true)
                            
                        } else {
                            comp(false)
                        }
                    })
                }
            }
        }
    }
    
    @IBAction func pressSend(_ sender: UIButton) {
        guard let chat = self.theMessage.text,chat.isEmpty == false, let userID = Auth.auth().currentUser?.uid else {
            return
        }
        sendMessage(text: chat, userID: userID) { (isSucess) in
            if isSucess {
                self.theMessage.text = ""
                print("Done")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return message.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "ChatCell") as! ChatRoomTableViewCell
//        cell.userName.text = self.message[indexPath.row].senderName
//        cell.textView.text = self.message[indexPath.row].textMessage
        let message = self.message[indexPath.row]
        cell.setMessageData(message: message)
        if message.senderID == Auth.auth().currentUser!.uid {
            cell.setTextViewType(type: .outgoing)
        }else {
            cell.setTextViewType(type: .incoming)
        }
        return cell
    }
    
}
