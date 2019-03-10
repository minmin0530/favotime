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

    var manager = SocketManager(socketURL: URL(string: "https://ai6.jp")!, config: [.forceWebsockets(true)])
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

        /*
        let url = URL(string: "https://ai6.jp")
        var request = URLRequest(url: url!)
        // POSTを指定
        request.httpMethod = "POST"
        // POSTするデータをBodyとして設定
        request.httpBody = "userName=test&password=test".data(using: .utf8)
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if error == nil, let data = data, let response = response as? HTTPURLResponse {
                // HTTPヘッダの取得
                print("Content-Type: \(response.allHeaderFields["Content-Type"] ?? "")")
                // HTTPステータスコード
                print("statusCode: \(response.statusCode)")
                print(String(data: data, encoding: .utf8) ?? "")
            }
            }.resume()
        */
        
        test()
    }
//    let json = "[{\"a\":\"1\"},{\"b\":\"2\"}]".data(using: .utf8)!
//    let decoder = JSONDecoder()

    func test() {
        manager = SocketManager(socketURL: URL(string: "https://ai6.jp")!, config: [.forceWebsockets(true)])
        socket = self.manager.defaultSocket
        socket.on("connect") { data0, ack in
            print("socket connected")
            print("send message")
//            if self.sendFlag == true {
//                self.sendFlag = false

            var objs: [String:String] = [:]
            do {
                objs = try JSONDecoder().decode([String:String].self, from: "{\"userName\":\"1\",\"password\":\"2\"}".data(using: .utf8)!)
            } catch {
                
            }
            self.socket.emit("login", objs);
            //    self.socket.emit("from_client", self.temp)
                self.tableView.reloadData()
//            }
        }
        socket.on("logined") { data, ack in
            self.socket.emit("from_client", "aaa");
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

