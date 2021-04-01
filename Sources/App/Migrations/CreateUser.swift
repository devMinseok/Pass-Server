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
            .field("username", .string, .required)
            .field("password_hash", .string, .required)
            .field("birth_date", .string, .required)
            .field("phone", .string, .required)
            .field("email", .string, .required)
            .field("created_at", .datetime, .required)
            .field("updated_at", .datetime, .required)
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("users").delete()
    }
}
