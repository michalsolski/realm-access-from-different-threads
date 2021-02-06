//
//  User+dbMapper.swift
//  RealmMultiThreadExample
//
//  Created by Michał Solski on 06/02/2021.
//  
//

import Foundation
import RealmSwift

extension User: DBMapper {
    
    func toDBModel() -> UserDBModel {
        let dbModel = UserDBModel()
        dbModel.id = id
        dbModel.firstName = firstName
        dbModel.lastName = lastName
        dbModel.phoneNumber = phoneNumber
        dbModel.login = login
        dbModel.tags.append(objectsIn: tags.map({ $0.rawValue }))
        return dbModel
    }
    
    static func fromDBModel(dbModel: UserDBModel) -> User {
        return User(id: dbModel.id,
                    firstName: dbModel.firstName,
                    lastName: dbModel.lastName,
                    login: dbModel.login,
                    phoneNumber: dbModel.phoneNumber,
                    tags: dbModel.tags.map({ User.Tag(rawValue: $0)! }))
    }
}
