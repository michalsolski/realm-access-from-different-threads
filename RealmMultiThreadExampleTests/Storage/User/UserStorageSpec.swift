//
//  UserStorageSpec.swift
//  RealmMultiThreadExample
//
//  Created by Michał Solski on 06/02/2021.
//  
//

import Foundation
import Quick
import Nimble
@testable import RealmMultiThreadExample

class UserStorageSpec: QuickSpec {
    
    override func spec() {
        var testableDatabase: DatabaseStorage!
        var sut: UserStorage!
        
        beforeEach {
            testableDatabase = TestableDatabaseStorage()
            sut = UserStorageImpl(databaseStorage: testableDatabase)
        }
        
        afterEach {
            sut = nil
        }
        
        describe("User storage") {
            
            it("should save users") {
                sut.write(items: User.samples)
                
                expect(sut.readAll().count).to(equal(6))
                expect(sut.read(primaryKey: "6A")).to(equal(User.samples.last))
            }
            
            it("should remove specific user") {
                sut.write(items: User.samples)
                assert(sut.read(primaryKey: "4A") != nil)
                
                sut.remove(primaryKey: "4A")
                
                expect(sut.readAll().count).to(equal(5))
                expect(sut.read(primaryKey: "4A")).to(beNil())
            }
            
            it("should remove all users") {
                sut.write(items: User.samples)
                assert(sut.readAll().count == 6)
                
                sut.removeAll()
                
                expect(sut.readAll().count).to(equal(0))
            }
            
            it("should return premium users") {
                sut.write(items: User.samples)
                assert(sut.readAll().count == 6)
                
                let premiumUsers = sut.usersBy(tag: .premium)
                
                expect(premiumUsers.count).to(equal(3))
                expect(premiumUsers.contains(where: { $0.id == "3A" })).to(beTrue())
                expect(premiumUsers.contains(where: { $0.id == "4A" })).to(beTrue())
                expect(premiumUsers.contains(where: { $0.id == "6A" })).to(beTrue())
            }
            
            it("should update user phone number") {
                sut.write(items: User.samples)
                assert(sut.read(primaryKey: "4A")?.phoneNumber == "(131)-449-3655")
                
                var user = sut.read(primaryKey: "4A")!
                user.phoneNumber = "123456789"
                sut.write(items: [user])
                
                expect(sut.read(primaryKey: "4A")?.phoneNumber).to(equal("123456789"))
            }
            
            it("should write in main thread and read from background thread") {
                assert(Thread.isMainThread)
                sut.write(items: User.samples)
                
                var backgroundCheckFinished = false
                DispatchQueue.global(qos: .background).async {
                    let users = sut.readAll()
                    
                    expect(users.count).to(equal(6))
                    expect(users.first?.firstName).to(equal("Tammy"))
                    expect(users.last?.firstName).to(equal("Lonnie"))
                    backgroundCheckFinished = true
                }
                expect(backgroundCheckFinished).toEventually(beTrue())
            }
            
            it("should write in background thread and read in main thread") {
                assert(Thread.isMainThread)
                var backgroundWriteFinished = false
                DispatchQueue.global(qos: .background).async {
                    sut.write(items: User.samples)
                    backgroundWriteFinished = true
                }
                
                expect(backgroundWriteFinished).toEventually(beTrue())
                let users = sut.readAll()
                expect(users.count).to(equal(6))
                expect(users.first?.firstName).to(equal("Tammy"))
                expect(users.last?.firstName).to(equal("Lonnie"))
            }
        }
    }
}
