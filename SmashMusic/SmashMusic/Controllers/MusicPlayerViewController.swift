//
//  FirstViewController.swift
//  SmashMusic
//
//  Created by Mubaarak Hassan on 23/10/2017.
//  Copyright © 2017 Mubaarak Hassan. All rights reserved.
//

import UIKit
import CoreData
import MarqueeLabel
import LNPopupController


class MusicPlayerViewController: UIViewController {
    var timer: Timer?
    
    @IBOutlet weak var albumArtworks: UIImageView!
    @IBOutlet weak var albumLabel: MarqueeLabel!
    @IBOutlet weak var trackLabel: MarqueeLabel!
    @IBOutlet weak var progressTimer: UILabel!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var repeatButton: UIButton!
    @IBOutlet weak var shuffleButton: UIButton!
    @IBOutlet weak var rewindButton: UIButton!
    @IBOutlet weak var fastforwardButton: UIButton!
    @IBOutlet weak var remainingDurationProgressTimer: UILabel!
    @IBOutlet weak var progressSlider: UISlider!
    var nextPopbarBtn = UIBarButtonItem()
    var playPopbarBtn = UIBarButtonItem()
    
    var player: AudioPlayer!
    var notificationCenter: NotificationCenter!
    
    deinit {
        self.notificationCenter.removeObserver(self)
        self.timer?.invalidate()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateView()
        self.configureTimer()
        self.configureNotifications()
    }
    
    func configureNotifications() {
        self.notificationCenter.addObserver(self, selector: #selector(onTrackChanged), name: NSNotification.Name(rawValue: "AudioPlayerOnTrackChangedNotification"), object: nil)
        self.notificationCenter.addObserver(self, selector: #selector(onPlaybackStateChanged), name: NSNotification.Name(rawValue: "AudioPlayerOnPlaybackStateChangedNotification"), object: nil)
    }
    
    func configurePopupitem(){
        //popup setting
        if(player.isPlaying){
            self.player.buttonImage = UIImage(named: "pause-btn")!
        }
        else{
            self.player.buttonImage = UIImage(named: "play-btn")!
        }
        
        playPopbarBtn = UIBarButtonItem(image: self.player.buttonImage, style: .plain, target: self, action: #selector(playButton(_:)))
        nextPopbarBtn = UIBarButtonItem(image: UIImage(named: "fastforward-btn"), style: .plain, target: self, action: #selector(fastforwardButton(_:)))
        
        popupItem.leftBarButtonItems = [ playPopbarBtn ]
        popupItem.rightBarButtonItems = [ nextPopbarBtn ]
    }
    
    func nextButtonPopUp(_ sender:UIBarButtonItem){
        player.togglePlayPause()
    }
    
    func onTrackChanged() {
        if !self.isViewLoaded { return }
        
        if self.player.currentSong == nil {
            self.close()
            return
        }
        
        self.updateView()
    }
    
    func onPlaybackStateChanged() {
        if !self.isViewLoaded { return }
        
        self.updateControls()
    }
    
    func configureTimer() {
        self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateTimer(_:)), userInfo: nil,repeats: true)
    }
    
    func updateTimer(_ timer: Timer){
        if !progressSlider.isTracking {
            progressSlider.value = Float(player.currentTime ?? 0)
        }
        updateTimeLabels()
    }
    
    @IBAction func playButton(_ sender: UIButton) {
        self.player.togglePlayPause()
    }
    @IBAction func rewindButton(_ sender: UIButton) {
        self.player.previousTrack()
    }
    @IBAction func fastforwardButton(_ sender: UIButton) {
        self.player.nextTrack()
    }
    
    @IBAction func repeatButton(_ sender: UIButton) {
        self.player.repeatTrack()
    }
    
    @IBAction func shuffleButton(_ sender: UIButton) {
        self.player.shuffle()
    }
    
    
    @IBAction func changeSliderTimer(_ sender:  AnyObject) {
        self.player.seekTo(Double(progressSlider.value))
    }
    
    func close() {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Update
    
    func updateView() {
        self.updateArtworkImageView()
        self.updateSlider()
        self.updateInfoLabels()
        self.updateTimeLabels()
        self.configurePopupitem()
        self.updateControls()
    }
    
    func updateArtworkImageView() {
        self.albumArtworks.image = self.player.currentSong?.metadata?.albumArtwork
        popupItem.image = self.player.currentSong?.metadata?.albumArtwork
    }
    
    func updateSlider() {
        self.progressSlider.minimumValue = 0
        self.progressSlider.maximumValue = Float(self.player.duration ?? 0)
        self.progressSlider.setThumbImage(UIImage(named: "Knob"), for: UIControlState())
    }
    
    func updateInfoLabels() {
        self.trackLabel.text = "\(self.player.currentSong?.metadata?.artist ?? "") - \(self.player.currentSong?.metadata?.trackTitle ?? "")"
        self.albumLabel.text = "\(self.player.currentSong?.metadata?.albumName ?? "")"
        popupItem.title = self.player.currentSong?.metadata?.trackTitle
        popupItem.subtitle = self.player.currentSong?.metadata?.albumName
    }
    
    func updateTimeLabels() {
        if let currentTime = self.player.currentTime, let duration = self.player.duration {
            self.progressTimer.text = self.humanReadableTimeInterval(currentTime)
            self.remainingDurationProgressTimer.text = "-" + self.humanReadableTimeInterval(duration - currentTime)
        }
        else {
            self.progressTimer.text = ""
            self.remainingDurationProgressTimer.text = ""
        }
    }
    
    func updateControls() {
        self.playButton.isSelected = self.player.isPlaying
        self.repeatButton.isSelected = self.player.repeatState
        self.shuffleButton.isSelected = self.player.shuffleState
        self.fastforwardButton.isEnabled = self.player.nextSong != nil
        self.nextPopbarBtn.isEnabled = self.player.nextSong != nil
        self.rewindButton.isEnabled = self.player.previousSong != nil
    }
    
    //MARK: - Convenience
    
    func humanReadableTimeInterval(_ timeInterval: TimeInterval) -> String {
        let timeInt = Int(round(timeInterval))
        let (hh, mm, ss) = (timeInt / 3600, (timeInt % 3600) / 60, (timeInt % 3600) % 60)
        
        let hhString: String? = hh > 0 ? String(hh) : nil
        let mmString = (hh > 0 && mm < 10 ? "0" : "") + String(mm)
        let ssString = (ss < 10 ? "0" : "") + String(ss)
        
        return (hhString != nil ? (hhString! + ":") : "") + mmString + ":" + ssString
    }

}
/* thanks to https://medium.com/ios-os-x-development/safer-uiviewcontroller-creation-when-using-storyboards-1915ac2b2c80 and https://medium.com/ios-os-x-development/dependency-injection-in-view-controllers-9fd7d2c77e55

 */

protocol ViewControllerFactory {
    func createMusicViewControllerWithDependencies(player: AudioPlayer, notificationCenter: NotificationCenter) -> MusicPlayerViewController
}


class StoryboardViewControllerFactory {
    let storyboard: UIStoryboard
    let context: NSManagedObjectContext
    
    init(storyboard: UIStoryboard, context: NSManagedObjectContext) {
        self.storyboard = storyboard
        self.context = context
    }
}

extension StoryboardViewControllerFactory: ViewControllerFactory {
    func createMusicViewControllerWithDependencies(player: AudioPlayer, notificationCenter: NotificationCenter) -> MusicPlayerViewController {
        let vc = storyboard.instantiateViewController(withIdentifier: "MusicPlayerViewController") as! MusicPlayerViewController
        vc.player = player
        vc.notificationCenter = notificationCenter
        return vc
    }
}


