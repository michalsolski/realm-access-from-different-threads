//
//  UserStorage.swift
//  RealmMultiThreadExample
//
//  Created by Michał Solski on 06/02/2021.
//

import Foundation

protocol UserStorage {
    func write(items: [User])
    func remove(primaryKey: String)
    func read(primaryKey: String) -> User?
    func readAll() -> [User]
    func removeAll()
    func usersBy(tag: User.Tag) -> [User]
}

class UserStorageImpl: DatabaseModelsStorage<User, UserDBModel>, UserStorage {
    
    override func mapToDomainModel(_ dbItem: UserDBModel) -> User {
        User.fromDBModel(dbModel: dbItem)
    }
    
    override func mapToDatabaseModel(_ domainItem: User) -> UserDBModel {
        domainItem.toDBModel()
    }
    
    func usersBy(tag: User.Tag) -> [User] {
        return database.read(loadFuncion: { (realm) -> [UserDBModel] in
            Array(realm.objects(UserDBModel.self).filter({ $0.tags.contains(tag.rawValue) }))
        }, mapping: self.mapToDomainModel)
    }
}
