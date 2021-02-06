//
//  User.swift
//  RealmMultiThreadExample
//
//  Created by Michał Solski on 06/02/2021.
//

import Foundation

struct User: Equatable {
    let id: String
    let firstName: String
    let lastName: String
    let login: String
    var phoneNumber: String?
    let tags: [Tag]
    
    enum Tag: Int {
        case subscriber
        case lowActivity
        case unverified
        case premium
    }
}
