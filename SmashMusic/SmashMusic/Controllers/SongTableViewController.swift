//
//  SongTableViewController.swift
//  SmashMusic
//
//  Created by Mubaarak Hassan on 08/11/2017.
//  Copyright © 2017 Mubaarak Hassan. All rights reserved.
//

import UIKit
import CoreData

class SongTableViewController: UITableViewController {

    var playlistDetailVC: PlaylistDetailViewController?
    var listOfSongs = [
        Song(path: "Man's Not Hot", type: "mp3")!,
        Song(path: "Havana (feat. Young Thug)", type: "mp3")!,
        Song(path: "New Rules", type: "mp3")!,
        Song(path: "Mi Gente", type: "mp3")!,
        Song(path: "Friends (feat. Bloodpop)", type: "mp3")!,
        Song(path: "1-800-273-8255 (feat. Alessia Cara & Khalid)", type: "mp3")!,
        Song(path: "Despacito ft. Justin Bieber", type: "mp3")!,
        Song(path: "Thriller", type: "mp3")!,
        Song(path: "Rockstar (feat. 21 Savage)", type: "mp3")!,
        Song(path: "Blinded By Your Grace, Pt. 2 (feat. MNEK)", type: "mp3")!,
        Song(path: "Dusk Till Dawn (feat. Sia)", type: "mp3")!
    ]
    var dictionary: [Int:SongData] = [:]
    
    @IBAction func doneButton(_ sender: UIBarButtonItem) {
        for (_,value) in dictionary{
            self.playlistDetailVC?.currentPlaylist?.addToSongs(value)
            PersistenceService.saveContext()
            self.playlistDetailVC?.listOfSongs.append(value)
            playlistDetailVC?.tableView.reloadData()
        }
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return listOfSongs.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("SongTableViewCell", owner: self, options: nil)?.first as! SongTableViewCell
        // Configure the cell...
        cell.updateView(song: listOfSongs[indexPath.row])
        return cell
    }
  
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let song = self.createSong(indexPath)
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == UITableViewCellAccessoryType.checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.none
                dictionary.removeValue(forKey: indexPath.row)
        }
        else{
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.checkmark
                dictionary.updateValue(song, forKey: indexPath.row)
        }
    }
    
    func createSong(_ indexPath: IndexPath)->SongData{
        let song = SongData(context: PersistenceService.context)
        song.albumname = listOfSongs[indexPath.row].metadata?.albumName
        song.artist = listOfSongs[indexPath.row].metadata?.artist
        song.artwork = UIImagePNGRepresentation((listOfSongs[indexPath.row].metadata?.albumArtwork)!) as NSData?
        song.title = listOfSongs[indexPath.row].metadata?.trackTitle
        song.dateAdded = NSDate()
        return song
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 67
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
 
 

}
