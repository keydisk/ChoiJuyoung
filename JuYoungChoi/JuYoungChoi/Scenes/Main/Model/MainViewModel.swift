//
//  MainViewModel.swift
//  ChoiJuYoung
//
//  Created by JuYoung choi on 2018. 4. 17..
//  Copyright © 2018년 JuYoung choi. All rights reserved.
//

import Foundation
import SwiftyJSON
import RxSwift
import Alamofire

/// Main Business Logis
class MainViewModel: NSObject {
    
    /// 데이터 로딩 메소드
    ///
    /// - Parameters:
    ///   - pageNo: 호출할 페이지 넘버
    ///   - perPage: 페이지당 표시할 개수
    ///   - successCallBack: 성공시 리턴할 메소드
    ///   - failCallBack: 실패시 리턴할 메소드
    public func loadData(pageNo: Int = 1, perPage: Int = 10, successCallBack: @escaping( (_ result: JSON) -> Void), failCallBack: @escaping( (_ errorCd: Int) -> Void)) {
        
        var parameter = Parameters()
        
        parameter["page"]     = pageNo
        parameter["per_page"] = perPage
        
        APIClient.shared.requestJson(parameter: parameter, completion: {result in
            
            switch result {
            case .success(let result) :
                
                successCallBack(result)
                break
            case .failure(let apiError) :
                
                switch apiError {
                case .networkError(error: let error as NSError) :
                    
                    failCallBack(error.code)
                    break
                case .unexpectedStatusCode(statusCode: let errorStatusCd, message: let errorDescription) :
                    debugPrint("unexpectedStatusCode errorDescription : \(errorStatusCd)")
                    
                    failCallBack(errorStatusCd)
                    break
                }
            }
        })
    }
}
