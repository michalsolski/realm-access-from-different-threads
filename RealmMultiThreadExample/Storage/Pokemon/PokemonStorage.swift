//
//  PokemonStorage.swift
//  RealmMultiThreadExample
//
//  Created by Michał Solski on 06/02/2021.
//

import Foundation

protocol PokemonStorage {
    func write(item: Pokemon)
    func write(items: [Pokemon])
    func read(primaryKey: String) -> Pokemon?
    func readAll() -> [Pokemon]
    func remove(primaryKey: String)
    func remove(primaryKeys: [String])
    func removeAll()
    func removeAllWith(type: Pokemon.PokemonType)
}

class PokemonStorageImpl: DatabaseModelsStorage<Pokemon, PokemonDBModel>, PokemonStorage {
    
    func removeAllWith(type: Pokemon.PokemonType) {
        database.write { (realm) in
            let objects = realm.objects(PokemonDBModel.self)
                .filter("type == \(type.rawValue)")
            realm.delete(objects)
        }
    }
    
    override func mapToDomainModel(_ dbItem: PokemonDBModel) -> Pokemon {
        Pokemon.fromDBModel(dbModel: dbItem)
    }
    
    override func mapToDatabaseModel(_ domainItem: Pokemon) -> PokemonDBModel {
        domainItem.toDBModel()
    }
}
