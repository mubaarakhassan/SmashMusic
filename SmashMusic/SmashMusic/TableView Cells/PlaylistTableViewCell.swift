//
//  PlaylistTableViewCell.swift
//  SmashMusic
//
//  Created by Mubaarak Hassan on 03/11/2017.
//  Copyright © 2017 Mubaarak Hassan. All rights reserved.
//

import UIKit
import CoreData
class PlaylistTableViewCell: UITableViewCell {

    @IBOutlet weak var playlistImage: UIImageView!
    
    @IBOutlet weak var playlistTitle: UILabel!
    
    @IBOutlet weak var playlistDescription: UILabel!
    
    @IBOutlet weak var moreOptionsButton: UIButton!
    
    var playlist: PlaylistData?
    var playlistVC: PlaylistViewController?
    var playlistTableView: UITableView?
    
    func updateView(playlist: PlaylistData, vc: PlaylistViewController, table: UITableView) {
        self.playlist = playlist
        self.playlistVC = vc
        self.playlistTableView = table
        
        self.playlistImage.image = UIImage(data: (playlist.image as! NSData) as Data)
        self.playlistImage.layer.cornerRadius = 2.0
        self.playlistImage.clipsToBounds = true
        self.playlistTitle.text = playlist.name
        self.playlistDescription.text = playlist.descriptions
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.moreOptionsButton.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2)
    }
    
    
    @IBAction func moreOptionButton(_ sender: UIButton) {
        let optionMenu = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .actionSheet)
        
        let deleteAction = UIAlertAction(title: "Delete", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.deleteCell(cell: self)
        })
        let editAction = UIAlertAction(title: "Edit", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
        })
//        let shareAction = UIAlertAction(title: "Share", style: .default, handler: {
//            (alert: UIAlertAction!) -> Void in
//        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
        })
        
        optionMenu.addAction(deleteAction)
        optionMenu.addAction(editAction)
        //optionMenu.addAction(shareAction)
        optionMenu.addAction(cancelAction)
        UIApplication.shared.keyWindow?.rootViewController?.present(optionMenu, animated: true, completion: nil)
    }

    func deleteCell(cell: UITableViewCell) {
        if let deletionIndexPath = playlistTableView?.indexPath(for: cell) {
            let context: NSManagedObjectContext = PersistenceService.context
            context.delete((playlistVC?.arrayOfPlaylists[deletionIndexPath.row])!)
            playlistVC?.arrayOfPlaylists.remove(at: deletionIndexPath.row)
            playlistTableView?.deleteRows(at: [deletionIndexPath], with: .automatic)
            do{
                try context.save()
            }catch let error as NSError{
                print("Could not save. \(error.localizedDescription)")
            }
        }
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
