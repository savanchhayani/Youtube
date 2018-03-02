//
//  ApiService.swift
//  Youtube
//
//  Created by AI Local Admin on 14/12/17.
//  Copyright © 2017 AI Local Admin. All rights reserved.
//

import UIKit
class ApiService: NSObject {
    static let sharedInstance = ApiService()
    let baseUrl: String = "https://s3-us-west-2.amazonaws.com/youtubeassets"
    
    func fetchVideos(completion: @escaping ([Video]) -> ()) {
        fetchFeedForUrlString(urlString: "\(baseUrl)/home.json", completion: completion)
    }
    
    func fetchTrendingFeed(completion: @escaping ([Video]) -> ()) {
        fetchFeedForUrlString(urlString: "\(baseUrl)/trending.json", completion: completion)
    }
    
    func fetchSubsctiptionFeed(completion: @escaping ([Video]) -> ()) {
        fetchFeedForUrlString(urlString: "\(baseUrl)/subscriptions.json", completion: completion)
    }
    
    func fetchFeedForUrlString(urlString: String, completion: @escaping ([Video]) -> ()) {
        if let url = URL(string: urlString) {
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                guard error == nil else {
                    print(error!.localizedDescription)
                    return
                }
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                    print(json)
                    var videos = [Video]()
                    for dictionary in json as! [[String: AnyObject]] {
                        let video = Video()
                        video.title = dictionary["title"] as? String
                        video.thumbnailImageName = dictionary["thumbnail_image_name"] as? String
                        
                        let channelDic = dictionary["channel"] as! [String: AnyObject]
                        let channel = Channel(name: (channelDic["name"] as? String)!, profileImageName: (channelDic["profile_image_name"] as? String)!)
                        video.channel = channel
                        videos.append(video)
                    }
                    DispatchQueue.main.async {
                        completion(videos)
                    }
                    
                } catch let jsonError {
                    print(jsonError)
                }
                
                }.resume()
        }
    }
}
