//
//  DataExtension.swift
//  ChoiJuYoung
//
//  Created by JuYoung choi on 2018. 4. 17..
//  Copyright © 2018년 JuYoung choi. All rights reserved.
//

import Foundation

public extension Data {
    
    /// UTF8 문자열로 변환
    public var utf8String: String? {
        return string(as: .utf8)
    }
    
    public func string(as encoding: String.Encoding) -> String? {
        return String(data: self, encoding: encoding)
    }
}
