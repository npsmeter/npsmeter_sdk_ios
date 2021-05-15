//
//  QuestionSelectCell.swift
//  sdk
//
//  Created by yang chuang on 2021/4/22.
//

import UIKit

class QuestionSelectCell: UICollectionViewCell {
    
    let label = UILabel()
    var showSureButton = false
    var large  = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clear
        self.addSubview(self.label);
        self.label.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(12)
            make.right.equalTo(-12)
        }
        self.label.numberOfLines = 0
        self.label.font = UIFont.systemFont(ofSize: 16)
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 4
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(config:ConfigModel,choice:Bool) {
        if choice {
            self.backgroundColor = config.primaryColor()
            self.label.textColor = UIColor.white
        } else {
            self.backgroundColor = config.textColor().withAlphaComponent(0.06)
            self.label.textColor = config.textColor()
        }
    }
}
