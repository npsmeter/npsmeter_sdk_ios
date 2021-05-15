//
//  QuestionTextView.swift
//  sdk
//
//  Created by yang chuang on 2021/4/21.
//

import UIKit
import IQKeyboardManagerSwift

class QuestionTextView: QuestionView, UITextViewDelegate {

    let textView = UITextView()
    let placeHolderLabel = UILabel()
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func getMainView(width:Int)->UIView? {
        let view = UIView()
        view.frame = CGRect.init(x: 0, y: 0, width: width, height: 98);
        view.backgroundColor = self.config?.backgroundColor()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(notification:)), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector:#selector(self.keyboardWillHide(notification:)), name:UIResponder.keyboardWillHideNotification, object: nil)
                
        textView.delegate = self
        view.addSubview(textView)
        textView.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.top.equalTo(0)
            make.right.equalTo(-20)
            make.bottom.equalTo(-12)
        }
        textView.layer.masksToBounds = true
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.layer.cornerRadius = 2
        textView.layer.borderWidth = 1
        textView.backgroundColor = UIColor.clear
        textView.layer.borderColor = self.config?.textColor().withAlphaComponent(0.3).cgColor
        textView.textColor = self.config?.textColor()
        
        textView.addSubview(self.placeHolderLabel)
        self.placeHolderLabel.textColor = self.config?.textColor().withAlphaComponent(0.3)
        self.placeHolderLabel.text = "请输入文字"
        self.placeHolderLabel.font = UIFont.systemFont(ofSize: 14)
        self.placeHolderLabel.snp.makeConstraints { (make) in
            make.left.equalTo(12)
            make.top.equalTo(8)
        }
        
        return view
    }
        
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.lengthOfBytes(using: String.Encoding.utf8) > 0 {
            self.placeHolderLabel.isHidden = true
            self.sureButton.isEnabled = true
        } else {
            self.placeHolderLabel.isHidden = false
            self.sureButton.isEnabled = false
        }
    }
    
    @objc func keyboardWillShow(notification:NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            UIView.animate(withDuration: 0.5) {
                print(keyboardSize.height, self.frame.size.height,self.textView.superview!.frame.origin.y)
                self.frame.origin.y = -(keyboardSize.height - self.frame.size.height + self.textView.frame.size.height + self.textView.superview!.frame.origin.y + 64)
            }
        }
    }

    @objc func keyboardWillHide(notification:NSNotification) {
        if ((notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue) != nil {
            UIView.animate(withDuration: 0.5) {
                print(1)
                self.frame.origin.y  = 0
            }
        }
    }
    
    override func answer() -> Any? {
        return self.textView.text
    }
    
}
