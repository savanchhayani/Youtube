//
//  Extensions.swift
//  Youtube
//
//  Created by AI Local Admin on 11/12/17.
//  Copyright © 2017 AI Local Admin. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
}

extension UIView {
    func createDictionary(_ views: [UIView]) -> [String : UIView] {
        var viewsDictionary = [String: UIView]()
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            viewsDictionary[key] = view
//            view.translatesAutoresizingMaskIntoConstraints = false
        }
        return viewsDictionary
    }
    func addConstriantsWith(format: String, views: UIView...) {
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: [], metrics: nil, views: createDictionary(views)))
    }
//    func addConstriantsWith(format: String, options: NSLayoutFormatOptions, views: UIView...) {
//        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: options, metrics: nil, views: createDictionary(views)))
//    }
    func addConstraintToCenter(subView: UIView, superView: UIView, height: CGFloat) {
        subView.centerXAnchor.constraint(equalTo: superView.centerXAnchor).isActive = true
        subView.centerYAnchor.constraint(equalTo: superView.centerYAnchor).isActive = true
        
        if height != 0 {
            subView.widthAnchor.constraint(equalToConstant: height).isActive = true
            subView.heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
}
class CustomeImageView: UIImageView {
    let imageCache = NSCache<NSString, UIImage>()
    var imageUrlString: String?
    
    func loadImageFrom(urlString: String) {
        imageUrlString = urlString
        let url = URL(string: urlString)
        self.image = nil
        
        if let imageCache = imageCache.object(forKey: urlString as NSString) {
            self.image = imageCache
            return
        }
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, respnse, error) in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            DispatchQueue.main.async {
                let imageToCache = UIImage(data: data!)
                if self.imageUrlString == urlString {
                    self.image = imageToCache
                }
                self.imageCache.setObject(imageToCache!, forKey: urlString as NSString)
            }
            
        }).resume()
    }
}
