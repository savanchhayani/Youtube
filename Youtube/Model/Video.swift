//
//  Video.swift
//  Youtube
//
//  Created by AI Local Admin on 12/12/17.
//  Copyright © 2017 AI Local Admin. All rights reserved.
//

import UIKit
class Video: NSObject {
    var thumbnailImageName: String?
    var title: String?
    var channel: Channel?
    var numberOfViews: Int?
    var date: NSDate?
}

class  Channel: NSObject {
    var name: String?
    var profileImageName: String?
    
    init(name: String, profileImageName: String) {
        self.name = name
        self.profileImageName = profileImageName
    }
}
