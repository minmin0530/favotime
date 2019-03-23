//
//  LoginViewController.swift
//  favotime
//
//  Created by IzumiYoshiki on 2019/03/16.
//  Copyright © 2019 Yoshiki Izumi. All rights reserved.
//

import UIKit
import SocketIO
import RealmSwift

class LoginViewController: UIViewController {
    
    let realm = try! Realm()

    
    var manager = SocketManager(socketURL: URL(string: "https://ai6.jp")!, config: [.forceWebsockets(true)])
    var socket: SocketIOClient! //= self.manager.defaultSocket

    @IBOutlet weak var mailAddressTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var displayNameTextField: UITextField!
    @IBAction func handleLoginButton(_ sender: Any) {
        test()
    }
    @IBAction func createAccountButton(_ sender: Any) {
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        socket = self.manager.defaultSocket

        // Do any additional setup after loading the view.
    }
    

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
            self.socket.emit("from_client", self.mailAddressTextField.text!)
//            self.tableView.reloadData()
            //            }
        }
        socket.on("socket_id") { data0, ack in
            if let msg = data0[0] as? String {
                print(msg);
                let sendData: String =  "{\"socket_id\":\"" + msg + "\",\"userName\":\"" + self.mailAddressTextField.text! + "\",\"password\":\"" + self.passwordTextField.text! + "\"}"
                var objs: [String:String] = [:]
                do {
                    objs = try JSONDecoder().decode([String:String].self, from: sendData.data(using: .utf8)!)
                } catch {
                    
                }
                
                self.socket.emit("login", objs);
            }
        }
        socket.on("login_fail") { data0, ack in
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
                        print("login fail.")
                        print(next["userName"] as! String) // 1, 2 が表示
                    }
                } catch {
                    print(error) // パースに失敗したときにエラーを表示
                }
            } catch {
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
                        
                        let login = Login()
                        login.id = 1
                        login.logined = true
                        try! self.realm.write {
                            self.realm.add(login, update: true)
                        }
                        self.dismiss(animated: true, completion: nil)

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
        /*
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
        }*/
        socket.connect()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
