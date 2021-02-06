//
//  DatabaseStorage.swift
//  RealmMultiThreadExample
//
//  Created by Michał Solski on 06/02/2021.
//

import Foundation
import RealmSwift
import Realm

typealias DBModel = Object

protocol DatabaseStorage {
    func remove<T: DBModel>(keys: [String], ofType type: T.Type)
    func removeAll<T: DBModel>(ofType type: T.Type)
    func read<D: DBModel, T>(keys: [String], mapping: @escaping (_ item: D) -> T) -> [T]
    func readAll<D: DBModel, T>(mapFuncion: @escaping (_ item: D) -> T) -> [T]
    func addOrReplace<T, D: DBModel>(items: [T], mapping: @escaping (_ item: T) -> D)

    //to use build in realm internal function such as a filter
    func read<D: DBModel, T>(loadFuncion: @escaping ((_ realm: Realm) -> [D]), mapping: @escaping (_ item: D) -> T) -> [T]
    //as same as above but for writing
    func write(block writeBlock: @escaping ((_ realm: Realm) -> Void ))
}

private let dbDispatch = OneThreadDispatch(label: "DatabaseThread")

class DatabaseStorageImpl: DatabaseStorage {
    var realm: Realm!
    
    init() {
        dbDispatch.sync { [unowned self] in
            self.realm = self.createRealm()
        }
    }
    
    //override it in unit tests or apply migration logic here
    func createRealm() -> Realm {
        return try! Realm()
    }
    
    func remove<T: DBModel>(keys: [String], ofType type: T.Type) {
        dbDispatch.sync {
            let objects = keys.compactMap({ (primaryKey) -> (DBModel)? in
                self.realm.object(ofType: type, forPrimaryKey: primaryKey)
            })
            try! self.realm.write {
                self.realm.delete(objects)
            }
        }
    }
    
    func removeAll<T: DBModel>(ofType type: T.Type) {
        dbDispatch.sync {
            try! self.realm.write {
                let objects = self.realm.objects(type)
                self.realm.delete(objects)
            }
        }
    }
    
    func read<D: DBModel, T>(keys: [String], mapping: @escaping (_ item: D) -> T) -> [T] {
        var values: [T] = []
        dbDispatch.sync {
            let dbItems = keys.compactMap({ self.realm.object(ofType: D.self, forPrimaryKey: $0) })
            values = dbItems.map({ mapping($0) })
        }
        return values
    }
    
    func readAll<D: DBModel, T>(mapFuncion: @escaping (_ item: D) -> T) -> [T] {
        var values: [T] = []
        dbDispatch.sync {
            let dbItems = self.realm.objects(D.self)
            values = dbItems.map({ mapFuncion($0) })
        }
        return values
    }
    
    func addOrReplace<T, D: DBModel>(items: [T], mapping: @escaping (_ item: T) -> D) {
        dbDispatch.sync {
            try! self.realm.write {
                self.realm.add( items.map({ mapping($0) }), update: .all)
            }
        }
    }
    
    func read<D: DBModel, T>(loadFuncion: @escaping ((_ realm: Realm) -> [D]), mapping: @escaping (_ item: D) -> T) -> [T] {
        var values: [T] = []
        dbDispatch.sync {
            let dbItems = loadFuncion(self.realm)
            values = dbItems.map({ mapping($0) })
        }
        return values
    }
    
    func write(block writeBlock: @escaping ((_ realm: Realm) -> Void )) {
        dbDispatch.sync {
            try! self.realm.write {
                writeBlock(self.realm)
            }
        }
    }
}
