//
//  User.swift
//  
//
//  Created by 강민석 on 2021/03/31.
//

import Fluent
import Vapor

final class User: Model {
    struct Public: Content {
        let id: UUID
        let username: String
        let birthDate: Date
        let phone: String
        let email: String
        let createdAt: Date?
        let updatedAt: Date?
    }
    
    static let schema = "users"
    
    /// idx
    @ID(key: .id)
    var id: UUID?
    
    /// 이름
    @Field(key: "username")
    var username: String
    
    /// 비밀번호
    @Field(key: "password_hash")
    var passwordHash: String
    
    /// 생일
    @Field(key: "birth_date")
    var birthDate: Date
    
    /// 전화번호
    @Field(key: "phone")
    var phone: String
    
    /// 이메일
    @Field(key: "email")
    var email: String
    
    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?
    
    @Timestamp(key: "updated_at", on: .update)
    var updatedAt: Date?
    
    init() {}
    
    init(id: UUID? = nil, username: String, passwordHash: String, birthDate: Date, phone: String, email: String) {
        self.id = id
        self.username = username
        self.passwordHash = passwordHash
        self.birthDate = birthDate
        self.phone = phone
        self.email = email
    }
}

extension User {
    static func create(from userSignup: UserSignup) throws -> User {
        User(username: userSignup.username,
             passwordHash: try Bcrypt.hash(userSignup.password),
             birthDate: userSignup.birthDate,
             phone: userSignup.phone,
             email: userSignup.email)
    }
    
    func createToken(source: SessionSource) throws -> Token {
        let calendar = Calendar(identifier: .gregorian)
        let expiryDate = calendar.date(byAdding: .month, value: 1, to: Date())
        
        return try Token(userId: requireID(),
                         token: [UInt8].random(count: 16).base64,
                         source: source,
                         expiresAt: expiryDate)
    }
    
    func asPublic() throws -> Public {
        return Public(id: try requireID(),
                      username: username,
                      birthDate: birthDate,
                      phone: phone,
                      email: email,
                      createdAt: createdAt,
                      updatedAt: updatedAt)
    }
}

extension User: ModelAuthenticatable {
    static let usernameKey = \User.$username
    static let passwordHashKey = \User.$passwordHash
    
    func verify(password: String) throws -> Bool {
        try Bcrypt.verify(password, created: self.passwordHash)
    }
}
