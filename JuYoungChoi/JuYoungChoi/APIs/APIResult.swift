//
//  APIResult.swift
//  ChoiJuYoung
//
//  Created by JuYoung choi on 2018. 4. 17..
//  Copyright © 2018년 JuYoung choi. All rights reserved.
//

import Foundation
import SwiftyJSON

/// API 통신 결과를 리턴하는 메소드
typealias APIResultHandler = (JSON?, Error?) -> Void

public enum APIError: Error
{
    case unexpectedStatusCode(statusCode: Int, message: String)
    case networkError(error: Error)
    public var localizedDescription: String {
        switch self {
        case .unexpectedStatusCode(_, let message):
            return message
        case .networkError(let error):
            return "\(error)"
        }
    }
}


enum APIResult<T>
{
    case success(T)
    case failure(APIError)
    
    public func dematerialize() throws -> T
    {
        switch self {
        case let .success(value):
            return value
        case let .failure(error):
            throw error
        }
    }
}
