//
//  ResponseJSON.swift
//  
//
//  Created by 강민석 on 2021/04/01.
//

import Fluent
import Vapor

enum ResponseStatus: Int, Content {
    // Success
    case OK = 200
    
    // Client Error
    case BadRequest = 400
    case Unauthorized = 401
    case Forbidden = 403
    case NotFound = 404
    case MethodNotAllowed = 405
    
    // Server Error
    case InternalServerError = 500
    case ServiceUnavailable = 503
    case GatewayTimeout = 504
    
    var description: String {
        switch self {
        case .OK:
            return "요청이 성공했습니다."
            
        case .BadRequest:
            return "요청이 실패했습니다."
        case .Unauthorized:
            return "인증이 실패했습니다."
        case .Forbidden:
            return "접근이 거부되었습니다."
        case .NotFound:
            return "존재하지 않는 요청입니다."
        case .MethodNotAllowed:
            return "허용되지 않는 요청입니다."
            
        case .InternalServerError:
            return "요청을 처리하는 중 에러가 발생했습니다."
        case .ServiceUnavailable:
            return "요청을 처리할 수 없습니다."
        case .GatewayTimeout:
            return "시간이 초과되었습니다."
        }
    }
}

struct Empty: Content {}

struct ResponseJSON<T: Content>: Content {
    private var status: ResponseStatus
    private var message: String
    private var data: T?
    
    init(data: T) {
        self.status = .OK
        self.message = status.description
        self.data = data
    }
    
    init(status: ResponseStatus = .OK) {
        self.status = status
        self.message = status.description
        self.data = nil
    }
    
    init(status: ResponseStatus = .OK, message: String = ResponseStatus.OK.description) {
        self.status = status
        self.message = message
        self.data = nil
    }
    
    init(status: ResponseStatus = .OK, message: String = ResponseStatus.OK.description, data: T?) {
        self.status = status
        self.message = message
        self.data = data
    }
}
