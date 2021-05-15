//
//  ServiceApi.swift
//  sdk
//
//  Created by yang chuang on 2021/4/21.
//

import Foundation
import Alamofire
import HandyJSON
import SwiftyJSON

class ServiceApi {
    
    static func isjsonStyle(txt:String) -> Bool {
          let jsondata = txt.data(using: .utf8)
          do {
              try JSONSerialization.jsonObject(with: jsondata!, options: .mutableContainers)
              return true
          } catch {
              return false
          }
      }
    
    static let sdkVersion = "1.0.0"
    static let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"]
    static let baseUrl = "https://app.npsmeter.cn"
    
    static func config(id:String,configResult: @escaping (_ config:ConfigModel?,_ error:String?)->Void) {
        var params = ["id":id] as [String : Any]
        params["platform"] = "iOS"
        params["version"] = version
        params["sdk_version"] = sdkVersion

        var client_info = ["os_name":"iOS"] as [String:Any]
        
        client_info["screen"] = String(format: "%ld*%ld",UIScreen.main.bounds.width,UIScreen.main.bounds.height)
        client_info["language"] = Locale.preferredLanguages.first
        
        params["client_info"] = client_info
        
        AF.request("\(baseUrl)/sdkapi/campaign/config",method: .get,parameters:params){ urlRequest in
            urlRequest.timeoutInterval = 4
        }.responseJSON(completionHandler: { (response:AFDataResponse<Any>) in
            switch response.result {
            case .success:
                let json = JSON(response.value ?? "")
                let jsonStr = json.rawString(String.Encoding.utf8,options: JSONSerialization.WritingOptions.prettyPrinted) ?? ""
                let configResponse:ConfigResponse? = (ConfigResponse.deserialize(from:jsonStr) ?? nil) as ConfigResponse?
                configResult(configResponse?.data,configResponse?.message)
            case .failure(let error):
                configResult(nil,error.underlyingError?.localizedDescription)
            }
        })
    }
    
    static func openView(id:String,userid:String?,username:String?,params:Dictionary<String, Any>?,questionResult: @escaping (_ question:QuestionModel?,_ error:String?)->Void) {
        var requestParams = ["id":id] as [String : Any]
        requestParams["platform"] = "iOS"
        requestParams["version"] = version
        requestParams["sdk_version"] = sdkVersion
        requestParams["uuid"] = UIDevice.current.identifierForVendor?.uuidString;
        requestParams["first_view_time"] = Date().timeIntervalSince1970;
        requestParams["userid"] = userid
        requestParams["username"] = username
        requestParams["params"] = params
        var client_info = ["os_name":"iOS"] as [String:Any]
        client_info["screen"] = String(format: "%ld*%ld",UIScreen.main.bounds.width,UIScreen.main.bounds.height)
        client_info["language"] = Locale.preferredLanguages.first
        requestParams["client_info"] = client_info
        requestParams["is_customer_open"] = 1
        AF.request("\(baseUrl)/sdkapi/campaign/openView",method: .post,parameters:requestParams){ urlRequest in
            urlRequest.timeoutInterval = 4
        }.responseJSON(completionHandler: { (response:AFDataResponse<Any>) in
            switch response.result {
            case .success:
                let json = JSON(response.value ?? "")
                let jsonStr = json.rawString(String.Encoding.utf8,options: JSONSerialization.WritingOptions.prettyPrinted) ?? ""
                let question:QuestioResponsenModel? = (QuestioResponsenModel.deserialize(from:jsonStr) ?? nil) as QuestioResponsenModel?
                questionResult(question?.data,question?.message)
            case .failure(let error):
                questionResult(nil,error.underlyingError?.localizedDescription)
            }
        })

    }
    
    static func answer(id:String,
                       question_id:Int,
                       view_id:Int,
                       rating:Int?,
                       answer:Any?,
                       questionResult: @escaping (_ question:QuestionModel?,_ error:String?)->Void) {
        var params = ["id":id,"question_id":question_id,"view_id":view_id] as [String : Any]
        params["platform"] = "iOS"
        params["version"] = version
        params["sdk_version"] = sdkVersion
        if rating != nil {
            params["rating"] = rating
        }
        if answer != nil {
            params["answer"] = answer
        }
        
        AF.request("\(baseUrl)/sdkapi/campaign/answer",method: .post,parameters:params){ urlRequest in
            urlRequest.timeoutInterval = 4
        }.responseJSON(completionHandler: { (response:AFDataResponse<Any>) in
            switch response.result {
            case .success:
                let json = JSON(response.value ?? "")
                let jsonStr = json.rawString(String.Encoding.utf8,options: JSONSerialization.WritingOptions.prettyPrinted) ?? ""
                let question:QuestioResponsenModel? = (QuestioResponsenModel.deserialize(from:jsonStr) ?? nil) as QuestioResponsenModel?
                questionResult(question?.data,question?.message)
            case .failure(let error):
                questionResult(nil,error.underlyingError?.localizedDescription)
            }
        }
     )
    }
}
