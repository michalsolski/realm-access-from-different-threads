//
//  UserDBModel.swift
//  RealmMultiThreadExample
//
//  Created by Michał Solski on 06/02/2021.
//

import Foundation
import Realm
import RealmSwift

class UserDBModel: DBModel {
    @objc dynamic public var id: String!
    @objc dynamic public var firstName: String!
    @objc dynamic public var lastName: String!
    @objc dynamic public var login: String!
    @objc dynamic public var phoneNumber: String?
    let tags = List<Int>()
    
    override class func primaryKey() -> String? {
        return "id"
    }
}
