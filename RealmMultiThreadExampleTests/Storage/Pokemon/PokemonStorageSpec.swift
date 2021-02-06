//
//  PokemonStorageSpec.swift
//  RealmMultiThreadExample
//
//  Created by Michał Solski on 06/02/2021.
//  
//

import Foundation
import Quick
import Nimble
@testable import RealmMultiThreadExample

class PokemonStorageSpec: QuickSpec {
    
    override func spec() {
        
        var testableDatabase: DatabaseStorage!
        var sut: PokemonStorage!
        
        beforeEach {
            testableDatabase = TestableDatabaseStorage()
            sut = PokemonStorageImpl(databaseStorage: testableDatabase)
        }
        
        afterEach {
            sut = nil
        }
        
        describe("Pokemon storage") {
            it("should write signle pokemon") {
                sut.write(item: .sample())
                
                expect(sut.readAll().count).to(equal(1))
                expect(sut.readAll().first).to(equal(Pokemon.sample()))
            }
            
            it("should append pokemons") {
                sut.write(item: .sample(pokedexId: "1"))
                sut.write(item: .sample(pokedexId: "2"))
                sut.write(item: .sample(pokedexId: "3"))
                
                expect(sut.readAll().count).to(equal(3))
                expect(sut.readAll()[0].pokedexId).to(equal("1"))
                expect(sut.readAll()[1].pokedexId).to(equal("2"))
                expect(sut.readAll()[2].pokedexId).to(equal("3"))
            }
            
            it("should write in main thread and read from background thread") {
                assert(Thread.isMainThread)
                sut.write(items: Pokemon.samples())
                
                var backgroundCheckFinished = false
                DispatchQueue.global(qos: .background).async {
                    let pokemons = sut.readAll()
                    
                    expect(pokemons.count).to(equal(12))
                    expect(pokemons.first?.name).to(equal("Name for 7"))
                    expect(pokemons.last?.name).to(equal("Name for 3"))
                    backgroundCheckFinished = true
                }
                expect(backgroundCheckFinished).toEventually(beTrue())
            }
            
            it("should write in background thread and read in main thread") {
                assert(Thread.isMainThread)
                var backgroundWriteFinished = false
                DispatchQueue.global(qos: .background).async {
                    sut.write(items: Pokemon.samples())
                    backgroundWriteFinished = true
                }
                
                expect(backgroundWriteFinished).toEventually(beTrue())
                let pokemons = sut.readAll()
                expect(pokemons.count).to(equal(12))
                expect(pokemons.first?.name).to(equal("Name for 7"))
                expect(pokemons.last?.name).to(equal("Name for 3"))
            }
            
            it("should remove all water type pokemons") {
                sut.write(items: Pokemon.samples())
                assert(sut.read(primaryKey: "3")?.type == .water)
                
                sut.removeAllWith(type: .water)
                
                let remainingPokemons = sut.readAll()
                expect(remainingPokemons.count).to(equal(10))
                expect(sut.read(primaryKey: "1")?.type).to(equal(.bug))
                expect(sut.read(primaryKey: "3")).to(beNil())
                expect(remainingPokemons.filter({ $0.type == .water }).count).to(equal(0))
            }
            
            it("should remove all") {
                sut.write(items: Pokemon.samples())
                assert(sut.readAll().count == 12)
                
                sut.removeAll()
                
                expect(sut.readAll().count).to(equal(0))
            }
            
            it("should remove specific pokemon") {
                sut.write(items: Pokemon.samples())
                assert(sut.readAll().count == 12)
                assert(sut.read(primaryKey: "53") != nil)
                
                sut.remove(primaryKey: "53")
                
                expect(sut.readAll().count).to(equal(11))
                expect(sut.read(primaryKey: "53")).to(beNil())
            }
            
            it("should remove specific pokemons") {
                sut.write(items: Pokemon.samples())
                assert(sut.readAll().count == 12)
                assert(sut.read(primaryKey: "53") != nil)
                assert(sut.read(primaryKey: "21") != nil)
                assert(sut.read(primaryKey: "64") != nil)
                
                sut.remove(primaryKeys: ["53", "21", "64"])
                
                expect(sut.readAll().count).to(equal(9))
                expect(sut.read(primaryKey: "53")).to(beNil())
                expect(sut.read(primaryKey: "21")).to(beNil())
                expect(sut.read(primaryKey: "64")).to(beNil())
            }
            
            it("should update pokemon properties") {
                sut.write(items: Pokemon.samples())
                assert(sut.read(primaryKey: "7")?.type == .rock)
                assert(sut.read(primaryKey: "7")?.name == "Name for 7")
                
                var pokemon = sut.read(primaryKey: "7")!
                pokemon.name = "Squirtle"
                pokemon.type = .water
                sut.write(item: pokemon)
                
                expect(sut.read(primaryKey: "7")?.type).to(equal(.water))
                expect(sut.read(primaryKey: "7")?.name).to(equal("Squirtle"))
            }
        }
    }
}
