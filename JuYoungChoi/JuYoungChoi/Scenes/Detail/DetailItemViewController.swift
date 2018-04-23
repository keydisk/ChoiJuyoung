//
//  DetailItemViewController.swift
//  ChoiJuYoung
//
//  Created by JuYoung choi on 2018. 4. 18..
//  Copyright © 2018년 JuYoung choi. All rights reserved.
//

import UIKit
import SwiftyJSON

/// DetailView에서 사용하는 커맨드
///
/// - loadDetailData: 상세 정보 조회
enum DetailViewCommand: Command {
    
    case loadDetailData
    
    func excute() {
        
    }
}

/// 음료의 상세 정보를 표시해주는 클래스
class DetailItemViewController: BaseViewController {
    
    enum DetailItemList: Int {
        
        case title = 0, goodsImg, contents
    }
    
    @IBOutlet weak var tableView: UITableView!
    let viewModel = DetailViewMV()
    
    let defaultCellIdentifer   = "defaultCell"
    let titleCellIdentifer     = "titleCellIdentifer"
    let pictureCellIdentifer   = "pictureCellIdentifer"
    let contentsCellIdentifier = "contentsCellIdentifier"
    
    /// 상세보기 호출시 전달 될 수 있는 정보
    public var recieveData: JSON?
    
    /// 음료 리스트 구독
    private func brewItemSubscribe() {
        
        _ = self.viewModel.detailItem?.subscribe({ (result) in
            
            switch result {
                
            case .completed :
                self.tableView.reloadData()
                break
            case .error( _ ) :
                break
            case .next( _ ) :
                
                break
            }
            
        })
    }
    
    /// 셀 등록
    private func registCell() {
        
        self.tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: self.defaultCellIdentifer)
        self.tableView.register(TitleCellCell.classForCoder(), forCellReuseIdentifier: self.titleCellIdentifer)
        self.tableView.register(ImageCell.classForCoder(), forCellReuseIdentifier: self.pictureCellIdentifer)
        self.tableView.register(ContentsViewCell.classForCoder(), forCellReuseIdentifier: self.contentsCellIdentifier)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationTitle = "상세보기"
        
        if self.recieveData == nil {
            
            self.viewModel.setCommand(DetailViewCommand.loadDetailData)
        }
        
        if self.isModal() {
            
            /// top right 버튼 그리기
            let rightBtnImg = UIImage(named: "close")
            let rightTopBtn = UIButton(type: .custom)
            
            let rightBtnSize = (self.view.frame.size.width * 0.085333333333333)
            
            rightTopBtn.frame = CGRect(x: self.view.frame.size.width - (self.view.frame.size.width * 0.106666666666667),
                                       y: (self.navigationController!.navigationBar.frame.size.height - rightBtnSize) / 2,
                                       width: rightBtnSize, height: rightBtnSize)
            rightTopBtn.setImage(rightBtnImg, for: UIControlState.normal)
            rightTopBtn.addTarget(self, action: #selector(closeView), for: UIControlEvents.touchUpInside)
            
            self.navigationController?.navigationBar.addSubview(rightTopBtn)
        }
        
        self.brewItemSubscribe()
        self.registCell()
        
        self.tableView.separatorStyle = .none
        self.tableView.estimatedRowHeight = 150
        self.tableView.rowHeight = UITableViewAutomaticDimension
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

//MARK: - Implement TableView Delegate
extension DetailItemViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 3
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 150
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        switch indexPath.row {
        case DetailItemList.goodsImg.rawValue :

            return 420
        default: // contents or title
            
            return UITableViewAutomaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        do {
            guard let dataSource = try self.viewModel.detailItem?.value() else {
                
                return
            }
            
            if dataSource.count != 0 && indexPath.row == DetailItemList.goodsImg.rawValue {
                
                CustomToastMessage.GetInstance().ShowMessage("image url : \(dataSource["imgUrl"].stringValue) ")
            }
            else {
                
                if self.recieveData != nil {
                    
                    CustomToastMessage.GetInstance().ShowMessage("image url : \(self.recieveData!["imgUrl"].stringValue) ")
                }
            }
        }
        catch _ {
            
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        do {
            var dataSource: JSON! = nil
            
            if self.recieveData != nil {
                
                dataSource = self.recieveData
            }
            else {
                
                guard let tmpDataSource = try self.viewModel.detailItem?.value() else {
                    
                    let cell = tableView.dequeueReusableCell(withIdentifier: self.titleCellIdentifer, for: indexPath)     as! TitleCellCell
                    
                    cell.titleText = ""
                    cell.selectionStyle = .none
                    
                    return cell
                }
                
                dataSource = tmpDataSource
            }
            
            debugPrint("indexPath.row : \(indexPath.row)")
            
            switch indexPath.row {
            case DetailItemList.title.rawValue :
                let cell = tableView.dequeueReusableCell(withIdentifier: self.titleCellIdentifer, for: indexPath)     as! TitleCellCell
                
                cell.titleText = dataSource["name"].string
                cell.selectionStyle = .none
                
                return cell
            case DetailItemList.goodsImg.rawValue :
                let cell = tableView.dequeueReusableCell(withIdentifier: self.pictureCellIdentifer, for: indexPath)   as! ImageCell
                
                cell.selectionStyle = .none
                cell.goodsImgUrl = dataSource["imgUrl"].stringValue
                
                return cell
            default: // contents
                let cell = tableView.dequeueReusableCell(withIdentifier: self.contentsCellIdentifier, for: indexPath) as! ContentsViewCell
                
                cell.selectionStyle = .none
                cell.abv = dataSource["abv"].stringValue
                cell.ingredients  = dataSource["ingredients"]
                cell.contentsText = dataSource["description"].stringValue
                                
                return cell
            }
        }
        catch _ {

            let cell = tableView.dequeueReusableCell(withIdentifier: self.defaultCellIdentifer, for: indexPath)
            
            return cell
        }
    }
    
}
