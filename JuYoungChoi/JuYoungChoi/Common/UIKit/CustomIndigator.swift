//
//  CustomIndigator.swift
//  Pays
//
//  Created by jychoi on 2016. 12. 1..
//  Copyright © 2016년 jychoi. All rights reserved.
//

import UIKit

/** 인디게이터 */
class CustomIndigator: UIView
{
    private var isAnimation:Bool = false;
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    init() {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate;
        self.pWindow = appDelegate.window;
        
        super.init(frame: self.pWindow!.frame)
        
        self.backgroundColor = UIColor(white: 0.5, alpha: 0.5);
    }
    
    
    
    private weak var imgView:UIImageView?     = nil;
    private weak var backImgView:UIImageView? = nil;
    private var pWindow:UIWindow? = nil;
    private static let animationTime:TimeInterval = 40.0;
    
    
    
    func StartAnimation()
    {
        if self.isAnimation {
            
            self.imgView!.layer.removeAllAnimations();
        }
        
        if(self.backImgView == nil) {
            let tmpBackImg = UIImageView(image:UIImage(named:"indicator_bg"));
            let backSize = (Int)(self.pWindow!.frame.size.width * 0.36231884057971);
            tmpBackImg.frame = CGRect(x: 0, y: 0, width: backSize, height: backSize);
            
            self.addSubview(tmpBackImg);
            tmpBackImg.center = self.pWindow!.center;
            self.backImgView = tmpBackImg;
            
            let tmpImgView:UIImageView = UIImageView(image:UIImage(named:"indicator"));
            self.addSubview(tmpImgView)
            
            let size:Int = (Int)(self.pWindow!.frame.size.width * 0.21739130434783);
            tmpImgView.frame  = CGRect(x: 0, y: 0, width:size, height: size)
            tmpImgView.center = self.pWindow!.center;
            
            self.imgView = tmpImgView;
        }
        
        self.pWindow!.addSubview(self);
        
        CATransaction.begin();
        
        self.isAnimation = true;
        // 완료시 호출.
        CATransaction.setCompletionBlock {
            self.isAnimation = false;
        }
        
        let animationRotateZ:CAKeyframeAnimation = CAKeyframeAnimation.init(keyPath:"transform.rotation.z");

        animationRotateZ.duration = CustomIndigator.animationTime;
        
        var values = [NSNumber]();
        var times  = Array<NSNumber>();// 공부하니라 위의 배열 할당 방법과 아래의 배열 할당 방법을 다르게 표현해봄.... 둘다 똑같은 애임
        
        var time:Float = 0;
        let divinCount = 1.0 / (Float)(CustomIndigator.animationTime * 2.0);
        
        var i:Float = 0;
        
        for _ in 0...(Int)(CustomIndigator.animationTime) * 2 {
            
            values.append(NSNumber(value:(i * (Float)(Double.pi) ))  )
            times.append(NSNumber(value:time))
            
            time += divinCount;
            i += 1;
        }
        
        animationRotateZ.values   = values;
        animationRotateZ.keyTimes = times;
        animationRotateZ.repeatCount = 100;
        
        animationRotateZ.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionLinear);
        
        self.imgView!.layer.add(animationRotateZ, forKey:"transform.rotation.z");
        
        CATransaction.commit()
    }
    
    func StopAnimation()
    {
        if(self.imgView != nil) {
            
            self.imgView!.layer.removeAllAnimations();
            self.isHidden = true;
        }
        
    }

}
