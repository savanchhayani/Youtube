//
//  SettingsLauncher.swift
//  Youtube
//
//  Created by AI Local Admin on 13/12/17.
//  Copyright © 2017 AI Local Admin. All rights reserved.
//

import UIKit

class Setting: NSObject {
    var name: SettingName
    var imageName: String
    
    init(name: SettingName, imageName: String) {
        self.name = name
        self.imageName = imageName
    }
}
enum SettingName: String {
    case cancel = "Cancel"
    case settings = "Settings"
    case termsPrivacy = "Terms & Privacy Policy"
    case feedback = "Send Feedback"
    case help = "Help"
    case switchAccount = "Switch Account"
    
}
class SettingsLauncher: NSObject {
    // MARK: - Properties
    let blackView = UIView()
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor.white
        return cv
    }()
    let cellId = "cellId"
    let cellHeight: CGFloat = 50
    var homeController: HomeController?
    var settings: [Setting] = {
        let setting = Setting(name: .settings, imageName: "settings")
        let termsAndPrivacy = Setting(name: .termsPrivacy, imageName: "privacy")
        let feedback = Setting(name: .feedback, imageName: "feedback")
        let help = Setting(name: .help, imageName: "help")
        let switchAccount = Setting(name: .switchAccount, imageName: "switch_account")
        let cancel = Setting(name: .cancel, imageName: "cancel")
        return [setting, termsAndPrivacy, feedback, help, switchAccount, cancel]
    }()
    
    // MARK: - functions
    func showSettigns() {
        // show menu
        if let window = UIApplication.shared.keyWindow {
            blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
            
            window.addSubview(blackView)
            window.addSubview(collectionView)
            
            let height: CGFloat = CGFloat(settings.count) * cellHeight
            let y = window.frame.height - height
            collectionView.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: height)
            
            blackView.frame = window.frame
            blackView.alpha = 0
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.blackView.alpha = 1
                self.collectionView.frame = CGRect(x: 0, y: y, width: self.collectionView.frame.width, height: self.collectionView.frame.height)
            }, completion: nil)
        }
    }
    
    @objc func handleDismiss(_ setting: Setting) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.blackView.alpha = 0
            if let window = UIApplication.shared.keyWindow {
                self.collectionView.frame = CGRect(x: 0, y: window.frame.height, width: self.collectionView.frame.width, height: self.collectionView.frame.height)
            }
            
        }) { (completed) in
            if setting.name != .cancel {
                self.homeController?.showControllerForSettings(setting: setting)
            }
        }
    }
    // MARK: - Life cycles
    override init() {
        super.init()
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.register(SettingCell.self, forCellWithReuseIdentifier: cellId)
    }
}

extension SettingsLauncher: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: cellHeight)
    }
}

extension SettingsLauncher: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0 
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let setting = self.settings[indexPath.row]
        handleDismiss(setting)
    }
}

extension SettingsLauncher: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return settings.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! SettingCell
        let setting = settings[indexPath.row]
        cell.setting = setting
        return cell
    }
}








