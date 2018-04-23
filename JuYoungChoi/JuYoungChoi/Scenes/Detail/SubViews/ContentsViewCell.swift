//
//  ContentsViewCell.swift
//  ChoiJuYoung
//
//  Created by JuYoung choi on 2018. 4. 18..
//  Copyright © 2018년 JuYoung choi. All rights reserved.
//

import UIKit
import SwiftyJSON

/// ContentsView cell
class ContentsViewCell: UITableViewCell {
    
    /// 구성 요소를 표시하는 컬렉션 뷰 Type
    ///
    /// - Hops: 홉의 종류를 보여주는 타입
    /// - Malts: 몰트의 종류를 보여주는 타입
    enum CollectionViewType: Int {
        
        case Hops = 0, Malts
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    weak var contentsLabel: UILabel?
    weak var abvLabel: UILabel?
    
    weak var maltsList: UICollectionView?
    weak var hopsList: UICollectionView?
    
    /// HopsCell
    fileprivate let hopsIdentifier = "hopsIdentifier"
    /// MaltsCell
    fileprivate let maltsIdentifier = "maltsIdentifier"
    
    /// contentsText
    public var contentsText = ""
    /// 알콜 도수
    public var abv = ""
    /// 구성요소 제이슨
    public var ingredients: JSON?
    
    public var loadingComplete:(() -> Void)?
    
    
    /// contentsLabel과 abvLabel을 그림
    private func drawContentsAndAbvLabel() {
        
        if self.contentsLabel == nil {
            
            let contentsLabel = UILabel()
            
            contentsLabel.translatesAutoresizingMaskIntoConstraints = false
            contentsLabel.textColor = UIColor.darkGray
            contentsLabel.textAlignment = .left
            contentsLabel.numberOfLines = 0
            
            contentsLabel.font = UIFont.systemFont(ofSize: 17)
            
            self.contentView.addSubview(contentsLabel)
            
            let xLoc   = NSLayoutConstraint(item:contentsLabel, attribute:.left, relatedBy:.equal,
                                            toItem:self.contentView, attribute:.left,
                                            multiplier: 1.0, constant: 10.0);
            let xRightLoc = NSLayoutConstraint(item:contentsLabel, attribute:.right, relatedBy:.equal,
                                               toItem:self.contentView, attribute:.right,
                                               multiplier: 1.0, constant: -10.0);
            let topLoc   = NSLayoutConstraint(item:contentsLabel, attribute:.top,   relatedBy:.equal,
                                              toItem:self.contentView, attribute:.top,
                                              multiplier: 1.0, constant: 30.0);
            
            self.contentView.addConstraints([xLoc, xRightLoc, topLoc ])
            
            self.contentsLabel = contentsLabel
            
            let abvLabel = UILabel()
            
            abvLabel.translatesAutoresizingMaskIntoConstraints = false
            abvLabel.textColor = UIColor.red
            abvLabel.textAlignment = .right
            abvLabel.numberOfLines = 0
            
            abvLabel.font = UIFont.systemFont(ofSize: 17)
            
            self.contentView.addSubview(abvLabel)
            
            let rightLoc = NSLayoutConstraint(item:abvLabel, attribute:.right, relatedBy:.equal,
                                              toItem:self.contentView, attribute:.right,
                                              multiplier: 1.0, constant: -10.0);
            let topLoc2   = NSLayoutConstraint(item:abvLabel, attribute:.top,     relatedBy:.equal,
                                               toItem:contentsLabel, attribute:.bottom,
                                               multiplier: 1.0, constant: 10.0);
            
            self.contentView.addConstraints([rightLoc, topLoc2])
            
            self.abvLabel = abvLabel
        }
        
        self.contentsLabel?.text = self.contentsText
        self.abvLabel?.text      = "\(self.abv) %"
    }
    
    /// 컬렉션뷰 라벨
    ///
    /// - Parameter collectionViewText: 컬렉션뷰 타이틀
    /// - Parameter topView: 오토레이아웃을 적용하기 위해 상단에 기준이 되는 뷰 설정
    /// - Returns: 생성된 라벨
    private func addLabel(collectionViewText: String, topView: UIView) -> UILabel {
        
        let listTitle = UILabel()
        
        listTitle.translatesAutoresizingMaskIntoConstraints = false
        listTitle.text = collectionViewText
        
        self.contentView.addSubview(listTitle)
        
        let xLoc   = NSLayoutConstraint(item:listTitle, attribute:.left, relatedBy:.equal,
                                        toItem:self.contentView, attribute:.left,
                                        multiplier: 1.0, constant: 10.0);
        let topLoc   = NSLayoutConstraint(item:listTitle, attribute:.top,     relatedBy:.equal,
                                          toItem:topView, attribute:.bottom,
                                          multiplier: 1.0, constant: 20.0);
        let rightLoc  = NSLayoutConstraint(item:listTitle, attribute:.right,   relatedBy:.equal,
                                           toItem:self.contentView, attribute:.right,
                                           multiplier: 1.0, constant: -10.0);
        
        topLoc.priority = 720
        
        self.contentView.addConstraints([xLoc, topLoc, rightLoc ])
        
        return listTitle
    }
    
    /// Hops와 malts를 그리기 위한 메소드
    private func drawCollectionViews() {
        
        let cellSize = CGSize(width: 150, height: 150)
        if self.maltsList == nil {
            
            let flowLayout = UICollectionViewFlowLayout()
            flowLayout.scrollDirection = .horizontal
            flowLayout.itemSize = cellSize
            
            let maltsList = UICollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: flowLayout)
            
            maltsList.tag = DetailViewMV.IngredientType.malt.rawValue
            maltsList.translatesAutoresizingMaskIntoConstraints = false
            maltsList.delegate   = self
            maltsList.dataSource = self
            
            self.contentView.addSubview(maltsList)
            
            let label = self.addLabel(collectionViewText: "몰트", topView: self.abvLabel!)
            
            let xLoc   = NSLayoutConstraint(item:maltsList, attribute:.left, relatedBy:.equal,
                                            toItem:self.contentView, attribute:.left,
                                            multiplier: 1.0, constant: 10.0);
            let topLoc   = NSLayoutConstraint(item:maltsList, attribute:.top,     relatedBy:.equal,
                                              toItem:label, attribute:.bottom,
                                              multiplier: 1.0, constant: 20.0);
            let width  = NSLayoutConstraint(item:maltsList, attribute:.right,   relatedBy:.equal,
                                            toItem:self.contentView, attribute:.right,
                                            multiplier: 1.0, constant: -10.0);
            let height  = NSLayoutConstraint(item:maltsList, attribute:.height,   relatedBy:.equal,
                                             toItem:nil, attribute:.notAnAttribute,
                                             multiplier: 1.0, constant: 160.0);
            
            topLoc.priority = 700
            
            self.contentView.addConstraints([xLoc, topLoc, width, height])
            
            maltsList.register(UICollectionViewCell.classForCoder(), forCellWithReuseIdentifier: self.maltsIdentifier)
            
            maltsList.backgroundColor = UIColor.white
            self.maltsList = maltsList
        }
        
        if self.hopsList == nil {
            
            let flowLayout = UICollectionViewFlowLayout()
            flowLayout.scrollDirection = .horizontal
            flowLayout.itemSize = cellSize
            
            let hopsList = UICollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: flowLayout)
            
            hopsList.tag = DetailViewMV.IngredientType.hop.rawValue
            hopsList.delegate   = self
            hopsList.dataSource = self
            hopsList.translatesAutoresizingMaskIntoConstraints = false
            hopsList.backgroundColor = UIColor.white
            
            self.contentView.addSubview(hopsList)
            
            let label = self.addLabel(collectionViewText: "홉", topView: self.maltsList!)
            
            let xLoc   = NSLayoutConstraint(item:hopsList, attribute:.left, relatedBy:.equal,
                                            toItem:self.contentView, attribute:.left,
                                            multiplier: 1.0, constant: 10.0);
            let topLoc   = NSLayoutConstraint(item:hopsList, attribute:.top,     relatedBy:.equal,
                                              toItem:label, attribute:.bottom,
                                              multiplier: 1.0, constant: 20.0);
            let width  = NSLayoutConstraint(item:hopsList, attribute:.right,   relatedBy:.equal,
                                            toItem:self.contentView, attribute:.right,
                                            multiplier: 1.0, constant: -10.0);
            let height  = NSLayoutConstraint(item:hopsList, attribute:.height,   relatedBy:.equal,
                                             toItem:nil, attribute:.notAnAttribute,
                                             multiplier: 1.0, constant: 160.0);
            let bottom  = NSLayoutConstraint(item:hopsList, attribute:.bottom,   relatedBy:.equal,
                                             toItem:self.contentView, attribute:.bottom,
                                             multiplier: 1.0, constant: -20.0);
            
            topLoc.priority = 600
            bottom.priority = 550
            
            self.contentView.addConstraints([xLoc, topLoc, width, height, bottom])
            
            hopsList.register(UICollectionViewCell.classForCoder(), forCellWithReuseIdentifier: self.hopsIdentifier)
            self.hopsList = hopsList
        }
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        
        super.willMove(toSuperview: newSuperview)
        
        self.drawContentsAndAbvLabel()
        self.drawCollectionViews()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.contentsLabel?.text = self.contentsText
        self.abvLabel?.text      = "avs \(self.abv) %"
    }
    
    /// 구성요소 가져오기
    ///
    /// - Parameter keyValue: 키 값
    /// - Returns: 조회한 값
    fileprivate func getIngredientsData(_ keyValue: String) -> [JSON]? {
        
        guard let data = self.ingredients else {
            
            return nil
        }
        
        if let datas = data[keyValue].array {
            
            return datas
        }
        
        return nil
    }
}

extension ContentsViewCell: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        let datas = self.getIngredientsData(collectionView.tag == DetailViewMV.IngredientType.hop.rawValue ? "hops" : "malt")
        
        return datas == nil ? 0 : datas!.count
    }
    
    /// cell에 라벨을 만든다
    ///
    /// - Parameter cell: 라벨을 만들 셀
    private func makeLabel(_ cell: UICollectionViewCell, _ text: String) {
        
        let contentsLabel = UILabel()
        
        contentsLabel.translatesAutoresizingMaskIntoConstraints = false
        contentsLabel.textColor = UIColor.white
        contentsLabel.textAlignment = .left
        contentsLabel.numberOfLines = 4
        contentsLabel.text = text
        contentsLabel.font = UIFont.systemFont(ofSize: 15)
        contentsLabel.lineBreakMode = .byTruncatingTail
        
        cell.contentView.addSubview(contentsLabel)
        
        let xLoc   = NSLayoutConstraint(item:contentsLabel, attribute:.centerX, relatedBy:.equal,
                                        toItem:cell.contentView, attribute:.centerX,
                                        multiplier: 1.0, constant: 10.0);
        let yLoc = NSLayoutConstraint(item:contentsLabel, attribute:.centerY, relatedBy:.equal,
                                      toItem:cell.contentView, attribute:.centerY,
                                      multiplier: 1.0, constant: 0.0);
        let width    = NSLayoutConstraint(item:contentsLabel, attribute:.width,   relatedBy:.equal,
                                          toItem:cell.contentView, attribute:.width,
                                          multiplier: 0.8, constant: 0.0);
        let height   = NSLayoutConstraint(item:contentsLabel, attribute:.height,   relatedBy:.equal,
                                          toItem:cell.contentView, attribute:.height,
                                          multiplier: 1.0, constant: 0.0);
        
        cell.contentView.addConstraints([xLoc, yLoc, width, height ])
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let datas = self.getIngredientsData(collectionView.tag == DetailViewMV.IngredientType.hop.rawValue ? "hops" : "malt")
        let data = datas![indexPath.row]
        
        if collectionView.tag == DetailViewMV.IngredientType.hop.rawValue {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.hopsIdentifier, for: indexPath)
            // Configure the cell
            
            cell.backgroundColor = UIColor.lightGray
            let addData = "name : \(data["name"].stringValue)\nvalue : \(data["amount"]["value"].numberValue) \(data["amount"]["unit"].stringValue)"
            for view in cell.contentView.subviews {
                
                if view is UILabel {
                    
                    (view as! UILabel).text = addData
                    return cell
                }
            }
            
            self.makeLabel(cell, addData)
            
            return cell
        }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.maltsIdentifier, for: indexPath)
            // Configure the cell
            
            cell.backgroundColor = UIColor.lightGray
            let addData = "name : \(data["name"].stringValue)\nvalue : \(data["amount"]["value"].numberValue) \(data["amount"]["unit"].stringValue)"
            for view in cell.contentView.subviews {
                
                if view is UILabel {
                    
                    (view as! UILabel).text = addData
                    return cell
                }
            }
            
            self.makeLabel(cell, addData)
            
            return cell
        }
        
    }
    
}

