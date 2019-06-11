//
//  PlaylistSongTableViewCell.swift
//  SmashMusic
//
//  Created by Mubaarak Hassan on 04/11/2017.
//  Copyright © 2017 Mubaarak Hassan. All rights reserved.
//

import UIKit

class PlaylistSongTableViewCell: UITableViewCell {

    @IBOutlet weak var songName: UILabel!
    @IBOutlet weak var artistName: UILabel!
    @IBOutlet weak var songArtwork: UIImageView!
    @IBOutlet weak var songDate: UILabel!
    
    func updateView(song:SongData){
        self.songName.text = song.title
        self.artistName.text = song.artist
        
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, h:mm a"
        
        self.songDate.text = "Date added : \(formatter.string(from: song.dateAdded! as Date))"
        
        self.songArtwork.image = UIImage(data: (song.artwork as! NSData) as Data)
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
    
    @IBAction func deleteSong(_ sender: UIButton) {
    }
    
    
}
extension Date
{
    func toString( dateFormat format  : String ) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
}
