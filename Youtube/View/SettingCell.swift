//
//  SettingCell.swift
//  Youtube
//
//  Created by AI Local Admin on 13/12/17.
//  Copyright © 2017 AI Local Admin. All rights reserved.
//

import UIKit
class SettingCell: BaseCell {
    override var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? UIColor.darkGray : UIColor.white
            nameLabel.textColor = isHighlighted ? UIColor.white : UIColor.black
            iconImageView.tintColor = isHighlighted ? UIColor.white : UIColor.darkGray
        }
    }
    var setting: Setting? {
        didSet {
            nameLabel.text = setting?.name.rawValue
            
            if let imageName = setting?.imageName {
                iconImageView.image = UIImage(named: imageName)?.withRenderingMode(.alwaysTemplate)
                iconImageView.tintColor = UIColor.darkGray
            }
        }
    }
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Settings"
        label.font = UIFont.systemFont(ofSize: 13)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let iconImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.image = UIImage(named: "settings")
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    override func setupViews() {
        super.setupViews()
        addSubview(nameLabel)
        addSubview(iconImageView)
        
        addConstriantsWith(format: "H:|-16-[v0(30)]-8-[v1]|", views: iconImageView, nameLabel)
        
        addConstriantsWith(format: "V:|[v0]|", views: nameLabel)
        addConstriantsWith(format: "V:[v0(30)]", views: iconImageView)
        iconImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
}
