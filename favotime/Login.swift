//
//  Login.swift
//  favotime
//
//  Created by IzumiYoshiki on 2019/03/23.
//  Copyright © 2019 Yoshiki Izumi. All rights reserved.
//

import RealmSwift

class Login : Object {
    @objc dynamic var id = 0
    
    @objc dynamic var logined = false

    override static func primaryKey() -> String? {
        return "id"
    }
}
