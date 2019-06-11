//
//  Song.swift
//  SmashMusic
//
//  Created by Mubaarak Hassan on 02/11/2017.
//  Copyright © 2017 Mubaarak Hassan. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer

class Song {
    var url: URL?
    var metadata: MetaData?
    var item: AVPlayerItem?

    init() {}
    
    init?(path aPath: String, type: String) {
        let song = Song()
        self.url = URL.init(fileURLWithPath: Bundle.main.path(forResource: aPath, ofType: type)!)
        self.item = AVPlayerItem(url: self.url!)
        metadata = MetaData(withAVPlayerItem: self.item)
        song.metadata = MetaData(withAVPlayerItem: item)
    }
    
    
   
}
