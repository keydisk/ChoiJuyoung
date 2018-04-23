//
//  CustomToastMessage.swift
//  Pays
//
//  Created by jychoi on 2016. 11. 25..
//  Copyright © 2016년 jychoi. All rights reserved.
//

import Foundation
import UIKit

//let APP_ALERT_TITLE = "Swift Constants"

class CustomToastMessage: UIView {
    
    static var g_pInstance:CustomToastMessage? = nil;
    
    public static func GetInstance() -> CustomToastMessage
    {
        if(g_pInstance == nil) {
            
            g_pInstance = CustomToastMessage();
        }
        
        return g_pInstance!;
    }
    
    public func ShowMessage(_ pstrMessage:String )
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate;
        let pWindow:UIWindow? = appDelegate.window;// appDelegate.window;
        
        self.translatesAutoresizingMaskIntoConstraints = false;
        
        
        let pFont:UIFont      = UIFont.systemFont(ofSize: 15);
        let pTextView:UILabel = UILabel();
        let pBaseView:UIView  = UIView();
        
        pTextView.backgroundColor = UIColor(white:0.3, alpha: 1.0);
        pBaseView.backgroundColor = UIColor(white:0.3, alpha: 1.0);
        
        pTextView.textColor = UIColor.white;
        pTextView.font = pFont;
        pTextView.textAlignment = NSTextAlignment.center;
        pTextView.text = pstrMessage;
        pTextView.numberOfLines = 0;

        pBaseView.addSubview(pTextView);
        pWindow!.addSubview(pBaseView);
        
        pBaseView.translatesAutoresizingMaskIntoConstraints = false;
        pTextView.translatesAutoresizingMaskIntoConstraints = false;
        
        
        pWindow!.addSubview(self);
        
        let pTextViewCenterX:NSLayoutConstraint = NSLayoutConstraint(item:pTextView,
                                                                     attribute:NSLayoutAttribute.centerX,
                                                                     relatedBy:NSLayoutRelation.equal,
                                                                     toItem:pBaseView,
                                                                     attribute:NSLayoutAttribute.centerX,
                                                                     multiplier: 1.0, 
                                                                     constant: 0.0);
        
        let pTextViewCenterY:NSLayoutConstraint = NSLayoutConstraint(item:pTextView,
                                                                     attribute:NSLayoutAttribute.centerY,
                                                                     relatedBy:NSLayoutRelation.equal,
                                                                     toItem:pBaseView,
                                                                     attribute:NSLayoutAttribute.centerY,
                                                                     multiplier: 1.0,
                                                                     constant: 0.0);
        
        let pTextViewWidth:NSLayoutConstraint = NSLayoutConstraint(item:pTextView,
                                                                     attribute:NSLayoutAttribute.width,
                                                                     relatedBy:NSLayoutRelation.lessThanOrEqual,
                                                                     toItem:pWindow,
                                                                     attribute:NSLayoutAttribute.width,
                                                                     multiplier: 0.8,
                                                                     constant: 0.0);
        
        // baseView layout
        let pBaseViewXCenter:NSLayoutConstraint = NSLayoutConstraint(item:pBaseView,
                                                                   attribute:NSLayoutAttribute.centerX,
                                                                   relatedBy:NSLayoutRelation.equal,
                                                                   toItem:pWindow,
                                                                   attribute:NSLayoutAttribute.centerX,
                                                                   multiplier: 1.0,
                                                                   constant: 0.0);
        
        let pBaseViewYLoc:NSLayoutConstraint = NSLayoutConstraint(item:pBaseView,
                                                                     attribute:NSLayoutAttribute.centerY,
                                                                     relatedBy:NSLayoutRelation.equal,
                                                                     toItem:pWindow,
                                                                     attribute:NSLayoutAttribute.centerY,
                                                                     multiplier: 1.0,
                                                                     constant: 0.0);
        
        let pBaseViewWidth:NSLayoutConstraint = NSLayoutConstraint(item:pBaseView,
                                                                  attribute:NSLayoutAttribute.width,
                                                                  relatedBy:NSLayoutRelation.greaterThanOrEqual,
                                                                  toItem:pTextView,
                                                                  attribute:NSLayoutAttribute.width,
                                                                  multiplier: 1.0,
                                                                  constant:20.0);
        
        let pBaseViewHeight:NSLayoutConstraint = NSLayoutConstraint(item:pBaseView,
                                                                   attribute:NSLayoutAttribute.height,
                                                                   relatedBy:NSLayoutRelation.equal,
                                                                   toItem:pTextView,
                                                                   attribute:NSLayoutAttribute.height,
                                                                   multiplier: 1.2,
                                                                   constant:10.0);
        
        pWindow!.addConstraints([pBaseViewXCenter, pBaseViewYLoc, pBaseViewWidth, pBaseViewHeight, pTextViewWidth]);
        pBaseView.addConstraints([pTextViewCenterX, pTextViewCenterY])
        
        pBaseView.layer.cornerRadius = 10.0;
        
        
        self.alpha      = 0.0;
        pBaseView.alpha = 0.0;
        
        // animation start
        CATransaction.begin();
        
        // 완료시 호출.
        CATransaction.setCompletionBlock {
            
            self.alpha      = 0.0;
            pBaseView.alpha = 0.0;
            
            pBaseView.isHidden = true;
            pTextView.isHidden = true;
            
            pBaseView.removeFromSuperview();
        };
        
        
        let pAnimationOpacity:CAKeyframeAnimation = CAKeyframeAnimation(keyPath:"opacity");
        
        pAnimationOpacity.duration = 3;
        
        pAnimationOpacity.values   = [NSNumber(value:1.0), NSNumber(value:0.0)];
        pAnimationOpacity.keyTimes = [NSNumber(value:0.0), NSNumber(value:1.0)];
        
        pAnimationOpacity.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseIn);
        pBaseView.layer.add(pAnimationOpacity, forKey:"opacity");
        
        CATransaction.commit()
    }
}
