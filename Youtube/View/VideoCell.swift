//
//  VideoCell.swift
//  Youtube
//
//  Created by AI Local Admin on 11/12/17.
//  Copyright © 2017 AI Local Admin. All rights reserved.
//

import UIKit
class BaseCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    func setupViews() {
        
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
class VideoCell: BaseCell {
    let numberFormatter = NumberFormatter()
    var video: Video? {
        didSet {
            setupThumnailImage()
            setupProfileImage()
            
            titleLabel.text = video!.title
            if let channelName = video?.channel?.name, let numberOfViews = video?.numberOfViews {
                numberFormatter.numberStyle = .decimal
                let nov = String(describing: numberFormatter.string(from: numberOfViews as NSNumber)!)
                let subtitleText = "\(String(describing: channelName)) • \(nov) • 2 years ago"
                subTitleLabel.text = subtitleText
            }
            
            // measure title text
            if let title = video?.title {
                let size = CGSize(width: frame.width - 16 - 44 - 8 - 16, height: 200)
                let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
                let estimateRect = NSString(string: title).boundingRect(with: size, options: options, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14)], context: nil)
            
                if estimateRect.size.height > 20 {
                    titleLabelHeightConstraint?.constant = 44
                } else {
                    titleLabelHeightConstraint?.constant = 20
                }
            }
        }
    }
    func setupThumnailImage() {
        if let thumbnailImageUrl = video?.thumbnailImageName {
            thumbnailImageView.loadImageFrom(urlString: thumbnailImageUrl)
        }
    }
    func setupProfileImage() {
        if let profileImageUrl = video?.channel?.profileImageName {
            userProfileImageView.loadImageFrom(urlString: profileImageUrl)
        }
    }
    let thumbnailImageView: CustomeImageView = {
        let imageView = CustomeImageView()
        imageView.image = UIImage(named: "blankSpace")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let userProfileImageView: CustomeImageView = {
        let imageView = CustomeImageView()
        imageView.backgroundColor = .green
        imageView.image = UIImage(named: "profile_RD")
        imageView.layer.cornerRadius = 22
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Taylor Swift - Blank Space"
        label.numberOfLines = 2
        return label
    }()
    
    let subTitleLabel: UITextView = {
        let label = UITextView()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "TaylorSwiftVEVO • 2,230,496,347 views • 3 years ago"
        label.textContainerInset = UIEdgeInsets(top: 0, left: -4, bottom: 0, right: 0)
        label.textColor = .lightGray
        return label
    }()
    
    let separateView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var titleLabelHeightConstraint: NSLayoutConstraint?
    override func setupViews() {
        
        addSubview(thumbnailImageView)
        addSubview(separateView)
        addSubview(userProfileImageView)
        addSubview(titleLabel)
        addSubview(subTitleLabel)
        
        // Horizontal constraints
        addConstriantsWith(format: "H:|-16-[v0]-16-|", views: thumbnailImageView)
        addConstriantsWith(format: "H:|-16-[v0(44)]", views: userProfileImageView)
        
        // Vertical constraints
        addConstriantsWith(format: "V:|-16-[v0]-8-[v1(44)]-36-[v2(1)]|", views: thumbnailImageView, userProfileImageView, separateView)
        addConstriantsWith(format: "H:|[v0]|", views: separateView)
        
        // Top constraints
//        addConstriantsWithFormat(format: "H:[v0]-[v1]-16-|", views: userProfileImageView, titleLabel)
//        addConstriantsWithFormat(format: "V:[v0]-[v1(20)]", views: thumbnailImageView, titleLabel)
        titleLabel.leadingAnchor.constraint(equalTo: userProfileImageView.trailingAnchor, constant: 8).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: thumbnailImageView.trailingAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: thumbnailImageView.bottomAnchor, constant: 8).isActive = true
        titleLabelHeightConstraint = titleLabel.heightAnchor.constraint(equalToConstant: 20)
        titleLabelHeightConstraint?.isActive = true
        
        subTitleLabel.leadingAnchor.constraint(equalTo: userProfileImageView.trailingAnchor, constant: 8).isActive = true
        subTitleLabel.trailingAnchor.constraint(equalTo: thumbnailImageView.trailingAnchor).isActive = true
        subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4).isActive = true
        subTitleLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
}
