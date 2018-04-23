//
//  UIColorExtension.swift
//  Cafe24Front
//
//  Created by jychoi04_T1 on 2017. 9. 6..
//  Copyright © 2017년 jychoi04_T1. All rights reserved.
//

import UIKit


/// UIColor에서 색 가져오기 익스텐션
extension UIColor
{
    static let _fDivin:Float = 255;
    static let _AlphaDivin:Float = 100;
    
    /// RGB값을 UIColor로 변경
    ///
    /// - Parameters:
    ///   - red: 빨간색
    ///   - green: 초록색
    ///   - blue: 파란색
    ///   - alpha: 알파값
    /// - Returns: UIColor객체
    static func RGBA(_ red:Float, _ green:Float, _ blue:Float, _ alpha:Float = 100) -> UIColor
    {
        var fRed   = red   / UIColor._fDivin
        var fGreen = green / UIColor._fDivin
        var fBlue  = blue  / UIColor._fDivin
        var fAlpha = alpha / UIColor._AlphaDivin
        
        if fRed > 1 {
            
            fRed = 1.0
        }
        
        if fGreen > 1 {
            
            fGreen = 1.0
        }
        
        if fBlue > 1 {
            
            fBlue = 1.0
        }
        
        if fAlpha > 1 {
            
            fAlpha = 1.0
        }
        
        let colorSpace    = CGColorSpace(name:CGColorSpace.adobeRGB1998)!
        let rgbaLikeArray = [CGFloat(fRed), CGFloat(fGreen), CGFloat(fBlue), CGFloat(fAlpha) ]
        let cgColorWithColorSpace = CGColor(colorSpace: colorSpace, components: rgbaLikeArray)!
        let makeCgcolor  = cgColorWithColorSpace.converted(to: colorSpace, intent: .absoluteColorimetric, options: nil)!
        
        let rtnColor = UIColor(cgColor: makeCgcolor)

        return rtnColor
    }
    
    /// 핵사 텍스트를 UIColor로 변환
    ///
    /// - Parameters:
    ///   - hexString: 컬러 텍스트
    ///   - alpha: 알파값
    /// - Returns: 컬러 객체
    static func fromHex(_ hexString: String, alpha: CGFloat = 100) -> UIColor
    {
        var formatted = hexString.replacingOccurrences(of: "0x", with: "")
        formatted = formatted.replacingOccurrences(of: "#", with: "")
        
        if let hex = Int(formatted, radix: 16) {
            
            let red   = Float((hex & 0xFF0000) >> 16)
            let green = Float((hex & 0x00FF00) >> 8)
            let blue  = Float((hex & 0x0000FF) >> 0)
            
            return UIColor.RGBA(red, green, blue, Float(alpha ))
        }
        else {
            
            return .black
        }
    }
}
