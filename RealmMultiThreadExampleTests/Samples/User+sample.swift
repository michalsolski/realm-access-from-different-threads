//
//  User+sample.swift
//  RealmMultiThreadExample
//
//  Created by Michał Solski on 06/02/2021.
//  
//

import Foundation
@testable import RealmMultiThreadExample

extension User {
    static let samples: [User] = {
        [User(id: "1A", firstName: "Javier", lastName: "Wallace",
              login: "javier.wallace", phoneNumber: "(587)-124-0429", tags: [.lowActivity]),
         User(id: "2A", firstName: "Naomi", lastName: "Cooper",
               login: "naomi.cooper", phoneNumber: "(280)-500-8456", tags: []),
         User(id: "3A", firstName: "Vicki", lastName: "Green",
              login: "vicki.green", phoneNumber: "(061)-667-4324", tags: [.subscriber, .premium]),
         User(id: "4A", firstName: "Valerie", lastName: "Graves",
               login: "valerie.graves", phoneNumber: "(131)-449-3655", tags: [.premium]),
         User(id: "5A", firstName: "Tammy", lastName: "Henry",
               login: "tammy.henry", phoneNumber: nil, tags: [.subscriber]),
         User(id: "6A", firstName: "Lonnie", lastName: "Fernandez",
               login: "lonnie.fernandez", phoneNumber: "(543)-000-8876", tags: [.premium])]
    }()
}
