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
    var loginData    = try! Realm().objects(Login.self)
    
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

        if loginData.count == 0 {
            let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "Login")
            self.present(loginViewController!, animated: true, completion: nil)
        }
        for data in loginData {
            if data.logined != true {
                let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "Login")
                self.present(loginViewController!, animated: true, completion: nil)
            }
        }
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
        
//        test()
    }
    
    func refresh() {
        //再描写するコードを記述
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

//            var objs: [String:String] = [:]
//            do {
//                objs = try JSONDecoder().decode([String:String].self, from: "{\"userName\":\"1\",\"password\":\"2\"}".data(using: .utf8)!)
//            } catch {
//
//            }
//            self.socket.emit("login", objs);
                self.socket.emit("from_client", self.temp)
                self.tableView.reloadData()
//            }
        }
        socket.on("socket_id") { data0, ack in
            if let msg = data0[0] as? String {
                 print(msg);
                let sendData: String =  "{\"socket_id\":\"" + msg + "\",\"userName\":\"testABC\"}"
                var objs: [String:String] = [:]
                do {
                    objs = try JSONDecoder().decode([String:String].self, from: sendData.data(using: .utf8)!)
                } catch {
                    
                }
                
                self.socket.emit("login", objs);
            }
        }
        socket.on("logined") { data0, ack in
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            do {
                let jsonData = try encoder.encode(data0 as? [[String:String]])
                let jsonString = String(data: jsonData, encoding: .utf8)!
                let lecturerData: Data =  jsonString.data(using: String.Encoding.utf8)!
                
                // JSONデータの読み込みとデータの取り出し
                do {
                    let json = try JSONSerialization.jsonObject(with: lecturerData, options: JSONSerialization.ReadingOptions.allowFragments) // JSONの読み込み
                    let top = json as! NSArray // トップレベルが配列
                    for roop in top {
                        let next = roop as! NSDictionary
                        print(next["userName"] as! String) // 1, 2 が表示
                        
//                        let content = next["info"] as! NSDictionary
//                        print(content["age"] as! Int) // 40, 50 が表示
                    }
                } catch {
                    print(error) // パースに失敗したときにエラーを表示
                }
                
                
                
                
            } catch {
                
            }

//            if let msg = data0[0] as? String {
//                print("@@@");
//                print("@" + msg);
//
//
//
//
//
////                self.socket.emit("from_client", "aaa");
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
        socket.on("disconnect") { data0, ack in
            let login = Login()
            login.id = 1
            login.logined = false

            try! self.realm.write {
                self.realm.add(login, update: true)
            }
            print("disconnect!!!")

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

