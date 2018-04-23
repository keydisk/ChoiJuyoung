//
//  BaseViewController.swift
//  Pays
//
//  Created by jychoi on 2016. 12. 1..
//  Copyright © 2016년 jychoi. All rights reserved.
//

import UIKit
import SwiftyJSON

public protocol UseNavigaionBarInBaseViewController: NSObjectProtocol {
    
    var navigationTitle:String { get set}
}

/// 모든 ViewController들의 기본 클래스
class BaseViewController: UIViewController {
    
    /// 해제할 자원
    public func removeResource() {
    }
    
    deinit {
        
        debugPrint("BaseViewController deinit")
    }
    
    public lazy var indigator = CustomIndigator()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        
        return .default
    }
    
    /**  얼럿을 띄울때 모달이 떠 있을 경우 모달 위에 띄워 주기 위해서 사용 */
    public var alertPresenter: UIViewController {
        
        var viewCtr = self.presentedViewController
        
        while viewCtr != nil {
            
            if viewCtr?.presentedViewController == nil {
                
                return viewCtr!
            }
            else {
                
                viewCtr = viewCtr?.presentedViewController
            }
        }
        
        return self
    }
    
    /**  네비게이션 바 사용 및 네비게이션 바 색 변경 */
    var useNavigationBar: Bool {
        get {
            if let navigation = self.navigationController {
                
                return navigation.isNavigationBarHidden
            }
            else {
                
                return false
            }
        }
        set {
            
            self.navigationController?.isNavigationBarHidden = !newValue
        }
    }
    
    //MARK: - 화면 탭시 가상 키보드 숨기기
    /** 화면 텝 했을때 에디트를 종료할것인지 여부 */
    weak var singleFingerTap: UITapGestureRecognizer? = nil
    
    private var _endEditEnable = false
    public var endEditEnable: Bool {
        get {
            
            return self._endEditEnable
        }
        set {
            
            if newValue {
                
                if self.singleFingerTap != nil {
                    
                    self.view.removeGestureRecognizer(self.singleFingerTap!)
                }
                
                let singleFingerTap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(editEnd))
                self.view.addGestureRecognizer(singleFingerTap)
                
                self.singleFingerTap = singleFingerTap
            }
            else {
                
                if self.singleFingerTap != nil {
                    
                    self.view.removeGestureRecognizer(self.singleFingerTap!)
                }
            }
            
            self._endEditEnable = newValue
        }
    }
    
    func editEnd(recognizer: UITapGestureRecognizer)
    {
        self.view.endEditing(true);
    }
    
    //MARK: - Basic view controller methods
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = ""
        self.navigationController?.isNavigationBarHidden = true
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        // Push Noti 발생시 Noti list를 보여주기 위해서
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
        
    }
    
    //MARK: - Indigator
    public func startIndigator()
    {
        self.indigator.StartAnimation()
    }
    
    public func stopIndigator()
    {
        self.indigator.StopAnimation()
    }
    
}

//MARK: - Navigation Controller
extension BaseViewController: UseNavigaionBarInBaseViewController
{
    /// 네비게이션 타이틀
    var navigationTitle: String {
        get {
        
            return self.title == nil ? "" : self.title!
        }
        set {
        
            self.navigationController?.isNavigationBarHidden = false
            self.title = newValue
        }
    }
}

//MARK: - 뷰컨트롤러 조작 파트
extension BaseViewController{

    /// 현재 뷰컨트롤러가 모달인지 판단.
    ///
    /// - Returns: true  <- 모달 false <- 모달 X
    public func isModal() -> Bool {
        
        if self.presentingViewController != nil ||
            self.navigationController?.presentingViewController?.presentingViewController == self.navigationController ||
            self.tabBarController?.presentingViewController is UITabBarController {
            
            return true;
        }
        
        return false;
    }
    
    /// ViewController를 닫던가
    public func closeView() {
        
        if let navi = self.navigationController, navi.viewControllers.count > 1 {
            
            self.navigationController?.popViewController(animated: true)
        }
        else if self.isModal() {
            
            if let naviCtr = self.navigationController {
                
                naviCtr.dismiss(animated: true, completion: nil)
            }
            else {
                
                self.dismiss(animated: true, completion: nil)
            }
            
        }
    }
    
    /// 자원 해제를 위해서 dismiss를 오버라이드
    ///
    /// - Parameters:
    ///   - flag: 애니메이션 여부
    ///   - completion: 뷰를 사라지게하는 애니메이션이 완료 된 후 호출 되는 콜백
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        if let naviCtr = self.navigationController {
            
            for viewCtr in naviCtr.viewControllers {
                
                if viewCtr is BaseViewController {
                    
                    self.removeResource()
                }
            }
        }
        else {
            
            self.removeResource()
        }
        
        
        super.dismiss(animated: flag) {
            
            if let tmpComplete = completion {
                
                tmpComplete()
            }
        }
    }
}

