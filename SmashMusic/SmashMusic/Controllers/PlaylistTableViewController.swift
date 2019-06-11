//
//  PlaylistTableViewController.swift
//  SmashMusic
//
//  Created by Mubaarak Hassan on 03/11/2017.
//  Copyright © 2017 Mubaarak Hassan. All rights reserved.
//

import UIKit
import AVFoundation

class PlaylistTableViewController: UITableViewController {

    var arrayOfPlaylists = [Playlist]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        arrayOfPlaylists = [Playlist(index: 1,title: "Summer tunes", image: #imageLiteral(resourceName: "tropical-1651423_960_720"), description: "Summer beats with a flavor of tropical", songs: []),
                            Playlist(index: 2, title: "Autumn tunes", image: #imageLiteral(resourceName: "download (1)"), description: "", songs: []),
                            Playlist(index: 3, title: "Winter tunes", image: #imageLiteral(resourceName: "fall-1072821_1920_0"), description: "Autum omg 😃 bla bla bla bla bla bla bla bla", songs: [])]
        
        self.tableView.contentInset = UIEdgeInsets(top: 5,left: 0,bottom: 0,right: 0)
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        //tableView.tableFooterView = UIView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return arrayOfPlaylists.count
//    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return arrayOfPlaylists.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        let cell = Bundle.main.loadNibNamed("PlaylistTableViewCell", owner: self, options: nil)?.first as! PlaylistTableViewCell
        // Configure the cell...
        cell.playlistTitle.text = arrayOfPlaylists[indexPath.row].title
        cell.playlistImage.image = arrayOfPlaylists[indexPath.row].image
        cell.playlistImage.layer.cornerRadius = 2.0
        cell.playlistImage.clipsToBounds = true
        cell.playlistDescription.text = arrayOfPlaylists[indexPath.row].description
        
        
        return cell
    }
 
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 58
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
