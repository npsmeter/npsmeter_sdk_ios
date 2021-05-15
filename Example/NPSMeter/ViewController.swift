//
//  ViewController.swift
//  NPSMeter
//
//  Created by mumenma on 05/02/2021.
//  Copyright (c) 2021 mumenma. All rights reserved.
//

import UIKit
import NPSMeter
import RxSwift
import RxCocoa
import PKHUD
import IQKeyboardManagerSwift

class ViewController: UIViewController,UITextFieldDelegate {
    
    var disposeBag = DisposeBag()
    let textField = UITextField()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        IQKeyboardManager.shared.enable = true
        
        let imageView = UIImageView(image: UIImage(named: "demo"))
        self.view.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        
        let logo = UIImageView(image: UIImage(named: "logo"))
        self.view.addSubview(logo)
        logo.snp.makeConstraints { make in
            make.left.equalTo(24)
            make.top.equalTo(55)
            make.width.equalTo(100)
            make.height.equalTo(100*(logo.image?.size.height)!/(logo.image?.size.width)!)
        }
                
        let startButton = UIButton(type: UIButton.ButtonType.custom)
        startButton.setTitle("显示问卷", for: UIControl.State.normal)
        startButton.backgroundColor = UIColor(red: 0, green: 0.54, blue: 1, alpha: 1)
        startButton.setTitleColor(UIColor.white, for: UIControl.State.normal)
        self.view.addSubview(startButton)
        startButton.rx.tap.subscribe{ (_) in
            NPSMeter.show(id:self.textField.text!, showResult:{ (success,error) in
                if error != nil {
                    HUD.flash(.label(error), delay: 2.0, completion: { (_) in
                                
                    })
                }
            });
        }.disposed(by: disposeBag)
        startButton.snp.makeConstraints { make in
            make.bottom.equalTo(-64);
            make.left.equalTo(24);
            make.right.equalTo(-24);
            make.height.equalTo(48);
        }
        startButton.layer.masksToBounds = true
        startButton.layer.cornerRadius = 3
        
        self.view.addSubview(self.textField)
        self.textField.text = "9e637a54b426cc17"
        self.textField.textAlignment = NSTextAlignment.center
        self.textField.backgroundColor = UIColor.white
        self.textField.snp.makeConstraints { make in
            make.left.height.right.equalTo(startButton)
            make.bottom.equalTo(startButton.snp.top).offset(-16)
        }
        self.textField.layer.masksToBounds = true
        self.textField.layer.cornerRadius = 3
        self.textField.delegate = self
        self.textField.textColor = UIColor(red: 0.165, green: 0.192, blue: 0.333, alpha: 1)
        self.textField.attributedPlaceholder = NSAttributedString(string: "请输入问卷id", attributes:[NSAttributedString.Key.foregroundColor:UIColor(red: 0.580, green: 0.596, blue: 0.667, alpha: 1)])
        self.downConfig()
        
        let label = UILabel()
        label.text = "新一代应用内调研工具"
        label.font = UIFont.boldSystemFont(ofSize: 28)
        self.view.addSubview(label)
        label.snp.makeConstraints { make in
            make.left.equalTo(self.textField)
            make.bottom.equalTo(self.textField.snp.top).offset(-32)
        }
    }
    
    func downConfig() {
        NPSMeter.downConfig(id:self.textField.text!){ (success,error) in
            if (success) {
                HUD.flash(.label("下载配置成功"), delay: 2.0, completion: { (_) in
                            
                })
            } else {
                let alertView = UIAlertController(title:error, message: nil, preferredStyle: UIAlertController.Style.alert)
                let alertAction1 = UIAlertAction(title: "重试",style: .destructive, handler: {
                        action in
                    self.downConfig()
                })
                let alertAction2 = UIAlertAction(title: "取消", style: .cancel)
                alertView.addAction(alertAction1)
                alertView.addAction(alertAction2)
                self.present(alertView, animated: true, completion: nil);
            }
        }
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.downConfig()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        IQKeyboardManager.shared.keyboardDistanceFromTextField = 80
    }

}

