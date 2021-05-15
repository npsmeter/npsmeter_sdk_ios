//
//  NPSmeterManager.swift
//  sdk
//
//  Created by yang chuang on 2021/4/21.
//

import Foundation

@objc public class NPSMeter: NSObject {
    
    
    @objc public static func downConfig(id:String,downResult: @escaping (_ success:Bool,_ error:String?)->Void) {
        ServiceApi.config(id: id) { (config,error) in
            if config == nil {
                downResult(false,error)
            } else {
                dic[id] = config
                downResult(true,error)
            }
        }
    }
    
    
    
    static var dic:Dictionary<String,ConfigModel> = Dictionary()
    
    @objc public static func show(id:String,showResult: @escaping (_ success:Bool,_ error:String?)->Void) {
        let model = dic[id]
        if model != nil {
            ServiceApi.openView(id: id,userid: nil,username: nil,params: nil) { question, error in
                if question != nil {
                    let questionView = QuestionView.initQuestionView(question:question!)
                    questionView?.show(config: model!)
                    showResult(true,error)
                } else {
                    showResult(false,error)
                }
            }
        }
     }
}
