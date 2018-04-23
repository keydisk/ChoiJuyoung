//
//  CustomNavigationController.swift
//  Cafe24PlusApp
//
//  Created by jychoi04_T1 on 2017. 9. 15..
//  Copyright © 2017년 jychoi04_T1. All rights reserved.
//

import UIKit

/** Customized UINavigationController (2017.09.18 자원 해제를 위해서 사용) */
class CustomNavigationController: UINavigationController
{

    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /** 네비게이션 팝시 자원 해제를 위해 커스텀 */
    override func popViewController(animated: Bool) -> UIViewController?
    {
        let viewCtr = super.popViewController(animated: animated)
        
        if viewCtr is BaseViewController {
            
            (viewCtr as? BaseViewController)?.removeResource()
        }
        
        return viewCtr
    }
    
    /** 루트뷰로 갈때 자원 해제를 위해서 커스텀 */
    override func popToRootViewController(animated: Bool) -> [UIViewController]?
    {
        guard let erViewCtr = super.popToRootViewController(animated: animated) else {
            
            return nil
        }
        
        for viewCtr in erViewCtr {
            
            if viewCtr is BaseViewController {
                
                (viewCtr as? BaseViewController)?.removeResource()
            }
        }
        
        return erViewCtr
    }
    
    /** 모달을 닫을때 자원 해제를 위해서 커스텀 */
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil)
    {
        for tmpViewCtr in self.viewControllers {
            
            if  tmpViewCtr.presentedViewController?.isKind(of: UIAlertController.classForCoder()) == false &&
                tmpViewCtr is BaseViewController {
                
                (tmpViewCtr as? BaseViewController)?.removeResource()
            }
        }
        
        super.dismiss(animated: flag) {
            
            if let tmpComplete = completion {
                
                tmpComplete()
            }
        }
    }
}
