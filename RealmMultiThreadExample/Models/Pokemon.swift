//
//  Pokemon.swift
//  RealmMultiThreadExample
//
//  Created by Michał Solski on 06/02/2021.
//

import Foundation

struct Pokemon: Equatable {
    let pokedexId: String
    var name: String
    var type: PokemonType
    
    enum PokemonType: Int {
        case ground
        case rock
        case bug
        case ghost
        case water
    }
}
