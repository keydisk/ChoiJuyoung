//
//  BrewListData.swift
//  ChoiJuYoung
//
//  Created by JuYoung choi on 2018. 4. 18..
//  Copyright © 2018년 JuYoung choi. All rights reserved.
//

import Foundation
import SwiftyJSON

/// 음료 리스트
class BrewListData {
    
    static let shared: BrewListData = BrewListData()
    
    #if DEBUG
    public var brewList: [JSON] = []
    #else
    private var brewList: [JSON] = []
    #endif
    
    
    /// 텍스트 데이터를 조회하는 메소드
    ///
    /// - Parameters:
    ///   - index: 가져올 데이터의 인덱스
    ///   - keyValue: 가져올 데이터의 키 목록
    /// - Returns: 조회한 데이터
    private func getTextDataFromIndexAndKeyValue(_ index: Int, _ keyValue: [String]) -> String? {
        
        guard self.brewList.count > index else {
            
            return nil
        }
        
        var jsonData = self.brewList[index]
        for key in keyValue {
            
            jsonData = jsonData[key]
        }
        
        return jsonData.string
    }
    
    /// 숫자 데이터를 조회하는 메소드
    ///
    /// - Parameters:
    ///   - index: 가져올 데이터의 인덱스
    ///   - keyValue: 가져올 데이터의 키 목록
    /// - Returns: 조회한 데이터
    private func getNumberDataFromIndexAndKeyValue(_ index: Int, _ keyValue: [String]) -> NSNumber? {
        
        guard self.brewList.count > index else {
            
            return nil
        }
        
        var jsonData = self.brewList[index]
        for key in keyValue {
            
            jsonData = jsonData[key]
        }
        
        return jsonData.number
    }
    
    /// 데이터 추가
    ///
    /// - Parameter data: 추가할 데이터
    public func addData(_ data: JSON) {
        
        self.brewList.append(data)
    }
    
    /// 리스트의 개수 조회
    public var count: Int {
        
        return self.brewList.count
    }
    
    /// image url을 가져오는 메소드
    ///
    /// - Parameter index: 조회할 데이터의 인덱스
    /// - Returns: image url
    public func getImgUrl(_ index: Int) -> String? {
        
        return self.getTextDataFromIndexAndKeyValue(index, ["image_url"])
    }
    
    /// 음료의 이름 조회
    ///
    /// - Parameter index: 조회할 데이터의 인덱스
    /// - Returns: 음료의 이름
    public func getName(_ index: Int) -> String? {
        
        return self.getTextDataFromIndexAndKeyValue(index, ["name"])
    }
    
    /// 음료의 설명 조회
    ///
    /// - Parameter index: 조회할 데이터의 인덱스
    /// - Returns: 음료의 설명
    public func getDescription(_ index: Int) -> String? {
        
        return self.getTextDataFromIndexAndKeyValue(index, ["description"])
    }
    
    /// 음료의 팁 조회
    ///
    /// - Parameter index: 조회할 데이터의 인덱스
    /// - Returns: 음료의 팁
    public func getTip(_ index: Int) -> String? {
        
        return self.getTextDataFromIndexAndKeyValue(index, ["brewers_tips"])
    }
    
    /// 음료의 알콜 도수 조회
    ///
    /// - Parameter index: 조회할 데이터의 인덱스
    /// - Returns: 음료의 알콜 도수
    public func getAbv(_ index: Int) -> NSNumber? {
        
        return self.getNumberDataFromIndexAndKeyValue(index, ["abv"])
    }
    
    /// 음료의 구성 요소 조회
    ///
    /// - Parameter index: 조회할 데이터의 인덱스
    /// - Returns: 음료의 구성 요소
    public func getIngredients(_ index: Int) -> JSON? {
        
        guard self.brewList.count > index else {
            
            return nil
        }
        
        return self.brewList[index]["ingredients"]
    }
}
