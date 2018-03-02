//
//  MenuCell.swift
//  Youtube
//
//  Created by AI Local Admin on 11/12/17.
//  Copyright © 2017 AI Local Admin. All rights reserved.
//

import UIKit
class MenuCell: BaseCell {
    // MARK: - UIViews.
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.image = UIImage(named: "home")?.withRenderingMode(.alwaysTemplate)
        iv.tintColor = Constants.Color.defaultMenubarColor
        return iv
    }()
    
    override var isHighlighted: Bool {
        didSet {
            imageView.tintColor = isHighlighted ? UIColor.white : Constants.Color.defaultMenubarColor
        }
    }
    
    override var isSelected: Bool {
        didSet {
            imageView.tintColor = isSelected ? UIColor.white : Constants.Color.defaultMenubarColor
        }
    }
    // MARK: - Methods.
    override func setupViews() {
        super.setupViews()
       
        addSubview(imageView)
        
        addConstriantsWith(format: "H:[v0(28)]", views:  imageView)
        addConstriantsWith(format: "V:[v0(28)]", views:  imageView)

        imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        

    }
}
