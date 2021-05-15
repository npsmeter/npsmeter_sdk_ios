//
//  ToastView.swift
//  sdk
//
//  Created by yang chuang on 2021/4/22.
//

import UIKit
import SwiftSVG

class ToastView: UIView {
    
    var config:ConfigModel? = nil
    
    func show(){
        if self.config != nil {
            
            let window = UIApplication.shared.windows.filter({ $0.isKeyWindow }).last
            
            let whiteView = UIView()
            let label = UILabel()
            whiteView.backgroundColor = config?.backgroundColor()
            whiteView.layer.masksToBounds = true
            whiteView.addSubview(label)
            window?.addSubview(whiteView)
            
            label.numberOfLines = 0
            label.text = config?.thanks_fields
            label.textColor = config?.textColor()
            label.font = UIFont.boldSystemFont(ofSize: 18)
            label.frame = CGRect(x: 0, y: 0, width: CGFloat((window?.frame.size.width)!) - 200, height: 0)
            label.sizeToFit()
            label.textColor = config?.textColor()
            whiteView.frame = CGRect(x: 0,y: 0,width: label.frame.size.width + 72,height: label.frame.size.height + 12)
            whiteView.layer.cornerRadius = whiteView.frame.size.height/2
            label.frame = CGRect(x: 36, y: 6, width: label.frame.size.width, height: label.frame.size.height)
            
            
            let image:UIImage! = UIImage(contentsOfFile: (Bundle.init(path:Bundle.init(for: QuestionView.self).path(forResource: "NPSMeter", ofType: "bundle")!)!).path(forResource: "right@3x", ofType: "png")!)
            let imageView = UIImageView(image: image)
            window?.addSubview(imageView)

            let redView = UIView()
            imageView.addSubview(redView)
            redView.backgroundColor = config?.primaryColor()
            redView.frame = CGRect(x: 13,y: 13,width: 5,height: 16)
            redView.layer.masksToBounds = true
            redView.layer.cornerRadius = 1
            
            whiteView.frame = CGRect(x: (window?.frame.size.width)!/2 - whiteView.frame.size.width/2, y: (window?.frame.size.height)!, width: whiteView.frame.size.width , height: whiteView.frame.size.height)
            
            var bottomOffset = 0;
            if window?.safeAreaInsets.bottom ?? 0 > 0.0 {
                bottomOffset = 34;
            }
            
            whiteView.frame = CGRect(x: (window?.frame.size.width)!/2 - whiteView.frame.size.width/2, y: (window?.frame.size.height)!, width: whiteView.frame.size.width , height: whiteView.frame.size.height)
            imageView.frame = CGRect(x: whiteView.frame.origin.x - 9, y: whiteView.frame.origin.y - 7, width: 40, height: 40)
            whiteView.alpha = 0
            imageView.alpha = 0
            label.alpha = 0
            UIView.animate(withDuration: 0.3, delay: 0, options: UIView.AnimationOptions.curveEaseOut) {
                whiteView.frame = CGRect(x: (window?.frame.size.width)!/2 - whiteView.frame.size.width/2, y: (window?.frame.size.height)! - 41 - CGFloat(bottomOffset) - whiteView.frame.size.height , width: whiteView.frame.size.width , height: whiteView.frame.size.height)
                imageView.frame = CGRect(x: whiteView.frame.origin.x - 9, y: whiteView.frame.origin.y - 7, width: 40, height: 40)
                imageView.alpha = 1
                whiteView.alpha = 1
                label.alpha = 1
            } completion: { _ in
                UIView.animate(withDuration: 0.2, delay: 2, options: UIView.AnimationOptions.curveLinear) {
                    whiteView.frame = CGRect(x: (window?.frame.size.width)!/2 - whiteView.frame.size.width/2, y: (window?.frame.size.height)!, width: whiteView.frame.size.width , height: whiteView.frame.size.height)
                    imageView.frame = CGRect(x: whiteView.frame.origin.x - 9, y: whiteView.frame.origin.y - 7, width: 40, height: 40)
                    imageView.alpha = 0
                    whiteView.alpha = 0
                    label.alpha = 0
                } completion: { _ in
                    imageView.snp.removeConstraints()
                    whiteView.removeFromSuperview()
                    imageView.removeFromSuperview()
                }
            }

        }
    }
}
