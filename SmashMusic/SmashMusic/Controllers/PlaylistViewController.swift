//
//  PlaylistViewController.swift
//  SmashMusic
//
//  Created by Mubaarak Hassan on 03/11/2017.
//  Copyright © 2017 Mubaarak Hassan. All rights reserved.
//

import UIKit
import CoreData

class PlaylistViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var tableView: UITableView!
    var arrayOfPlaylists = [PlaylistData]()
    
    var selectedImage:UIImage?
    var selectedTitle:String?
    var selectedDescription:String?
    var index:Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fetchRequest: NSFetchRequest<PlaylistData> = PlaylistData.fetchRequest()
        do{
            let playlists = try PersistenceService.context.fetch(fetchRequest)
            self.arrayOfPlaylists = playlists
            tableView.reloadData()
        }catch{
            
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let fetchRequest: NSFetchRequest<PlaylistData> = PlaylistData.fetchRequest()
        do{
            let playlists = try PersistenceService.context.fetch(fetchRequest)
            self.arrayOfPlaylists = playlists
            tableView.reloadData()
        }catch{
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfPlaylists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("PlaylistTableViewCell", owner: self, options: nil)?.first as! PlaylistTableViewCell

        let playlist = self.arrayOfPlaylists[indexPath.row]
        cell.updateView(playlist: playlist, vc: self, table: tableView)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 67
    }

    // MARK: - Navigation showPlaylistDetail
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //let indexPath = tableView.indexPathForSelectedRow //optional, to get from any UIButton for example
        //let currentCell = tableView.cellForRow(at: indexPath!) as! PlaylistTableViewCell
      
        self.selectedImage = UIImage(data: (self.arrayOfPlaylists[indexPath.row].image as! NSData) as Data)
        self.selectedTitle = self.arrayOfPlaylists[indexPath.row].name
        self.selectedDescription = self.arrayOfPlaylists[indexPath.row].descriptions
        self.index = indexPath.row
        performSegue(withIdentifier: "showPlaylistDetail", sender: self)
    }
     

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
     
        if segue.identifier == "showPlaylistDetail" {
            if let playlistDetailVC = (segue.destination as? PlaylistDetailViewController){
                playlistDetailVC.playlistTitle = self.selectedTitle
                playlistDetailVC.playlistImage = self.selectedImage
                playlistDetailVC.playlistDescription = self.selectedDescription
                playlistDetailVC.currentPlaylist = self.arrayOfPlaylists[self.index!]
                playlistDetailVC.playlistVC = self
             
            }
            

        }
        
        if segue.identifier == "createPlaylist" {
            if let newPlaylistVC = (segue.destination as? CreatePlaylistViewController) {
                newPlaylistVC.playlistVC = self
            }
        }
    }
 
    
    

}
