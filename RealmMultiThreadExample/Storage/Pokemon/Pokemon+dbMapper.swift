//
//  Pokemon+dbMapper.swift
//  RealmMultiThreadExample
//
//  Created by Michał Solski on 06/02/2021.
//  
//

import Foundation

extension Pokemon: DBMapper {
    func toDBModel() -> PokemonDBModel {
        let dbModel = PokemonDBModel()
        dbModel.name = name
        dbModel.pokedexId = pokedexId
        dbModel.type = type.rawValue
        return dbModel
    }
    
    static func fromDBModel(dbModel: PokemonDBModel) -> Pokemon {
        return Pokemon(pokedexId: dbModel.pokedexId,
                       name: dbModel.name,
                       type: Pokemon.PokemonType(rawValue: dbModel.type)!)
    }
}
