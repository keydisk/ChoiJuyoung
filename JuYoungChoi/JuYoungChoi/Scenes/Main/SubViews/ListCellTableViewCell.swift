//
//  ListCellTableViewCell.swift
//  ChoiJuYoung
//
//  Created by JuYoung choi on 2018. 4. 18..
//  Copyright © 2018년 JuYoung choi. All rights reserved.
//

import UIKit
import SwiftyJSON

/// ListCell
class ListCellTableViewCell: UITableViewCell {

    /// 컨텐츠 내용 표시
    @IBOutlet weak var contentsLabel: UILabel!
    /// 타이틀 라벨
    @IBOutlet weak var titleLabel: UILabel!
    /// 음료 이미지
    @IBOutlet weak var introBrewImg: UIImageView!
    
    /// 이미지 높이
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    
    /// 이미지 로딩 완료를 알려주기 위한 콜백 메소드
    var loadingComplete:(() -> Void)?
    
    private var _tag: Int = 0
    override var tag: Int {
        get {
            
            return self._tag
        }
        set {
            
            self._tag = newValue
            
            self.setCellData()
        }
    }
    
    private func setCellData() {
        
        self.contentsLabel.numberOfLines = 0
        
        if let name = BrewListData.shared.getName(self._tag) {
            
            self.titleLabel.text = name
        }
        else {
            
            self.titleLabel.text = ""
        }
        
        self.contentsLabel.text = ""
        
        if let description = BrewListData.shared.getDescription(self._tag) {
            
            self.contentsLabel.text = description
            
            if let brewersTips = BrewListData.shared.getTip(self._tag) {
                
                self.contentsLabel.text?.append("\n\n tips : \(brewersTips)")
                
                let attributedString = NSMutableAttributedString(string:self.contentsLabel.text! );
                
                
                let attrebuteFirst  = [NSFontAttributeName:UIFont.italicSystemFont(ofSize: 12), NSForegroundColorAttributeName : UIColor.RGBA(0x23, 0x23, 0x23)];
                
                attributedString.addAttributes(attrebuteFirst, range:(attributedString.string as NSString).range(of: brewersTips))
                
                self.contentsLabel.attributedText = attributedString;
            }
        }
        
        self.introBrewImg.image = nil
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if let imgUrlText = BrewListData.shared.getImgUrl(self._tag) {
            
            self.introBrewImg.loadingImgFromUrl(imgUrlText, { cacheType in
                if let img = self.introBrewImg.image {
                    
                    let rate = img.size.width / img.size.height
                    let size = CGSize(width: img.size.width,
                                      height: img.size.width / rate)
                    self.introBrewImg.image = img.resizedImage(size)
                }
            })
        }
        else {
            
            self.introBrewImg.image = nil
        }
    }
}
