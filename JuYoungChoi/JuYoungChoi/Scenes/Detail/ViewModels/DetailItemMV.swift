//
//  DetailItemMV.swift
//  ChoiJuYoung
//
//  Created by JuYoung choi on 2018. 4. 18..
//  Copyright © 2018년 JuYoung choi. All rights reserved.
//

import Foundation
import SwiftyJSON
import RxSwift

/// 디테일뷰 모델뷰
class DetailViewMV: CommonViewModel, CommonViewModelProtocol {
    
    /// 구성요소 타입
    ///
    /// - malt: 몰트 타입
    /// - hop: 홉 타입
    enum IngredientType: Int {
        case malt = 0, hop
    }
    
    public var selectIndex: Int = 0
    var detailItem: BehaviorSubject<JSON>?
    
    override init() {
        
        let json = JSON()
        self.detailItem = BehaviorSubject<JSON>(value: json)
    }
    /// Command 설정
    ///
    /// - Parameter command: 설정할 커멘드
    func setCommand(_ command: Command) {
        
        switch command as? DetailViewCommand {
        case .loadDetailData? :
            
            var json = JSON()
            
            json["description"].string = BrewListData.shared.getDescription(self.selectIndex)
            json["imgUrl"].string      = BrewListData.shared.getImgUrl(self.selectIndex)
            json["name"].string        = BrewListData.shared.getName(self.selectIndex)
            json["abv"].number         = BrewListData.shared.getAbv(self.selectIndex)
            
            if let intgredients = BrewListData.shared.getIngredients(self.selectIndex) {
                
                json["ingredients"] = intgredients
            }
            
            self.detailItem?.onNext(json)
            self.detailItem?.onCompleted()
            
            break
        default :
            break
        }
    }
}
