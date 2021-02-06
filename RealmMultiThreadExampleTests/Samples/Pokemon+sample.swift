//
//  Pokemon+sample.swift
//  RealmMultiThreadExample
//
//  Created by Michał Solski on 06/02/2021.
//  
//

import Foundation
@testable import RealmMultiThreadExample

extension Pokemon {
    static func sample(pokedexId: String = "1", type: PokemonType = PokemonType.water) -> Pokemon {
        Pokemon(pokedexId: pokedexId, name: "Name for \(pokedexId)", type: type)
    }
    static func samples() -> [Pokemon] {
        [
            .sample(pokedexId: "1", type: .bug),
            .sample(pokedexId: "3", type: .water),
            .sample(pokedexId: "342", type: .bug),
            .sample(pokedexId: "3521", type: .ghost),
            .sample(pokedexId: "32", type: .ghost),
            .sample(pokedexId: "53", type: .bug),
            .sample(pokedexId: "21", type: .water),
            .sample(pokedexId: "64", type: .ground),
            .sample(pokedexId: "62", type: .bug),
            .sample(pokedexId: "2", type: .ground),
            .sample(pokedexId: "4", type: .bug),
            .sample(pokedexId: "7", type: .rock)
        ]
    }
}
