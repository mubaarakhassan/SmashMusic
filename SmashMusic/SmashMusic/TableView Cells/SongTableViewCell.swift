//
//  SongTableViewCell.swift
//  SmashMusic
//
//  Created by Mubaarak Hassan on 08/11/2017.
//  Copyright © 2017 Mubaarak Hassan. All rights reserved.
//

import UIKit
import MarqueeLabel

class SongTableViewCell: UITableViewCell {

    @IBOutlet weak var songArtwork: UIImageView!
    @IBOutlet weak var songName: MarqueeLabel!
    @IBOutlet weak var albumName: UILabel!
    
    func updateView(song:Song){
        self.songName.text = "\(song.metadata?.artist ?? "") - \(song.metadata?.trackTitle ?? "")"
        self.albumName.text = song.metadata?.albumName
        self.songArtwork.image = song.metadata?.albumArtwork
        self.songArtwork.layer.cornerRadius = 2.0
        self.songArtwork.clipsToBounds = true
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
