//
//  QuesttionModel.swift
//  sdk
//
//  Created by yang chuang on 2021/4/21.
//

import Foundation
import HandyJSON

class QuestionModel: HandyJSON {
    ///题目ID
    var id    :Int = 0
    ///题目类型：nps（nps类型）、ces（费力度）、select（单选题）、checkbox（多选题）、text（文本）
    var type    :String?
    ///标题
    var title    :String?
    ///最小值（仅限nps、ces题型）
    var min    :Int = 0
    ///最大值（仅限nps、ces题型）
    var max    :Int = 0
    ///分数列表（仅限nps、ces题型）
    var rating_list    :Array<String>?
    ///最低分文案（仅限nps、ces题型）
    var low_legend    :String?
    ///最高分文案（仅限nps、ces题型）
    var high_legend    :String?
    ///整份问卷调查是否已结束 0：（否），1：（是）
    var is_complete    :Int  = 0
    ///本次访问ID
    var view_id    :Int = 0
    
    func showSureButton()->Bool {
        if self.is_complete == 1 || self.type == "checkbox" || self.type == "text" {
            return true
        }
        return false
    }
    
    required init() {}
}


class QuestioResponsenModel: HandyJSON {

    var data:QuestionModel? = nil
    var message:String? = nil
    required init() {}
}
