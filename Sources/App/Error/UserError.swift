//
//  File.swift
//  
//
//  Created by 강민석 on 2021/04/01.
//

import Vapor

enum UserError {
    case usernameTaken
}

extension UserError: AbortError {
    var description: String {
        reason
    }
    
    var status: HTTPResponseStatus {
        switch self {
        case .usernameTaken: return .conflict
        }
    }
    
    var reason: String {
        switch self {
        case .usernameTaken: return "Username already taken"
        }
    }
}
