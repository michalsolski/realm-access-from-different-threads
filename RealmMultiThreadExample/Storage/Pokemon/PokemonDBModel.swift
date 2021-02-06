//
//  PokemonDBModel.swift
//  RealmMultiThreadExample
//
//  Created by Michał Solski on 06/02/2021.
//

import Foundation

class PokemonDBModel: DBModel {
    @objc dynamic public var pokedexId: String!
    @objc dynamic public var name: String!
    @objc dynamic public var type: Int = 0
    
    override class func primaryKey() -> String? {
        return "pokedexId"
    }
    
    override class func indexedProperties() -> [String] {
        return ["type"]
    }
}
