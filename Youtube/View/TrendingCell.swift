//
//  TrendingCell.swift
//  Youtube
//
//  Created by AI Local Admin on 14/12/17.
//  Copyright © 2017 AI Local Admin. All rights reserved.
//

import UIKit

class TrendingCell: FeedCell {
    override func fetchVideos() {
        ApiService.sharedInstance.fetchTrendingFeed { (videos) in
            self.videos = videos
            self.collectionView.reloadData()
        }
    }
}
