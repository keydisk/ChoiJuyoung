//
//  ImageCell.swift
//  ChoiJuYoung
//
//  Created by JuYoung choi on 2018. 4. 18..
//  Copyright © 2018년 JuYoung choi. All rights reserved.
//

import UIKit

/// Image를 표시하는 셀
class ImageCell: UITableViewCell {
    
    weak var goodsImg: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    /// 이미지 로딩 완료를 알려주기 위한 콜백 메소드
    var loadingComplete:(() -> Void)?
    
    private var _goodsImgUrl: String?
    var goodsImgUrl: String? {
        get {
            
            return self._goodsImgUrl
        }
        set {
            
            self._goodsImgUrl = newValue
        }
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        
        if self.goodsImg == nil {
            
            let goodsImg = UIImageView()
            
            goodsImg.translatesAutoresizingMaskIntoConstraints = false
            self.contentView.addSubview(goodsImg)
            
            let xLoc   = NSLayoutConstraint(item:goodsImg, attribute:.centerX, relatedBy:.equal, toItem:self.contentView, attribute:.centerX,
                                            multiplier: 1.0, constant: 0.0);
            let yLoc   = NSLayoutConstraint(item:goodsImg, attribute:.top,     relatedBy:.equal, toItem:self.contentView, attribute:.top,
                                            multiplier: 1.0, constant: 20.0);
            let width  = NSLayoutConstraint(item:goodsImg, attribute:.width,   relatedBy:.equal, toItem:self.contentView, attribute:.width,
                                            multiplier: 0.5, constant: 0.0);
            let bottom = NSLayoutConstraint(item:goodsImg, attribute:.bottom,  relatedBy:.equal, toItem:self.contentView, attribute:.bottom,
                                            multiplier: 1.0, constant: -20.0);
            
            goodsImg.contentMode = .scaleAspectFit
            
            self.contentView.addConstraints([xLoc, yLoc, width, bottom])
            
            self.goodsImg = goodsImg
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if let imgUrl = self._goodsImgUrl {
            
            self.goodsImg?.loadingImgFromUrl(imgUrl, { cacheType in
                
                debugPrint("self.contentView.frame.size.height : \(self.contentView.frame.size.height)")
                debugPrint("self.goodsImg.frame.size.height : \(self.goodsImg.frame.size.height)")
                
                if let img = self.goodsImg?.image {
                    
                    let rate = img.size.height / img.size.width
                    let size = CGSize(width: (self.contentView.frame.size.height - 40) / rate,
                                      height: self.contentView.frame.size.height - 40)
                    self.goodsImg?.image = img.resizedImage(size)
                }
            })
        }
    }
}
