//
//  Content.swift
//  favotime
//
//  Created by IzumiYoshiki on 2019/02/16.
//  Copyright © 2019 Yoshiki Izumi. All rights reserved.
//

import RealmSwift

class Content : Object {
    @objc dynamic var id = 0
    
    @objc dynamic var contents = ""
    
    @objc dynamic var date = Date()
        
    override static func primaryKey() -> String? {
        return "id"
    }
}
