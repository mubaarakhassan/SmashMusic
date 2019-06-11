//
//  AudioPlayer.swift
//  SmashMusic
//
//  Created by Mubaarak Hassan on 06/11/2017.
//  Copyright © 2017 Mubaarak Hassan. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer
import CoreData

extension Song: Equatable {}
func ==(lhs: Song, rhs: Song) -> Bool {
    return lhs.url?.absoluteString == rhs.url?.absoluteString
}
class AudioPlayer: NSObject, AVAudioPlayerDelegate {

    var audioPlayer: AVAudioPlayer?
    var listOfSongs: [Song]?
    var beforeShuffle = [Song]()
    var currentSong: Song?
    var buttonImage: UIImage = UIImage(named: "pause-btn")!
    var repeatState: Bool = false
    var shuffleState: Bool = false
    var nextSong: Song? {
        guard let songs = self.listOfSongs, let currentSong = self.currentSong else { return nil }
        
        let nextItemIndex = songs.index(of: currentSong)! + 1
        if nextItemIndex >= songs.count { return songs.first }
        
        return songs[nextItemIndex]
    }
    
    var previousSong: Song? {
        guard let songs = self.listOfSongs, let currentSong = self.currentSong else { return nil }
        
        let previousItemIndex = songs.index(of: currentSong)! - 1
        if previousItemIndex < 0 { return nil }
        
        return songs[previousItemIndex]
    }
    
    var nowPlayingInfo: [String : AnyObject]?
    
    var currentTime: TimeInterval? {
        return self.audioPlayer?.currentTime
    }
    
    var duration: TimeInterval? {
        return self.audioPlayer?.duration
    }
    
    var isPlaying: Bool {
        return self.audioPlayer?.isPlaying ?? false
    }
    
    //MARK: - Dependencies
    
    let audioSession: AVAudioSession
    let commandCenter: MPRemoteCommandCenter
    let nowPlayingInfoCenter: MPNowPlayingInfoCenter
    let notificationCenter: NotificationCenter
    
    typealias LGAudioPlayerDependencies = (audioSession: AVAudioSession, commandCenter: MPRemoteCommandCenter, nowPlayingInfoCenter: MPNowPlayingInfoCenter, notificationCenter: NotificationCenter)
    
    init(dependencies: LGAudioPlayerDependencies) {
        self.audioSession = dependencies.audioSession
        self.commandCenter = dependencies.commandCenter
        self.nowPlayingInfoCenter = dependencies.nowPlayingInfoCenter
        self.notificationCenter = dependencies.notificationCenter
        
        super.init()
        
        try! self.audioSession.setCategory(AVAudioSessionCategoryPlayback)
        try! self.audioSession.setActive(true)
        
        
        self.configureCommandCenter()
    }
    
    //MARK: - Playback Commands
    func playSongs(_ songs: [Song], firstItem: Song? = nil) {
        self.listOfSongs = songs
        
        if songs.count == 0 {
            self.endPlayback()
            return
        }
        
        let selectedSong = firstItem ?? self.listOfSongs!.first!
        
        self.playSong(selectedSong)
    }
    
    func playSong(_ selectedSong: Song) {
        guard let audioPlayer = try? AVAudioPlayer(contentsOf: selectedSong.url!) else {
            self.endPlayback()
            return
        }
        
        audioPlayer.delegate = self
        audioPlayer.prepareToPlay()
        audioPlayer.play()
        
        self.audioPlayer = audioPlayer
        
        self.currentSong = selectedSong
        
        self.updateNowPlayingInfoForCurrentSong()
        self.updateCommandCenter()
        
        self.notifyOnTrackChanged()
    }
    
    func togglePlayPause() {
        if self.isPlaying {
            self.pause()
        }
        else {
            self.play()
        }
        self.notifyOnTrackChanged()
    }
    
    func play() {
        self.audioPlayer?.play()
        self.updateNowPlayingInfoElapsedTime()
        self.notifyOnPlaybackStateChanged()
        buttonImage = UIImage(named: "pause-btn")!
    }
    
    func pause() {
        self.audioPlayer?.pause()
        self.updateNowPlayingInfoElapsedTime()
        self.notifyOnPlaybackStateChanged()
        buttonImage = UIImage(named: "play-btn")!
    }
    
    func nextTrack() {
        guard let nextSong = self.nextSong else { return }
        self.playSong(nextSong)
        self.updateCommandCenter()
    }
    
    func previousTrack() {
        guard let previousSong = self.previousSong else { return }
        self.playSong(previousSong)
        self.updateCommandCenter()
    }
    
    func shuffle(){
        if(!shuffleState){
            self.beforeShuffle = listOfSongs!
            self.listOfSongs?.shuffle()
            
            for element in listOfSongs!{
                print("selected shuffle: \(element.metadata?.trackTitle)")
            }
            
        } else {
            self.listOfSongs = beforeShuffle
            for element in listOfSongs!{
                print("unselected shuffle: \(element.metadata?.trackTitle)")
            }
        }
        self.shuffleState = !self.shuffleState
        self.notifyOnTrackChanged()
    }
    
    func repeatTrack(){
        if(!self.repeatState){
            self.audioPlayer?.numberOfLoops = -1
        }
        else{
            self.audioPlayer?.numberOfLoops = 0
        }
        self.repeatState = !repeatState
        self.notifyOnTrackChanged()
    }
    
    func seekTo(_ timeInterval: TimeInterval) {
        self.audioPlayer?.currentTime = timeInterval
        self.updateNowPlayingInfoElapsedTime()
    }
    
    //MARK: - Command Center
    
    func updateCommandCenter() {
        guard let listOfSongs = self.listOfSongs, let currentSong = self.currentSong else { return }
        
        self.commandCenter.previousTrackCommand.isEnabled = currentSong != listOfSongs.first!
        self.commandCenter.nextTrackCommand.isEnabled = currentSong != listOfSongs.last!
    }
    
    func configureCommandCenter() {
        self.commandCenter.playCommand.addTarget (handler: { [weak self] event -> MPRemoteCommandHandlerStatus in
            guard let this = self else { return .commandFailed }
            this.play()
            return .success
        })
        
        self.commandCenter.pauseCommand.addTarget (handler: { [weak self] event -> MPRemoteCommandHandlerStatus in
            guard let this = self else { return .commandFailed }
            this.pause()
            return .success
        })
        
        self.commandCenter.nextTrackCommand.addTarget (handler: { [weak self] event -> MPRemoteCommandHandlerStatus in
            guard let this = self else { return .commandFailed }
            this.nextTrack()
            return .success
        })
        
        self.commandCenter.previousTrackCommand.addTarget (handler: { [weak self] event -> MPRemoteCommandHandlerStatus in
            guard let this = self else { return .commandFailed }
            this.previousTrack()
            return .success
        })
        
    }
    
    //MARK: - Now Playing Info
    
    func updateNowPlayingInfoForCurrentSong() {
        guard let audioPlayer = self.audioPlayer, let currentSong = self.currentSong else {
            self.configureNowPlayingInfo(nil)
            return
        }
        
        var nowPlayingInfo = [MPMediaItemPropertyTitle: currentSong.metadata?.trackTitle as Any,
                              MPMediaItemPropertyAlbumTitle: currentSong.metadata?.albumName as Any,
                              MPMediaItemPropertyArtist: currentSong.metadata?.artist as Any,
                              MPMediaItemPropertyPlaybackDuration: audioPlayer.duration,
                              MPNowPlayingInfoPropertyPlaybackRate: NSNumber(value: 1.0 as Float)] as [String : Any]
        
        if let image = currentSong.metadata?.albumArtwork {
            nowPlayingInfo[MPMediaItemPropertyArtwork] = MPMediaItemArtwork(image: image)
        }
        
        self.configureNowPlayingInfo(nowPlayingInfo as [String : AnyObject]?)
        
        self.updateNowPlayingInfoElapsedTime()
    }
    
    func updateNowPlayingInfoElapsedTime() {
        guard var nowPlayingInfo = self.nowPlayingInfo, let audioPlayer = self.audioPlayer else { return }
        
        nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = NSNumber(value: audioPlayer.currentTime as Double);
        
        self.configureNowPlayingInfo(nowPlayingInfo)
    }
    
    func configureNowPlayingInfo(_ nowPlayingInfo: [String: AnyObject]?) {
        self.nowPlayingInfoCenter.nowPlayingInfo = nowPlayingInfo
        self.nowPlayingInfo = nowPlayingInfo
    }
    
    //MARK: - AVAudioPlayerDelegate
    
     func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if self.nextSong == nil {
            self.endPlayback()
        }
        else {
            self.nextTrack()
        }
    }
    
    func endPlayback() {
        self.currentSong = nil
        self.audioPlayer = nil
        
        self.updateNowPlayingInfoForCurrentSong()
        self.notifyOnTrackChanged()
    }
    
    func audioPlayerBeginInterruption(_ player: AVAudioPlayer) {
        self.notifyOnPlaybackStateChanged()
    }
    
    func audioPlayerEndInterruption(_ player: AVAudioPlayer, withOptions flags: Int) {
        if AVAudioSessionInterruptionOptions(rawValue: UInt(flags)) == .shouldResume {
            self.play()
        }
    }
    
    func notifyOnPlaybackStateChanged() {
        self.notificationCenter.post(name: Notification.Name(rawValue: "AudioPlayerOnPlaybackStateChangedNotification"), object: self)
    }
    
    func notifyOnTrackChanged() {
        self.notificationCenter.post(name: Notification.Name(rawValue: "AudioPlayerOnTrackChangedNotification"), object: self)
    }
}

public func random(_ n: Int) -> Int {
    return Int(arc4random_uniform(UInt32(n)))
}

extension Array {
    /*
     Randomly shuffles the array in-place
     This is the Fisher-Yates algorithm, also known as the Knuth shuffle.
     Time complexity: O(n)
     credit to: https://github.com/raywenderlich/swift-algorithm-club/blob/master/Shuffle/Shuffle.playground/Sources/Shuffle.swift
     */
    public mutating func shuffle() {
        for i in (1...count-1).reversed() {
            let j = random(i + 1)
            if i != j {
                let t = self[i]
                self[i] = self[j]
                self[j] = t
            }
        }
    }
}
