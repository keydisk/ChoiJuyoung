//
//  ImageExtension.swift
//  Cafe24PlusApp
//
//  Created by jychoi04_T1 on 2017. 9. 18..
//  Copyright © 2017년 jychoi04_T1. All rights reserved.
//

import UIKit

//MARK: Normal Image Lib
/** comment : UIImage에서 추가적인 작업을 위한 익스텐션 */
extension UIImage
{
    public func resizedImage(_ inRect:CGSize, opaque:Bool = false) -> UIImage?
    {
        let scale = UIScreen.main.scale;
        
        UIGraphicsBeginImageContextWithOptions(inRect, opaque, scale);
        
        if opaque == false {
            
            UIGraphicsGetCurrentContext()?.interpolationQuality = .none
        }
        
        //        CGContext.interpolationQuality =
        
        self.draw(in: CGRect(x:0, y:0, width:inRect.width, height:inRect.height));
        let newImg = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return newImg;
    }
    
    /** comment : 이미지 스트레처블 */
    public func stretchableImg(width:CGFloat, height:CGFloat) -> UIImage?
    {
        var rtnImg = self.resizedImage(CGSize(width:width, height:height));
        //        pRtnImg = pRtnImg.stretchableImage(withLeftCapWidth: Int(fWidth / 2), topCapHeight: Int(fHeight / 2))
        rtnImg = rtnImg?.resizableImage(withCapInsets: UIEdgeInsets(top: (height / 2) - 1, left: (width / 2) - 1, bottom: (height / 2), right: (width / 2) ), resizingMode: .stretch)
        
        return rtnImg;
    }
    
    /** comment : CIImage를 UIImage로 만들어 주는 메소드 */
    public static func imageWithCGImage(aCIImage:CIImage?, anOrientation:UIImageOrientation) -> UIImage?
    {
        if aCIImage == nil {
            
            return nil;
        }
        
        let imageRef:CGImage = CIContext(options: nil).createCGImage(aCIImage!, from: aCIImage!.extent)!
        let image   = UIImage(cgImage: imageRef, scale: 1.0, orientation: anOrientation)
        
        return image;
    }
    
    /**
     comment : 이미지 자르기 메소드
     params :
        rect  <- 이미지를 자를 범위
     return :
     잘린 이미지
     */
    public func cropImage(toRect rect:CGRect) -> UIImage
    {
        let imageRef:CGImage = self.cgImage!.cropping(to: rect)!
        let croppedImage:UIImage = UIImage(cgImage:imageRef)
        
        return croppedImage
    }
    
}


// MARK:- QR코드 및 바코드 생성 (다 static 메소드)
extension UIImage
{
    /**
     comment : QR 코드 생성기
     param :
         QRCode <- 생성할 QR Code
         size   <- 생성할 size
     return :
         생성된 QR코드 이미지
     */
    static func QRImageWithString(QRCode:String, size:CGSize) -> UIImage?
    {
        // 필터 생성
        let qrFilter = CIFilter(name: "CIQRCodeGenerator");
        
        if qrFilter == nil {
            
            return nil;
        }
        
        // 수정 레벨 설정
        qrFilter?.setValue("H", forKey: "inputCorrectionLevel")
        
        //입력 문자열 설정
        let codeData = QRCode.data(using: .utf8)!
        qrFilter?.setValue(codeData, forKey: "inputMessage")
        
        //결과 이미지 가져오기
        if let outputImg = qrFilter?.value(forKey: "outputImage") as? CIImage {
            
            let smallImg  = UIImage.imageWithCGImage(aCIImage: outputImg, anOrientation: .up)!
            return smallImg.resizedImage(size)
        }
        
        return nil
    }
    
    /** comment : 바코드 생성 */
    static func getBarcodeImg(pstrBarcodeText : String) -> UIImage?
    {
        let pData:Data? = pstrBarcodeText.data(using: String.Encoding.ascii)
        
        if let filter = CIFilter(name: "CICode128BarcodeGenerator") {
            
            filter.setValue(pData, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 3, y: 3)
            
            if let output = filter.outputImage?.applying(transform) {
                
                return UIImage(ciImage: output)
            }
        }
        
        return nil;
    }
    
    /** comment : 애플워치에 보낼 바코드 이미지 생성 */
    static func getBarcodeImgForAppleWatch(pstrBarcodeText : String) -> UIImage?
    {
        let pData:Data? = pstrBarcodeText.data(using: String.Encoding.ascii)
        
        if let filter = CIFilter(name: "CICode128BarcodeGenerator") {
            
            filter.setValue(pData, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 3, y: 3)
            
            
            if let output = filter.outputImage?.applying(transform) {
                
                var pBarcodeImg:UIImage? = UIImage(ciImage: output)
                pBarcodeImg = pBarcodeImg!.resizedImage(CGSize(width: 340, height: 40))
                
                return pBarcodeImg
            }
        }
        
        return nil;
    }
    
    /** comment : 애플워치에 보낼 바코드 이미지 데이터 생성 */
    static func getBarcodeImgDataForAppleWatch(barcodeText : String) -> Data?
    {
        let pData = barcodeText.data(using: String.Encoding.ascii)
        
        if let filter = CIFilter(name: "CICode128BarcodeGenerator") {
            
            filter.setValue(pData, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 3, y: 3)
            
            
            if let output = filter.outputImage?.applying(transform) {
                
                var pBarcodeImg:UIImage? = UIImage(ciImage: output)
                pBarcodeImg = pBarcodeImg!.resizedImage(CGSize(width: 340, height: 40))
                
                if let pImgData:Data = UIImagePNGRepresentation(pBarcodeImg!) {
                    
                    return pImgData
                }
                else  {
                    
                    return UIImageJPEGRepresentation(pBarcodeImg!, 1.0)
                }
            }
        }
        
        return nil;
    }
}
