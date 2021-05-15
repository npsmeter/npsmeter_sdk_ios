//
//  ConfigModel.swift
//  sdk
//
//  Created by yang chuang on 2021/4/21.
//

import Foundation
import UIKit
import HandyJSON

class ConfigModel:HandyJSON {
    ///问卷ID
    var id: String?
    ///主色调
    var primary_color: String = "#0089FF"
    ///背景颜色
    var background_color: String = "#FFFFFF"
    ///文字颜色
    var text_color: String = "#2A3155"
    ///问卷类型：NPS、CES（费力度）、COMMON（通用）
    var campaign_type: String?
    ///距离第一次打开天数
    var from_first_day: Int = 0
    ///感谢语
    var thanks_fields: String = "感谢您的反馈"
    ///多少天后可再次弹出
    var repeat_duration: Int  = 0
    ///是否展示底部logo：1（是）、0（否）
    var show_logo: Int  = 0
    ///问卷状态：1（启用）、0（未启用）
    var status: Int = 0
        
    func primaryColor()->UIColor {
        return UIColor.init(hexString: self.primary_color)
    }
    
    func backgroundColor()->UIColor {
        return UIColor.init(hexString: self.background_color)
    }
    
    func textColor()->UIColor {
        return UIColor.init(hexString: self.text_color)
    }
    
    required init() {}
}

class ConfigResponse:HandyJSON {
    var data:ConfigModel? = nil
    
    var message:String?
    
    required init() {}
}
