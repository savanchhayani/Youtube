//
//  SubcriptionCell.swift
//  Youtube
//
//  Created by AI Local Admin on 14/12/17.
//  Copyright © 2017 AI Local Admin. All rights reserved.
//

import UIKit

class SubcriptionCell: FeedCell {
    override func fetchVideos() {
        ApiService.sharedInstance.fetchSubsctiptionFeed { (videos) in
            self.videos = videos
            self.collectionView.reloadData()
        }
    }
}
