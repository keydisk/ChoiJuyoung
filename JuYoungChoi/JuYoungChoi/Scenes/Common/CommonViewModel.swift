//
//  CommonViewModel.swift
//  ChoiJuYoung
//
//  Created by JuYoung choi on 2018. 4. 17..
//  Copyright © 2018년 JuYoung choi. All rights reserved.
//

import Foundation
import RxSwift

/// 뷰 모델에서 정의해야 하는 프로토콜
protocol CommonViewModelProtocol {
    
    func setCommand(_ command: Command)
}

/// 공통으로 사용하는 뷰 모델
class CommonViewModel {
    
    /// rx swift 객체를 소멸시키기 위한 객체
    let disposeBag = DisposeBag()
    
    
}
