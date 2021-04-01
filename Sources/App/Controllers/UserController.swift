//
//  File.swift
//  
//
//  Created by 강민석 on 2021/04/01.
//

import Vapor
import Fluent

struct UserSignup: Content {
    let username: String
    let password: String
    let birthDate: Date
    let phone: String
    let email: String
}

struct NewSession: Content {
    let token: String
    let user: User.Public
}

extension UserSignup: Validatable {
    static func validations(_ validations: inout Validations) {
        validations.add("username", as: String.self, is: !.empty)
        validations.add("password", as: String.self, is: .count(6...))
        validations.add("phone", as: String.self, is: !.empty)
        validations.add("email", is: .email)
    }
}

struct UserController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        
        /// 사용자 라우터
        let usersRoute = routes.grouped("users")
        
        /// 토큰 인증필요
        let tokenProtected = usersRoute.grouped(Token.authenticator())
        
        /// 비밀번호 보호
        let passwordProtected = usersRoute.grouped(User.authenticator())
        
        // MARK: - 회원가입
        usersRoute.post("signup", use: create)
        
        // MARK: - 내 정보 확인
        tokenProtected.get("me", use: getMyOwnUser)
        
        // MARK: - 로그인
        passwordProtected.post("login", use: login)
    }
    
    fileprivate func create(req: Request) throws -> EventLoopFuture<NewSession> {
        try UserSignup.validate(content: req)
        let userSignup = try req.content.decode(UserSignup.self)
        let user = try User.create(from: userSignup)
        var token: Token!
        
        return checkIfUserExists(userSignup.username, req: req).flatMap { exists in
            guard !exists else {
                return req.eventLoop.future(error: UserError.usernameTaken)
            }
            
            return user.save(on: req.db)
        }.flatMap {
            guard let newToken = try? user.createToken(source: .signup) else {
                return req.eventLoop.future(error: Abort(.internalServerError))
            }
            token = newToken
            return token.save(on: req.db)
        }.flatMapThrowing {
            NewSession(token: token.value, user: try user.asPublic())
        }
    }
    
    fileprivate func login(req: Request) throws -> EventLoopFuture<NewSession> {
        let user = try req.auth.require(User.self)
        let token = try user.createToken(source: .login)
        
        return token.save(on: req.db).flatMapThrowing {
            NewSession(token: token.value, user: try user.asPublic())
        }
    }
    
    func getMyOwnUser(req: Request) throws -> User.Public {
        try req.auth.require(User.self).asPublic()
    }
    
    private func checkIfUserExists(_ username: String, req: Request) -> EventLoopFuture<Bool> {
        User.query(on: req.db)
            .filter(\.$username == username)
            .first()
            .map { $0 != nil }
    }
}
