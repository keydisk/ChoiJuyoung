//
//  StringExtension.swift
//  iOSTestProject
//
//  Created by JuYoung choi on 2/19/24.
//

import Foundation

extension String {
    
    /// 다국어 지원
    var local: String {
        return NSLocalizedString(self, comment: self)
    }
    
    public static func isEmpty(_ text: String?) -> Bool {
        
        return (text == nil || text == "")
    }
    
    var urlEncodeWithQuery: String? {
            
        return self.addingPercentEncoding( withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
    }
}
