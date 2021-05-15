//
//  QuestionView.swift
//  sdk
//
//  Created by yang chuang on 2021/4/21.
//

import Foundation
import UIKit
import SnapKit
import RxSwift
import RxCocoa
import PKHUD
import IQKeyboardManagerSwift

class QuestionView: UIView {

    var disposeBag = DisposeBag()
    var config:ConfigModel?
    let topView = UIView()
    var large = false
    let sureButton = UIButton.init(type: UIButton.ButtonType.custom)
    var viewForAnimating:UIView? = nil;
    
    public var question:QuestionModel!
    
    static func initQuestionView(question:QuestionModel)->QuestionView? {
        var questionView:QuestionView? = nil
        switch question.type {
        case "nps"://（nps类型）
            questionView = QuestionNpsView()
        case "ces"://（费力度）
            questionView = QuestionNpsView()
            (questionView as! QuestionNpsView).ces = true
        case "select"://（单选题）
            questionView = QuestionSelectView()
        case "checkbox"://（多选题）
            questionView = QuestionSelectView()
        case "text"://（文本）
            IQKeyboardManager.shared.enable = true
            questionView = QuestionTextView()
        default:break
        }
        questionView?.question = question
        return  questionView
    }
    
    func getMainView(width:Int)->UIView? {
        return nil
    }
    
    func imageFromColor(color: UIColor, viewSize: CGSize) -> UIImage{
        let rect: CGRect = CGRect(x: 0, y: 0, width: viewSize.width, height: viewSize.height)
        UIGraphicsBeginImageContext(rect.size)
        let context: CGContext = UIGraphicsGetCurrentContext()!
        context.setFillColor(color.cgColor)
        context.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsGetCurrentContext()
        return image!
    }
    
    func show(config:ConfigModel) {
        self.config = config
        let window = UIApplication.shared.windows.filter({ $0.isKeyWindow }).last
        
        window?.addSubview(self)
        self.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        self.frame = window!.bounds
        
        var width = window!.frame.size.width
        self.large = false
        if width > 600 {
            width = 600
            self.large = true
        }
        var bottomOffset = 0;
        if window?.safeAreaInsets.bottom ?? 0 > 0.0 {
            
            let safeBottomView = UIView()
            safeBottomView.backgroundColor = config.backgroundColor()
            self.addSubview(safeBottomView)
            safeBottomView.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.width.equalTo(width)
                make.height.equalTo(34)
                make.bottom.equalTo(0)
            }
            
            
            bottomOffset = 34;
        }
        
        if config.show_logo == 1 {
            let logoView = UIView()
            logoView.backgroundColor = config.backgroundColor()
            self.addSubview(logoView)
            
            logoView.snp.makeConstraints { (make) in
                make.centerX.equalToSuperview()
                make.width.equalTo(width)
                make.bottom.equalTo(-bottomOffset)
                make.height.equalTo(52)
            }
            bottomOffset += 52
            
            let logoLabel = UILabel()
            logoLabel.font = UIFont.systemFont(ofSize: 14)
            let str = NSMutableAttributedString.init(string: "Powered by NPSMeter")
            str.setAttributes([NSAttributedString.Key.foregroundColor:self.config!.primaryColor()], range: NSRange(str.string.range(of: "NPSMeter")!,in: str.string))
            logoLabel.textColor = self.config?.textColor().withAlphaComponent(0.3)
            logoLabel.attributedText = str
            logoView.addSubview(logoLabel)
            logoLabel.snp.makeConstraints { (make) in
                make.center.equalToSuperview()
            }
            
            let lineBackView = UIView()
            lineBackView.backgroundColor = self.config?.backgroundColor()
            self.addSubview(lineBackView)
            lineBackView.snp.makeConstraints { (make) in
                make.centerX.equalToSuperview()
                make.bottom.equalTo(-bottomOffset)
                make.width.equalTo(width)
                make.height.equalTo(8)
            }
            
            let lineView = UIView()
            lineView.backgroundColor = self.config?.textColor().withAlphaComponent(0.06)
            self.addSubview(lineView)
            lineView.snp.makeConstraints { (make) in
                make.centerX.equalToSuperview()
                make.bottom.equalTo(-bottomOffset)
                make.width.equalTo(width)
                make.height.equalTo(8)
            }
            bottomOffset += 8
        }
        if self.question.showSureButton() {
            let sureView = UIView()
            sureView.backgroundColor = config.backgroundColor()
            self.addSubview(sureView)
            sureView.snp.makeConstraints { (make) in
                make.centerX.equalToSuperview()
                make.width.equalTo(width)
                make.bottom.equalTo(-bottomOffset)
                make.height.equalTo(62)
            }
            
            self.sureButton.isEnabled = false
            sureButton.rx.tap.subscribe { [weak self] (next) in
                self!.answerQuestion(rating: nil, answer: self!.answer())
            }.disposed(by: disposeBag)
            sureButton.setBackgroundImage(self.imageFromColor(color: (self.config?.primaryColor())!, viewSize: CGSize(width: 1, height: 1)), for: UIControl.State.normal)
            sureButton.setBackgroundImage(self.imageFromColor(color: (self.config?.primaryColor())!.withAlphaComponent(0.7), viewSize: CGSize(width: 1, height: 1)), for: UIControl.State.disabled)
            sureView.addSubview(sureButton)
            sureButton.snp.makeConstraints { (make) in
                make.left.equalTo(20)
                make.right.equalTo(-20)
                make.top.equalTo(12)
                make.height.equalTo(40)
            }
            sureButton.setTitle("提  交", for: UIControl.State.normal)
            sureButton.setTitleColor(UIColor.white, for: UIControl.State.normal)
            sureButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
            sureButton.layer.masksToBounds = true
            sureButton.layer.cornerRadius = 4
            
            bottomOffset += 62
        } else {
            let sureView = UIView()
            sureView.backgroundColor = config.backgroundColor()
            self.addSubview(sureView)
            sureView.snp.makeConstraints { (make) in
                make.centerX.equalToSuperview()
                make.width.equalTo(width)
                make.bottom.equalTo(-bottomOffset)
                make.height.equalTo(20)
            }
            bottomOffset += 20
        }
        self.viewForAnimating = self.getMainView(width: Int(width))
        if self.viewForAnimating != nil {
            if Int(window!.frame.size.height) < bottomOffset + 90 + 80 + Int(self.viewForAnimating!.frame.size.height) {
                let height = Int(window!.frame.size.height) - bottomOffset - 80 - 90
                self.viewForAnimating!.frame = CGRect.init(x: self.frame.size.width/2 - width/2, y: 80 + 90, width: width, height:CGFloat(height));
                bottomOffset += Int(height)
            } else {
                let height = self.viewForAnimating!.frame.size.height
                self.viewForAnimating!.frame = CGRect.init(x: self.frame.size.width/2 - width/2, y: CGFloat(Int(window!.frame.size.height) - Int(height) - bottomOffset), width:width, height:CGFloat(height));
                bottomOffset += Int(height)
            }
            self.addSubview(self.viewForAnimating!)
        }
        
        topView.backgroundColor = config.backgroundColor()
        topView.frame = CGRect.init(x: self.frame.size.width/2 - width/2, y: CGFloat(Int(window!.frame.size.height) - bottomOffset - 90), width: width, height: 90)
        self.addSubview(topView)
        
        let maskPath = UIBezierPath.init(roundedRect: topView.bounds, byRoundingCorners: UIRectCorner(rawValue: UIRectCorner.topLeft.rawValue + UIRectCorner.topRight.rawValue), cornerRadii: CGSize(width: 12, height: 12))
        let maskLayer = CAShapeLayer.init()
        maskLayer.frame = topView.bounds
        maskLayer.path = maskPath.cgPath
        topView.layer.mask = maskLayer
        
        let topTitleLabel = UILabel()
        topView.addSubview(topTitleLabel)
        topTitleLabel.textColor = config.textColor()
        topTitleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        topTitleLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(-16)
            make.left.greaterThanOrEqualTo(40)
            make.right.lessThanOrEqualTo(-40)
        }
        topTitleLabel.numberOfLines = 2
        topTitleLabel.text = self.question.title
        
        let closeButton = UIButton(type: UIButton.ButtonType.custom)
        topView.addSubview(closeButton)
        
        let image:UIImage! = UIImage(contentsOfFile: (Bundle.init(path:Bundle.init(for: QuestionView.self).path(forResource: "NPSMeter", ofType: "bundle")!)!).path(forResource: "close@3x", ofType: "png")!)
        
        let rect = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
        UIGraphicsBeginImageContext(rect.size);
        let context:CGContext! = UIGraphicsGetCurrentContext()
        context.clip(to: rect, mask: image.cgImage!)
        context.setFillColor((self.config?.textColor().withAlphaComponent(0.5).cgColor)!)
        context.fill(rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        closeButton.setImage(img, for: UIControl.State.normal)
        closeButton.rx.tap.subscribe { [weak self] (next) in
            self!.removeFromSuperview()
        }.disposed(by: disposeBag)
        closeButton.snp.makeConstraints { (make) in
            make.top.equalTo(15)
            make.right.equalTo(-15)
            make.width.height.equalTo(30)
        };
    }
    
    func answer()->Any? {
        return nil
    }
    
    func answerQuestion(rating:Int? = nil,answer:Any? = nil){
        self.isUserInteractionEnabled = false
        
        let activityView = UIActivityIndicatorView()
        activityView.center = CGPoint(x: (self.viewForAnimating?.frame.size.width)!/2, y: (self.viewForAnimating?.frame.size.height)!/2)
        // 停止后，隐藏菊花
        activityView.hidesWhenStopped = true
        //Style: whiteLarge比较大的白色环形进度条;white白色环形进度条;gray灰色环形进度条
        activityView.style = UIActivityIndicatorView.Style.gray
        self.viewForAnimating!.addSubview(activityView)
        activityView.startAnimating()
        
        ServiceApi.answer(id: self.config!.id!, question_id: self.question.id, view_id: self.question.view_id, rating:rating, answer: answer) { (question:QuestionModel?, error:String?) in
            self.isUserInteractionEnabled = true
            activityView.stopAnimating()
            activityView.removeFromSuperview()
            if question != nil {
                if question?.is_complete == 1 {//已经结束，展示感谢
                    let toast = ToastView()
                    toast.config = self.config
                    toast.show()
                    self.removeFromSuperview()
                } else {
                    let questionView = QuestionView.initQuestionView(question: question!);
                    questionView?.show(config: self.config!)
                    self.removeFromSuperview()
                }
            } else {
                if error != nil {
                    HUD.flash(.label(error), delay: 2.0, completion: { (_) in
                                
                    })
                }
            }
        }
    }
    
    
    func createImageWithColor(color:UIColor) -> UIImage {
        var resultImage: UIImage? = nil
        let rect = CGRect(x: 0, y: 0, width:1, height:1)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, UIScreen.main.scale)

        guard let context = UIGraphicsGetCurrentContext() else {

            return resultImage!
        }

        context.setFillColor(color.cgColor)
        context.fill(rect)
        resultImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resultImage!
    }
}
