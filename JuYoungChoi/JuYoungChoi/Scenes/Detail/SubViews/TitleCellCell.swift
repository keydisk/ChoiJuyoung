//
//  TitleCellCell.swift
//  ChoiJuYoung
//
//  Created by JuYoung choi on 2018. 4. 18..
//  Copyright © 2018년 JuYoung choi. All rights reserved.
//

import UIKit

/// Title cell
class TitleCellCell: UITableViewCell {

    weak var title: UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private var _titleText: String?
    /// 표시할 텍스트
    
    public  var titleText: String? {
        get {
            
            return self._titleText
        }
        set {
            
            self._titleText = newValue
        }
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        
        if self.title == nil {
            
            let titleLabel = UILabel()
            
            titleLabel.textColor = UIColor.darkGray
            titleLabel.textAlignment = .center
            titleLabel.numberOfLines = 0
            
            titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            
            self.contentView.addSubview(titleLabel)
            
            let xLoc   = NSLayoutConstraint(item:titleLabel, attribute:.left,    relatedBy:.equal,
                                            toItem:self.contentView, attribute:.left,
                                            multiplier: 1.0, constant: 20.0);
            let topLoc   = NSLayoutConstraint(item:titleLabel, attribute:.top,     relatedBy:.equal,
                                              toItem:self.contentView, attribute:.top,
                                              multiplier: 1.0, constant: 10.0);
            let width  = NSLayoutConstraint(item:titleLabel, attribute:.right,   relatedBy:.equal,
                                            toItem:self.contentView, attribute:.right,
                                            multiplier: 1.0, constant: -10.0);
            let bottomLoc = NSLayoutConstraint(item:titleLabel, attribute:.bottom,  relatedBy:.equal,
                                               toItem:self.contentView, attribute:.bottom,
                                               multiplier: 1.0, constant: -10);
            
            bottomLoc.priority = 500
            
            self.contentView.addConstraints([xLoc, topLoc, width, bottomLoc])
            
            self.title = titleLabel
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.title!.text = self._titleText
    }
}
