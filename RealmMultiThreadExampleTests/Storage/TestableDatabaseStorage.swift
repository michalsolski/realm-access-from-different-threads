//
//  TestableDatabaseStorage.swift
//  RealmMultiThreadExampleTests
//
//  Created by Michał Solski on 06/02/2021.
//

import Foundation
import Realm
import RealmSwift
@testable import RealmMultiThreadExample

class TestableDatabaseStorage: DatabaseStorageImpl {
    override func createRealm() -> Realm {
        var realmConfig = Realm.Configuration.defaultConfiguration
        realmConfig.fileURL = nil
        realmConfig.inMemoryIdentifier = "unittest.realm"
        let realm = try! Realm(configuration: realmConfig)
        try! realm.write {
            realm.deleteAll()
        }
        return realm
    }
}
