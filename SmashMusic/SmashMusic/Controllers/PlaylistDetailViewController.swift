//
//  PlaylistDetailViewController.swift
//  SmashMusic
//
//  Created by Mubaarak Hassan on 04/11/2017.
//  Copyright © 2017 Mubaarak Hassan. All rights reserved.
//

import UIKit
import CoreData


class PlaylistDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var currentPlaylist: PlaylistData?
    var listOfSongs = [SongData]()
    var playlistVC : PlaylistViewController!

    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imageView: UIImageView?
    @IBOutlet weak var titleLabel: UILabel?
    @IBOutlet weak var descriptionLabel: UILabel?
    
    
    var playlistTitle:String?
    var playlistDescription:String?
    var playlistImage: UIImage?
    
    var player: AudioPlayer?
    var notificationCenter: NotificationCenter?
    
    
    required init?(coder aDecoder: NSCoder) {
        
        listOfSongs = []
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        self.player = appDelegate.player
        self.notificationCenter = NotificationCenter.default
        
        super.init(coder:aDecoder)
    }
    
    deinit {
        self.notificationCenter?.removeObserver(self)
    }
    
    func onTrackAndPlaybackStateChange() {
        //self.updatePlayerButton(animated: true)
        //self.tableView.reloadData()
    }
    
    
    //MARK: - Notifications
    
    func configureNotifications() {
        self.notificationCenter?.addObserver(self, selector: #selector(onTrackAndPlaybackStateChange), name: NSNotification.Name(rawValue: "AudioPlayerOnTrackChangedNotification"), object: nil)
        self.notificationCenter?.addObserver(self, selector: #selector(onTrackAndPlaybackStateChange), name: NSNotification.Name(rawValue: "AudioPlayerOnPlaybackStateChangedNotification"), object: nil)
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()

        let fetchRequest: NSFetchRequest<SongData> = SongData.fetchRequest()
        do{
            let playlists = try PersistenceService.context.fetch(fetchRequest)
            let test = playlists
            tableView.reloadData()
        }catch{
            
        }
        
        titleLabel?.text = playlistTitle
        imageView?.image = playlistImage
        imageView?.layer.cornerRadius = 2.0
        imageView?.clipsToBounds = true
        descriptionLabel?.text = playlistDescription
        listOfSongs = currentPlaylist?.songs.allObjects as! [SongData]
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listOfSongs.count
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("PlaylistSongTableViewCell", owner: self, options: nil)?.first as! PlaylistSongTableViewCell
        // Configure the cell...
        cell.updateView(song: listOfSongs[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete
        {
            let cell = tableView.cellForRow(at: indexPath)
            deleteCell(cell: cell!)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 67
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var convertedSongList = convertTypeSong(songDataList: self.listOfSongs)
        self.player?.playSongs(convertedSongList, firstItem: convertedSongList[indexPath.row])
        
        
        //luister historie
        let history = HistoryData(context: PersistenceService.context)
        history.playlist = titleLabel?.text
        history.song = player?.currentSong?.metadata?.trackTitle
        PersistenceService.saveContext()
        
        
        let factory: ViewControllerFactory = StoryboardViewControllerFactory(
            storyboard: UIStoryboard(name: "Main", bundle: Bundle.main),
            context: NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        )
        let vc = factory.createMusicViewControllerWithDependencies(player: self.player!, notificationCenter: self.notificationCenter!)
        
        tabBarController?.popupBar.tintColor = UIColor(white: 38.0 / 255.0, alpha: 1.0)
        tabBarController?.presentPopupBar(withContentViewController: vc, animated: true, completion: nil)

        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func convertTypeSong(songDataList: [SongData]) -> [Song]{
        var songList = [Song]()
        for songData in songDataList{
            songList.append(Song(path: songData.title!, type: "mp3")!)
        }
        return songList
    }
    
    func deleteCell(cell: UITableViewCell) {
        if let deletionIndexPath = tableView?.indexPath(for: cell) {
            let context: NSManagedObjectContext = PersistenceService.context
            context.delete(listOfSongs[deletionIndexPath.row])
            self.currentPlaylist?.removeFromSongs(listOfSongs[deletionIndexPath.row])
            listOfSongs.remove(at: deletionIndexPath.row)
            tableView.deleteRows(at: [deletionIndexPath], with: .automatic)
            do{
                try context.save()
            }catch let error as NSError{
                print("Could not save. \(error.localizedDescription)")
            }
        }
    }
    
  
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "showListOfSongs" {
            if let newPlaylistVC = (segue.destination as? SongTableViewController) {
                newPlaylistVC.playlistDetailVC = self
            }
        }
    }

}
