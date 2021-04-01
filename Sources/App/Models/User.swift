//
//  User.swift
//  
//
//  Created by 강민석 on 2021/03/31.
//

import Fluent
import Vapor

final class User: Model {
    static let schema = "users"
    
    /// idx
    @ID(key: .id)
    var id: UUID?
    
    /// 이름
    @Field(key: "name")
    var name: String
    
    /// 생년월일
    @Field(key: "birth_date")
    var birthDate: Date
    
    /// 전화번호
    @Field(key: "phone")
    var phone: String
    
    /// 이메일
    @Field(key: "email")
    var email: String
    
    init() {}
    
    init(id: UUID? = nil, name: String, birthDate: Date, phone: String, email: String) {
        self.id = id
        self.name = name
        self.birthDate = birthDate
        self.phone = phone
        self.email = email
    }
}
