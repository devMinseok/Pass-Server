//
//  CreateUser.swift
//  
//
//  Created by 강민석 on 2021/03/31.
//

import Fluent

class CreateUser: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema("users")
            .id()
            .field("name", .string)
            .field("birth_date", .string)
            .field("phone", .string)
            .field("email", .string)
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("users").delete()
    }
}
