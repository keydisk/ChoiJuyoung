//
//  UIImageViewExtension.swift
//  ChoiJuYoung
//
//  Created by JuYoung choi on 2018. 4. 18..
//  Copyright © 2018년 JuYoung choi. All rights reserved.
//

import Foundation
import Kingfisher

// MARK: - 이미지뷰에 URL로 부터 이미지 불러오는 부분 추가
extension UIImageView
{
    /// 이미지 URL로 부터 로딩하기
    ///
    /// - Parameters:
    ///   - urlText: 로딩할 이미지 URL
    ///   - isHigliteImg: 하이라이트 이미지 인지 아닌지 (Default value : false, true일 경우 highlite 이미지에 다운받은 이미지를 저장)
    ///   - complete: 이미지 로딩 완료시 호출
    public func loadingImgFromUrl(_ urlText: String, isHigliteImg: Bool = false, _ complete: ((_ type: CacheType) -> Void)? = nil)
    {
        guard let tmpUrlText = urlText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let url = URL(string: tmpUrlText) else {
            return
        }
        
        KingfisherManager.shared.retrieveImage(with: url, options: nil, progressBlock: nil) { (image, error, cacheType, url) in
            
            if error != nil {
                
                KingfisherManager.shared.retrieveImage(with: url!, options: nil, progressBlock: nil) { (image, error, cacheType, url) in
                    
                    if isHigliteImg == false {
                        
                        self.image = image
                    }
                    else {
                        
                        self.highlightedImage = image
                    }
                    
                    complete?(cacheType)
                }
            }
            else {
                
                if isHigliteImg == false {
                    
                    self.image = image
                }
                else {
                    
                    self.highlightedImage = image
                }
                
                complete?(cacheType)
            }
        }
    }
}
