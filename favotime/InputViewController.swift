//
//  InputViewController.swift
//  favotime
//
//  Created by Yoshiki Izumi on 2019/02/11.
//  Copyright © 2019 Yoshiki Izumi. All rights reserved.
//

import UIKit

class InputViewController: UIViewController {

    
    @IBOutlet weak var textView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let homeView = segue.destination as! ViewController
        homeView.temp = self.textView.text
//        homeView.tableView.reloadData()
//        let tv = homeView.tableView
////        tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
//        let cell = tv?.dequeueReusableCell(withIdentifier: "Cell",for: [0, 0])
//        print("@@@"+self.textView.text)
//        cell?.textLabel!.text = self.textView.text
//        tv?.reloadData()
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
