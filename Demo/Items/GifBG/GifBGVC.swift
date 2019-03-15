//
//  GifBGVC.swift
//  Demo
//
//  Created by 王波 on 2018/7/18.
//  Copyright © 2018年 wangbo. All rights reserved.
//

import UIKit
import AVFoundation

class GifBGVC: BaseVC {
    fileprivate var player:AVPlayer?
    override func viewDidLoad() {
        super.viewDidLoad()
        if let p = Bundle.main.path(forResource: "lol", ofType: "mov"){
            let url = URL.init(fileURLWithPath: p)
            let player = AVPlayer.init(url: url)
            let playerLayer = AVPlayerLayer(player: player)
            playerLayer.frame = view.bounds
            playerLayer.videoGravity = AVLayerVideoGravity.resize
            view.layer.addSublayer(playerLayer)
            player.play()
            self.player = player
        }
        NotificationCenter.default.addObserver(self, selector: #selector(playEnd), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
        
    }

    @objc func playEnd()  {
        player?.seek(to: CMTimeMake(value: 0, timescale: 1))
        player?.play()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
