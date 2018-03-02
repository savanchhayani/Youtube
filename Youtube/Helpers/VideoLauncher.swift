//
//  VideoLauncher.swift
//  Youtube
//
//  Created by AI Local Admin on 15/12/17.
//  Copyright © 2017 AI Local Admin. All rights reserved.
//

import UIKit
import AVFoundation

class VideoPlayerView: UIView {
    
    // MARK: - Properties
    let activityIndicatorView: UIActivityIndicatorView = {
       let aiv = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        aiv.translatesAutoresizingMaskIntoConstraints = false
        aiv.startAnimating()
        return aiv
    }()
    let controlsContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 1)
        return view
    }()
    lazy var pauseButton: UIButton = {
       let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "pause")
        button.setImage(image, for: .normal)
        button.tintColor = UIColor.white
        button.isHidden = true
        button.addTarget(self, action: #selector(handlePause), for: .touchUpInside)
        return button
    }()
    let videoLengthLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "00:00"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 13)
        label.textAlignment = .right
        label.isHidden = true
        return label
    }()
    let currentTimeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "00:00"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 13)
        label.isHidden = true
        return label
    }()
    lazy var videoSlider: UISlider = {
        let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.minimumTrackTintColor = UIColor.red
        slider.maximumTrackTintColor = UIColor.white
        slider.setThumbImage(UIImage(named: "thumb"), for: .normal)
        slider.isHidden = true
        slider.addTarget(self, action: #selector(handleSliderChange), for: .valueChanged)
        return slider
    }()
    private let keyPath: String = "currentItem.loadedTimeRanges"
    var player: AVPlayer?
    var isPlaying = false
    
    // MARK: - Life cycles
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupGradientLayer()
        setupVideoPlayer()
        controlsContainerView.frame = frame
        addSubview(controlsContainerView)
        
        controlsContainerView.addSubview(activityIndicatorView)
        addConstraintToCenter(subView: activityIndicatorView, superView: self, height: 0)
        
        controlsContainerView.addSubview(pauseButton)
        addConstraintToCenter(subView: pauseButton, superView: self, height: 50)
        
        controlsContainerView.addSubview(videoLengthLabel)
        addConstriantsWith(format: "H:[v0(50)]-|", views: videoLengthLabel)
        addConstriantsWith(format: "V:[v0(24)]-2-|", views: videoLengthLabel)
        
        controlsContainerView.addSubview(currentTimeLabel)
        addConstriantsWith(format: "H:|-[v0(50)]", views: currentTimeLabel)
        addConstriantsWith(format: "V:[v0(24)]-2-|", views: currentTimeLabel)
        
        controlsContainerView.addSubview(videoSlider)
        videoSlider.rightAnchor.constraint(equalTo: videoLengthLabel.leftAnchor).isActive = true
        videoSlider.leftAnchor.constraint(equalTo: currentTimeLabel.rightAnchor).isActive = true
        videoSlider.bottomAnchor.constraint(equalTo: controlsContainerView.bottomAnchor, constant: -2).isActive = true
        videoSlider.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        backgroundColor = .black
    }
    
    // MARK: - Functions
    private func setupVideoPlayer() {
        
        let urlString = "https://firebasestorage.googleapis.com/v0/b/gameofchats-762ca.appspot.com/o/message_movies%2F12323439-9729-4941-BA07-2BAE970967C7.mov?alt=media&token=3e37a093-3bc8-410f-84d3-38332af9c726"
        if let url = URL(string: urlString) {
            player = AVPlayer(url: url)
            
            let playerLayer = AVPlayerLayer(player: player)
            self.layer.addSublayer(playerLayer)
            playerLayer.frame = self.frame
            player?.addObserver(self, forKeyPath: keyPath, options: .new, context: nil)
            player?.play()
            
            // track player progress
            let interval = CMTime(value: 1, timescale: 2)
            player?.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main, using: { (progressTime) in
                let seconds = CMTimeGetSeconds(progressTime)
                let secondString = String(format: "%02d", Int(seconds) % 60)
                let minuteString = String(format: "%02d", Int(seconds) / 60)
                self.currentTimeLabel.text = "\(minuteString):\(secondString)"
                
                // move the slide
                if let duration = self.player?.currentItem?.duration {
                    let durationSeconds = CMTimeGetSeconds(duration)
                    self.videoSlider.value = Float(seconds / durationSeconds)
                }
            })
        }
    }
    
    @objc func handlePause() {
        if isPlaying {
            player?.pause()
            pauseButton.setImage(UIImage(named: "play"), for: .normal)
        } else {
            player?.play()
            pauseButton.setImage(UIImage(named: "pause"), for: .normal)
        }
        isPlaying = !isPlaying
    }
    @objc func handleSliderChange() {
        if let duration = player?.currentItem?.duration {
            let totalSeconds = CMTimeGetSeconds(duration)
            let value = Float64(videoSlider.value) * totalSeconds
            let seekTime = CMTime(value: CMTimeValue(value), timescale: 1)
            
            player?.seek(to: seekTime, completionHandler: { (completed) in
                
            })
        }
      
    }
    private func setupGradientLayer() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradientLayer.locations = [0.7, 1.2]
        controlsContainerView.layer.addSublayer(gradientLayer)
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        // this is when player is ready and rendering video.
        if keyPath == self.keyPath {
            activityIndicatorView.stopAnimating()
            controlsContainerView.backgroundColor = UIColor.clear
            pauseButton.isHidden = false
            isPlaying = true
            videoLengthLabel.isHidden = false
            videoSlider.isHidden = false
            currentTimeLabel.isHidden = false
            
            if let duration = player?.currentItem?.duration {
                let seconds: Int = Int(CMTimeGetSeconds(duration))
                let secondsText = seconds % 60
                let minuteText = String(format: "%02d", seconds / 60)
                videoLengthLabel.text = "\(minuteText):\(secondsText)"
            }
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
class VideoLauncher: NSObject {
    func showVideoPlayer() {
        if let keyWindow = UIApplication.shared.keyWindow {
            let view = UIView(frame: keyWindow.frame)
            view.backgroundColor = .white
            view.frame = CGRect(x: keyWindow.frame.width - 10, y: keyWindow.frame.height - 10, width: 10, height: 10)
            
            // 16 x 9 is the aspect ratio of all HD videos
            let height = keyWindow.frame.width * 9 / 16
            let frame = CGRect(x: 0, y: 0, width: keyWindow.frame.width, height: height)
            let videoPlayerView = VideoPlayerView(frame: frame)
            view.addSubview(videoPlayerView)
            keyWindow.addSubview(view)
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                view.frame = keyWindow.frame
            }, completion: { (completedAnimation) in
                // do something here after animation completes.
                
                UIApplication.shared.isStatusBarHidden = true // Hide status bar when video player view opens.
            })
        }
    }
}
