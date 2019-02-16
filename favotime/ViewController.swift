//
//  ViewController.swift
//  favotime
//
//  Created by Yoshiki Izumi on 2019/02/11.
//  Copyright © 2019 Yoshiki Izumi. All rights reserved.
//

import UIKit
import SocketIO
import RealmSwift

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let realm = try! Realm()
    var contentArray = try! Realm().objects(Content.self).sorted(byKeyPath: "date", ascending: false)

    var manager = SocketManager(socketURL: URL(string: "http://localhost:3000")!, config: [.forceWebsockets(true)])
    var socket: SocketIOClient! //= self.manager.defaultSocket
    var sendFlag :Bool = false
    var serveFlag :Bool = false
    var temp: String = "temp"
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.delegate = self
        tableView.dataSource = self
        socket = self.manager.defaultSocket

        test()
    }

    func test() {
        manager = SocketManager(socketURL: URL(string: "http://localhost:3000")!, config: [.forceWebsockets(true)])
        socket = self.manager.defaultSocket
        socket.on("connect") { data, ack in
            print("socket connected")
            print("send message")
//            if self.sendFlag == true {
//                self.sendFlag = false
                self.socket.emit("from_client", self.temp)
                self.tableView.reloadData()
//            }
        }
        socket.on("from_server") { data, ack in
            if let msg = data[0] as? String {
                print("receive: " + msg)
                self.temp = msg
                
                if self.contentArray.count == 0 || self.contentArray[0].contents != self.temp {
                    let content = Content()
                    let allContents = self.realm.objects(Content.self)
                    if allContents.count != 0 {
                        content.id = allContents.max(ofProperty: "id")! + 1
                    }
                    try! self.realm.write {
                        content.contents = self.temp
                        content.date = Date()
                        self.realm.add(content, update: true)
                    }
                }

                
                self.tableView.reloadData()
            }
        }
        socket.connect()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        messageArray[cellcount] = temp
        return contentArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        
        sendFlag = true
        serveFlag = true
        print(indexPath.row)
        cell.textLabel?.text = contentArray[indexPath.row].contents
//        cell.textLabel?.text = messageArray[indexPath.row]
        return cell
    }
}

