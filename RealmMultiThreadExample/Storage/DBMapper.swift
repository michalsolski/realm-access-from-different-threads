//
//  DBMapper.swift
//  RealmMultiThreadExample
//
//  Created by Michał Solski on 06/02/2021.
//

import Foundation

protocol DBMapper {
    associatedtype DomainModel
    associatedtype DatabaseModel
    func toDBModel() -> DatabaseModel
    static func fromDBModel(dbModel: DatabaseModel) -> DomainModel
}
