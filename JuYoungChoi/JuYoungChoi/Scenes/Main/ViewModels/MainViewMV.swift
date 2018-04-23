//
//  MainViewMV.swift
//  ChoiJuYoung
//
//  Created by JuYoung choi on 2018. 4. 17..
//  Copyright © 2018년 JuYoung choi. All rights reserved.
//

import Foundation
import SwiftyJSON
import RxSwift

/// Main Business Logis
class MainViewMV: CommonViewModel, CommonViewModelProtocol {
    
    deinit {
        
        debugPrint("MainViewMV deinit")
    }
    
    /// 현재 로딩한 페이지 넘버
    var currentPageNo: Int = 0
    var brewList: BehaviorSubject<JSON>?
    
    let mainModel = MainViewModel()
    
    init(currentPageNo: Int = 0) {
        
        let json = JSON()
        
        self.brewList = BehaviorSubject<JSON>(value: json)
        
        self.currentPageNo = currentPageNo
        
        super.init()
        
        self.brewList?.disposed(by: self.disposeBag)
    }
    
    
    /// Command 설정
    ///
    /// - Parameter command: 설정할 커멘드
    func setCommand(_ command: Command) {
        
        switch command as! MainCommand {
        case .loadBrewList(pageNo: let pageNo, perPage: let perPage):
            
            self.loadData(pageNo: pageNo, perPage: perPage)
            break
        }
    }
    
    /// 데이터 로딩
    ///
    /// - Parameters:
    ///   - pageNo: 로딩할 페이지
    ///   - perPage: 페이지당 호출할 데이터 개수
    private func loadData(pageNo: Int? = nil, perPage: Int = 10) {
        
        var localPageNo: Int = 0
        if pageNo != nil {
            
            localPageNo = pageNo!
        }
        else {
            
            localPageNo = self.currentPageNo + 1
        }
        
        self.mainModel.loadData(pageNo: localPageNo, perPage:perPage, successCallBack: { result in
            
            for json in result.arrayValue {
                
                BrewListData.shared.addData(json)
            }
            
            if pageNo == nil {
                
                self.currentPageNo += 1
            }
            
            self.brewList?.onNext(result)
            
        }, failCallBack: {errorCd in
            
            let error = NSError()
            self.brewList?.onError(error)
        })
    }
}
