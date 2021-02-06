//
//  DatabaseModelsStorage.swift
//  RealmMultiThreadExample
//
//  Created by Michał Solski on 06/02/2021.
//
//  This is an abstract class wrapping DatabaseStorage access.
//  You should only use this class by overriding methods:
//  mapToDatabaseModel and mapToDomainModel

import Foundation

class DatabaseModelsStorage<T, D: DBModel> { //T - domain model, D - database model
    
    let database: DatabaseStorage
    
    init(databaseStorage: DatabaseStorage = DatabaseStorageImpl()) {
        self.database = databaseStorage
    }
    
    func mapToDatabaseModel(_ domainItem: T) -> D {
        preconditionFailure("Subclass needs to implement a mapper method")
    }
    
    func mapToDomainModel(_ dbItem: D) -> T {
        preconditionFailure("Subclass needs to implement a mapper method")
    }
    
    func write(item: T) {
        database.addOrReplace(items: [item], mapping: self.mapToDatabaseModel)
    }
    
    func write(items: [T]) {
        database.addOrReplace(items: items, mapping: self.mapToDatabaseModel)
    }
    
    func remove(primaryKey: String) {
        database.remove(keys: [primaryKey], ofType: D.self)
    }
    
    func remove(primaryKeys: [String]) {
        database.remove(keys: primaryKeys, ofType: D.self)
    }
    
    func removeAll() {
        database.removeAll(ofType: D.self)
    }
    
    func read(primaryKey: String) -> T? {
        let items = database.read(keys: [primaryKey], mapping: self.mapToDomainModel)
        if items.count > 0 {
            return items[0]
        }
        return nil
    }
    
    func read(primaryKeys: [String]) -> [T] {
        return database.read(keys: primaryKeys, mapping: self.mapToDomainModel)
    }

    func readAll() -> [T] {
        return database.readAll(mapFuncion: self.mapToDomainModel)
    }
}
