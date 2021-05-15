//
//  QuestionNpsView.swift
//  sdk
//
//  Created by yang chuang on 2021/4/22.
//

import UIKit


class QuestionNpsView: QuestionView {
    
    let buttonArray:NSMutableArray = NSMutableArray()
    var ces = false//nps 10,ces 5
    
    override func getMainView(width:Int)->UIView? {
        let view = UIView()
        view.backgroundColor = self.config?.backgroundColor()
        
        var buttonWidth = (width - 20 * 2 - 14 * 5)/6;
        var maxNum = 10
        var padding = 0
        var space = 0
        var minNum = 0
        var buttonHeight = 44
        if ces {
            minNum = 1
            maxNum = 5
            if large {
                view.frame = CGRect.init(x: 0, y: 0, width:width, height: 68);
                buttonWidth = 44
                space = 16
                padding = (width - buttonWidth * 5 - space * 4)/2
                buttonHeight = 44
            } else {
                view.frame = CGRect.init(x: 0, y: 0, width:width, height: 98);
                padding = 34
                space = 22
                buttonWidth = (width - 34 * 2 - 4 * space)/5;
            }
            padding = padding - buttonWidth - space
        } else {
            if large {
                view.frame = CGRect.init(x: 0, y: 0, width:width, height: 94);
                padding = 9
                space = 10
                buttonWidth = (width - 9 * 2 - 10 * space)/11;
                buttonHeight = 44
            } else {
                view.frame = CGRect.init(x: 0, y: 0, width:width, height: 154);
            }
        }
        
        for i in minNum...maxNum {
            let button = UIButton.init(type: UIButton.ButtonType.custom)
            view.addSubview(button)
            let title = String(i)
            button.setTitle(title, for: UIControl.State.normal)
            button.setBackgroundImage(self.createImageWithColor(color:self.config!.textColor().withAlphaComponent(0.06)), for: UIControl.State.normal)
            button.setTitleColor(self.config!.textColor().withAlphaComponent(0.75), for: UIControl.State.normal)
            button.setBackgroundImage(self.createImageWithColor(color: self.config!.primaryColor()), for: UIControl.State.highlighted)
            button.setTitleColor(self.config?.backgroundColor(), for: UIControl.State.highlighted)
            button.setBackgroundImage(self.createImageWithColor(color: self.config!.primaryColor()), for: UIControl.State.selected)
            button.setTitleColor(self.config?.backgroundColor(), for: UIControl.State.selected)
            button.layer.masksToBounds = true
            button.layer.cornerRadius = 4
            if self.large || self.ces {
                button.frame = CGRect.init(x: padding + (buttonWidth + space) * i, y: 0, width: buttonWidth, height: buttonHeight)
            } else {
                if i < 6 {
                    button.frame = CGRect.init(x: 20 + (buttonWidth + 14) * i, y: 0, width: buttonWidth, height: buttonHeight)
                } else {
                    button.frame = CGRect.init(x: (width - buttonWidth * 5 - 14 * 4)/2  + (buttonWidth + 14) * (i-6), y: 60, width: buttonWidth, height: buttonHeight)
                }
            }
            weak var weakSelf = self
            button.rx.tap.subscribe { [weak self] (next) in
                weakSelf!.buttonArray.enumerateObjects { (object, index, _) in
                    let button = object as! UIButton
                    if index + minNum > i {
                        button.isSelected = false
                    } else {
                        button.isSelected = true
                    }
                }
                weakSelf!.answerQuestion(rating: i, answer: nil)
            }.disposed(by: disposeBag)
            self.buttonArray.add(button)
        }
        
        let leftLabel = UILabel()
        let rightLabel = UILabel()
        leftLabel.text = self.question.low_legend
        rightLabel.text = self.question.high_legend
        view.addSubview(leftLabel)
        view.addSubview(rightLabel)
        
        leftLabel.textColor = self.config?.textColor().withAlphaComponent(0.5)
        rightLabel.textColor = leftLabel.textColor
        leftLabel.font = UIFont.systemFont(ofSize: 12)
        rightLabel.font = leftLabel.font
        
        if ces && large {
            leftLabel.snp.makeConstraints { (make) in
                make.left.equalTo(86)
                make.top.equalTo(13)
            }
            rightLabel.snp.makeConstraints { (make) in
                make.right.equalTo(-86)
                make.top.equalTo(13)
            }
        } else {
            leftLabel.snp.makeConstraints { (make) in
                make.left.equalTo(20)
                make.bottom.equalTo(-20)
            }
            rightLabel.snp.makeConstraints { (make) in
                make.right.bottom.equalTo(-20)
            }
        }
    
        return view
    }
}
