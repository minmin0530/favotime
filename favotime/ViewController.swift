//
//  ViewController.swift
//  favotime
//
//  Created by Yoshiki Izumi on 2019/02/11.
//  Copyright © 2019 Yoshiki Izumi. All rights reserved.
//

import UIKit
import SocketIO

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var manager = SocketManager(socketURL: URL(string: "http://localhost:3000")!, config: [.forceWebsockets(true)])
    var socket: SocketIOClient! //= self.manager.defaultSocket
    var sendFlag :Bool = false
    var temp: String = "temp"
    var messageArray: [String] = ["","","","","","","","","",""]
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.delegate = self
        tableView.dataSource = self
//        messageArray.append(temp)
        socket = self.manager.defaultSocket
        test()
    }

    func test() {
        if sendFlag == true {
            manager = SocketManager(socketURL: URL(string: "http://localhost:3000")!, config: [.forceWebsockets(true)])
            socket = self.manager.defaultSocket
        }
        //        DispatchQueue.global(qos: .userInteractive).async {
        //
        //            DispatchQueue.main.async {
        socket.on("connect") { data, ack in
            print("socket connected")
            
            print("send message")
            if self.sendFlag == true {
                self.sendFlag = false
//                self.socket.connect()
                
                //                CFRunLoopStop(rl)
                self.socket.emit("from_client", self.temp)
                //                CFRunLoopRun()
                
            }
            
        }
        socket.on("from_server") { data, ack in
            if let msg = data[0] as? String {
                print("receive: " + msg)
                self.cellcount += 1

                //         CFRunLoopStop(rl)
                self.temp = msg
//                self.messageArray.append(msg)
                self.tableView.reloadData()
            }
        }
        
        socket.connect()
        
        //      CFRunLoopRun()
        //            }
        //        }
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        let input = segue.destination as! InputViewController
//        let cell = tableView.cellForRow(at: [0, 0])
//        cell?.textLabel?.text = input.textView.text
//        print("aaaaaaaa")
    }
    var cellcount: Int = 0
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        messageArray[cellcount] = temp
        return messageArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        sendFlag = true;
        cell.textLabel?.text = messageArray[indexPath.row]
        return cell
    }
}

