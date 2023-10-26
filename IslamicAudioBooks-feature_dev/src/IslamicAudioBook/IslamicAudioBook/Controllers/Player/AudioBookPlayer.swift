//
//  AudioBookPlayer.swift
//  IslamicAudioBook
//
//  Created by Ameer Shaikh on 17/08/2020.
//  Copyright © 2020 Ameer. All rights reserved.
//

import UIKit
import AVFoundation
import SDWebImage
import RappleProgressHUD
import MediaPlayer


protocol AudioPlayerCommands {
    func nextTrackCommand()
    func previousTrackCommand()
    func playTrackCommand()
    func pauseTrackCommand()
    func seekPlayerToPosition(_ value: Float )
    func toggleLoopTrackCommand()
    func toggleLoopAllTracksCommand()
}

extension AudioBookPlayer : AudioPlayerCommands {
    
    func seekPlayerToPosition(_ sliderValue: Float ) {

        if let duration = audioPlayer?.currentItem?.duration {
            let totalSecond = CMTimeGetSeconds(duration)
            
            let value = Float64(sliderValue) * totalSecond
            
            if(value != Double.nan){
                let seekTime = CMTime(value: Int64(value), timescale: 1)
                audioPlayer?.seek(to: seekTime, completionHandler: { (completedSeek) in
                    // later
                })
            }
        }
    }
    
    func nextTrackCommand() {
        if position < (mediaArray!.count - 1) {
            position = position + 1
            delegate?.initialiseAudioPlayer()
        }
    }
    
    func previousTrackCommand() {
        if position > 0 {
            position = position - 1
            delegate?.initialiseAudioPlayer()
        }
    }
    
    func playTrackCommand()  {
        audioPlayer?.play()
        delegate?.updatePlayePauseButton(isPlaying: true)
    }
    
    func pauseTrackCommand() {
        audioPlayer?.pause()
        delegate?.updatePlayePauseButton(isPlaying: false)
    }
    
    func toggleLoopTrackCommand() {
        
    }
    
    func toggleLoopAllTracksCommand() {
        
    }
}

class AudioBookPlayer: NSObject {
    
    var audioPlayer : AVPlayer?
    var observer : Any?
    
    var position: Int = 0
    var mediaArray: Audios?
    
    var selectedMedia : Audio?
    
    var delegate:AudioPlayerProtocol?
    
    init(audioDataSource: Audios, selectedPosition: Int) {
        
        super.init()
        self.mediaArray = audioDataSource
        self.position = selectedPosition
        
        setupObservers()
    }
    
    
// MARK: - Observer
    private func setupObservers() {
        NotificationCenter.default.addObserver(self,
                                                      selector: #selector(playerItemDidReachEnd),
                                                                name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
                                                                object: nil)
    }
    
    private func removeObservers() {
        
        if let observer = self.observer {
            audioPlayer?.removeTimeObserver(observer)
            self.observer = nil
        }
        
        audioPlayer?.pause()
        
        NotificationCenter.default.removeObserver(self)

    }
    
    @objc func playerItemDidReachEnd() {
        nextTrackCommand()
    }
    
    func closePlayer() {
        if let player = audioPlayer {
                   player.pause()
                   player.replaceCurrentItem(with: nil)
               }
        
        audioPlayer = nil
        removeObservers()
    }
    
    func startPlayer() {
        
        let media = mediaArray![position]
        let urlString = media.url

        // Check for local audio path
        var url: URL? = FileManager.localAudioPath(audio: urlString)
        if (url == nil) {
            // Stream from server
            url = URL(string: urlString)
        }
            
        if let observer = self.observer {
                           audioPlayer?.removeTimeObserver(observer)
                           self.observer = nil
                    }
        do{
            try AVAudioSession.sharedInstance().setCategory(.playback)
//            try AVAudioSession.sharedInstance().setCategory(.playback, options: [.mixWithOthers]) //.mixWithOthers
            try AVAudioSession.sharedInstance().setActive(true)
            
            audioPlayer = try AVPlayer(url: url!)
            
            guard let player = audioPlayer else { return }
            playTrackCommand()
            setupNowPlaying()
            setupRemoteCommandHandler()
            
            self.observer = player.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(1/30.0, preferredTimescale: Int32(NSEC_PER_SEC)), queue: nil) { time in
                
                if(player.currentItem != nil) {
                    self.delegate?.updatePlayerTime(time: time, playerItem: player.currentItem!)
                }
            }
         } catch let error {
               AppLogger.log(error.localizedDescription)
        }
    }
    
    // MARK: - Mini Player Mode
    func mapAudioPlayerWithMiniPlayerUI() {
        let media = mediaArray![position]
        let _titlePosition = "\(position+1)/\(mediaArray!.count) "
        
        delegate?.initializePlayerUI(media: media, titlePosition: _titlePosition)
        updatePrevNextButtons()
    }
    
    func updatePrevNextButtons() {
        var prevEnabled = true
        var nextEnabled = true
        
        if (position == 0) {
            prevEnabled = false
        }
        if (position == (mediaArray!.count - 1)) {
            nextEnabled = false
        }
        delegate?.enablePrevNextButton(prev: prevEnabled, next: nextEnabled)
    }
    
    // MARK: - Handling Commands in Background Mode
    func setupNowPlaying() {
        let media = mediaArray![position]
        
        let bkChTitle = media.bookname + " / " + media.chapter
        
        let _titlePosition = "\(position+1)/\(mediaArray!.count) "
        let audioTitle = _titlePosition + media.audioname
        
        delegate?.initializePlayerUI(media: media, titlePosition: _titlePosition)
            updatePrevNextButtons()
            // Define Now Playing Info
            var nowPlayingInfo = [String : Any]()
        nowPlayingInfo[MPMediaItemPropertyTitle] = audioTitle
        nowPlayingInfo[MPMediaItemPropertyAlbumTitle] = bkChTitle
            
            if let duration = audioPlayer?.currentItem?.duration {
            let totalSecond = CMTimeGetSeconds(duration)
            nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = totalSecond

            let completedDuration = CMTimeGetSeconds((audioPlayer?.currentItem?.currentTime())!)
            nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = completedDuration
                
    //        nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = audioPlayer?.rate

            // Set the metadata
            MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
//                if #available(iOS 13.0, *) {
//                    MPNowPlayingInfoCenter.default().playbackState = .playing
//                } else {
//                    // Fallback on earlier versions
//                }
            }
        }
        
    func setupRemoteCommandHandler() {
        let commandCenter = MPRemoteCommandCenter.shared()
        
        // Play Command
        commandCenter.playCommand.isEnabled = true
        commandCenter.playCommand.addTarget {event in
            self.audioPlayer?.play()
            return .success
        }
        
        // Pause Command
        commandCenter.pauseCommand.isEnabled = true
        commandCenter.pauseCommand.addTarget {event in
            self.audioPlayer?.pause()
            return .success
        }
        
        // Next Command
        commandCenter.nextTrackCommand.isEnabled = true
        commandCenter.nextTrackCommand.addTarget {event in
            self.nextTrackCommand()
            return .success
        }
        
        // Prev Command
        commandCenter.previousTrackCommand.isEnabled = true
        commandCenter.previousTrackCommand.addTarget {event in
            self.previousTrackCommand()
            return .success
        }
    }
}
