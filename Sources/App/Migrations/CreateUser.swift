//
//  CreateUser.swift
//  
//
//  Created by 강민석 on 2021/03/24.
//

import Fluent

/// User 모델 마이그레이션
struct CreateUser: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema("users")
            .id()
            .field("name", .string)
            .field("birth_date", .date)
            .field("phone", .string)
            .field("email", .string)
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("users").delete()
    }
}
