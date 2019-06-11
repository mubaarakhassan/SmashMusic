//
//  MetaData.swift
//  SmashMusic
//
//  Created by Mubaarak Hassan on 02/11/2017.
//  Copyright © 2017 Mubaarak Hassan. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer

class MetaData {
    var trackTitle: String? = "Unknown"
    var creationDate = Date()
    var albumArtwork: UIImage? = UIImage(named: "default_cover")
    var albumName: String? = "Unknown"
    var artist: String? = "Unknown"
    var duration: Float64!
    
    init?(withAVPlayerItem item: AVPlayerItem?) {
        
        guard let playerItem = item else { return }
        let commonMetadata = playerItem.asset.commonMetadata
        duration = CMTimeGetSeconds(playerItem.asset.duration)
        
        for metadataItem in commonMetadata {
            switch metadataItem.commonKey ?? "" {
            case "title":
                trackTitle = metadataItem.stringValue
            case "creationDate":
                break
            case "artwork":
                if let imageData = metadataItem.value as? Data {
                    albumArtwork = UIImage(data: imageData)
                }
            case "albumName":
                albumName = metadataItem.stringValue
            case "artist":
                artist = metadataItem.stringValue
            default: break
            }
        }
    }
    
    init?(withMPMediaItem item: MPMediaItem?) {
        guard let playerItem = item else { return }
        trackTitle = playerItem.title
        albumArtwork = playerItem.artwork?.image(at: CGSize(width: 100, height: 100))
        albumName = playerItem.albumTitle
        artist = playerItem.artist
        duration = playerItem.playbackDuration
    }
}
