//
//  QuestionSelectView.swift
//  sdk
//
//  Created by yang chuang on 2021/4/21.
//

import UIKit
import RxSwift
import RxRelay
import RxCocoa

class LeftEqualFlowLayout: UICollectionViewFlowLayout {

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributes = super.layoutAttributesForElements(in: rect)
        var leftMargin = sectionInset.left + 20
        var maxY: CGFloat = -1.0
        attributes?.forEach { layoutAttribute in
            if layoutAttribute.frame.origin.y >= maxY {
                leftMargin = sectionInset.left + 20
            }
            if layoutAttribute.frame.origin.x > leftMargin {
                layoutAttribute.frame.origin.x = leftMargin
            }
            leftMargin += layoutAttribute.frame.width + minimumInteritemSpacing
            maxY = max(layoutAttribute.frame.maxY , maxY)
        }
        return attributes
    }
}

class QuestionSelectView: QuestionView, UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.question.rating_list?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:QuestionSelectCell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(QuestionSelectCell.self), for: indexPath) as! QuestionSelectCell
        cell.label.text = self.question.rating_list![indexPath.row]
        cell.showSureButton = self.question.showSureButton();
        cell.large = self.large
        cell.set(config: self.config!, choice: self.choiceArray.contains(cell.label.text! as String))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let text:String! = self.question.rating_list![indexPath.row]
        if self.large {
            let width = ((self.collection?.frame.size.width)! - 20 * 2 - 12)/2 - 24
            let largeWidth = (self.collection?.frame.size.width)! - 20 * 2 - 24
            let height = text.boundingRect(with:CGSize(width:width, height:1000), options: NSStringDrawingOptions.usesLineFragmentOrigin , attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 16)], context: nil).height
            let largeHeight = text.boundingRect(with:CGSize(width:largeWidth, height:1000), options: NSStringDrawingOptions.usesLineFragmentOrigin , attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 16)], context: nil).height
            if height < largeHeight + 1 {
                return CGSize(width:((self.collection?.frame.size.width)! - 20 * 2 - 12)/2, height: height + 24)
            } else {
                return CGSize(width:(self.collection?.frame.size.width)! - 20 * 2, height: largeHeight + 24)
            }
        } else {
            let width = (self.collection?.frame.size.width)! - 24;
            let height = text.boundingRect(with:CGSize(width:width, height:1000), options: NSStringDrawingOptions.usesLineFragmentOrigin , attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 16)], context: nil).height
            return CGSize(width:(self.collection?.frame.size.width)! - 40, height: height + 24)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let text = self.question.rating_list![indexPath.row]
        if choiceArray.contains(text) {
            choiceArray.remove(text)
        } else {
            choiceArray.add(text)
        }
        self.collection?.reloadData()
        if !self.question.showSureButton() {
            self.answerQuestion(rating: nil, answer: [text])
        } else {
            if choiceArray.count > 0 {
                self.sureButton.isEnabled = true
            } else {
                self.sureButton.isEnabled = false
            }
        }
    }
    
    override func answer() -> Any? {
        return self.choiceArray
    }
    
    var collection:UICollectionView? = nil
    let choiceArray = NSMutableArray()
    
    override func getMainView(width:Int)->UIView? {
        let layout = LeftEqualFlowLayout()
        self.collection = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        self.collection?.register(QuestionSelectCell.self, forCellWithReuseIdentifier: NSStringFromClass(QuestionSelectCell.self))
        self.collection?.delegate = self
        self.collection?.dataSource = self
        self.collection?.backgroundColor = self.config?.backgroundColor()
        
        var haveSmall = false
        var totalHeight = 0
        for i in 0..<self.question.rating_list!.count {
            let text = self.question.rating_list![i]
            if (self.large) {
                let width = ((self.collection?.frame.size.width)! - 18 * 2 - 12)/2 - 24
                let largeWidth = (self.collection?.frame.size.width)! - 18 * 2 - 24
                let height = text.boundingRect(with:CGSize(width:width, height:1000), options: NSStringDrawingOptions.usesLineFragmentOrigin , attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 16)], context: nil).height
                let largeHeight = text.boundingRect(with:CGSize(width:largeWidth, height:1000), options: NSStringDrawingOptions.usesLineFragmentOrigin , attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 16)], context: nil).height
                if height < largeHeight + 1 {
                    if haveSmall {
                        haveSmall = false
                    } else {
                        haveSmall = true
                        totalHeight = totalHeight + 8 + Int(height) + 24
                    }
                } else {
                    haveSmall = false
                    totalHeight = totalHeight + 8 + Int(largeHeight) + 24
                }
            } else {
                let width = (self.collection?.frame.size.width)! - 24;
                let height = text.boundingRect(with:CGSize(width:width, height:1000), options: NSStringDrawingOptions.usesLineFragmentOrigin , attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 16)], context: nil).height
                totalHeight = totalHeight + 8 + Int(height) + 24
            }
        }
        self.collection?.frame = CGRect(x: 0,y: 0,width:width, height:totalHeight)
        return self.collection
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0,left: 20,bottom: 0,right: 20)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8;
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if self.large {
            return 12;
        }
        return 0
    }
}
