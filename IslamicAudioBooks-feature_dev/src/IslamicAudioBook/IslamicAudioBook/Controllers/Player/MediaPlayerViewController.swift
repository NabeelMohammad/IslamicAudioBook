//
//  MediaPlayerViewController.swift
//  IslamicAudioBook
//
//  Created by Ameer Shaikh on 08/08/2020.
//  Copyright © 2020 Ameer. All rights reserved.
//

import UIKit
import AVFoundation
import SDWebImage
import RappleProgressHUD
import MediaPlayer

protocol AudioPlayerProtocol {
    func updatePlayerTime(time: CMTime, playerItem: AVPlayerItem)

    func updatePlayePauseButton(isPlaying:Bool)
    
    func enablePrevNextButton(prev:Bool, next:Bool)
    
    func initializePlayerUI(media:Audio, titlePosition:String)
    
    func initialiseAudioPlayer()
}

extension MediaPlayerViewController : AudioPlayerProtocol {
    // MARK :- AudioPlayerProtocol
    func initializePlayerUI(media:Audio, titlePosition:String) {
        // Save to history
        AudioRealm.updateHistory(media, shouldReset: false)
        
        self.playingAudio = media
        
        if(!self.isKind(of: MiniPlayerViewController.self)) {
            let dbAudio = AudioRealm.audioFromURL(media.url)
            if(favoriteButton != nil) {
                if(dbAudio == nil) {
                    favoriteButton.isSelected = false
                }
                else {
                    favoriteButton.isSelected = dbAudio?.favorite ?? false
                }
            }
        }
        
        self.trackProgressView.value = 0
        self.tractCompletedTime.text = "--:--"
        self.tractDuration.text = "--:--"
        
        let imageURL = URL(string: media.logoMin)
        self.previewImage.sd_imageIndicator?.startAnimatingIndicator()
        self.previewImage.sd_imageIndicator = SDWebImageActivityIndicator.gray
        self.previewImage.sd_setImage(with: imageURL)
        
        self.bookChapterTitle.text = media.bookname + " / " + media.chapter
        self.mediaTitle.text = titlePosition + media.audioname
    }
    
    func enablePrevNextButton(prev:Bool, next:Bool) {
        prevButton.isEnabled = prev
        nextButton.isEnabled = next
    }
    
    func updatePlayerTime(time: CMTime, playerItem: AVPlayerItem) {
         if(time.value == 0) {
             RappleActivityIndicatorView.stopAnimation()
             self.activityIndicator.stopAnimating()
         }
         
        let duration = CMTimeGetSeconds(playerItem.duration)
         
         if  !duration.isNaN  {
             self.tractDuration.text = "\(Int(duration/60)):\(Int(duration.truncatingRemainder(dividingBy: 60)))"
             self.trackProgressView.value = Float((CMTimeGetSeconds(time) / duration))

                             
             let completedDuration = CMTimeGetSeconds((playerItem.currentTime()))
             self.tractCompletedTime.text = "\(Int(completedDuration/60)):\(Int(completedDuration.truncatingRemainder(dividingBy: 60)))"
        }
    }
    
    func updatePlayePauseButton(isPlaying:Bool) {
        if(isPlaying) {
            playPuseButton.isSelected = false
            if #available(iOS 13.0, *) {
                playPuseButton.setBackgroundImage(UIImage(systemName: "pause.fill"), for: .normal)
            } else {
                // Fallback on earlier versions
                playPuseButton.setBackgroundImage(UIImage(named: "player_pause"), for: .normal)
            }
        } else {
            playPuseButton.isSelected = true
            if #available(iOS 13.0, *) {
                playPuseButton.setBackgroundImage(UIImage(systemName: "play.fill"), for: .normal)
            } else {
                // Fallback on earlier versions
                playPuseButton.setBackgroundImage(UIImage(named: "player_play"), for: .normal)
            }
        }
    }
    
    func initialiseAudioPlayer() {
        RappleActivityIndicatorView.startAnimating()

        myPlayer?.delegate = self
        myPlayer?.startPlayer()
    }
}

class MediaPlayerViewController: UIViewController {

    var myPlayer:AudioBookPlayer?
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var previewImage: UIImageView!
    
    @IBOutlet weak var bookChapterTitle: UILabel!
    @IBOutlet weak var mediaTitle: UILabel!
    @IBOutlet weak var playPuseButton: UIButton!
    @IBOutlet weak var prevButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var volumeSlider: UISlider!
    
    @IBOutlet weak var tractDuration: UILabel!
    @IBOutlet weak var tractCompletedTime: UILabel!
    @IBOutlet weak var muteButton: UIButton!
    @IBOutlet weak var maxVolumeButton: UIButton!
    @IBOutlet weak var trackProgressView: UISlider!

    @IBOutlet weak var favoriteButton: UIButton!

    var playingAudio: Audio?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialiseSetUp()
    }
    
    func setGradientBackground() {
        
        let colorTop =  UIColor().hexStringToUIColor(hex: "#cdf5ff").cgColor
        let colorBottom = UIColor().hexStringToUIColor(hex: "#c7eaff").cgColor
        let colorMiddle = UIColor().hexStringToUIColor(hex: "#f4ffff").cgColor

        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop,colorMiddle,colorBottom]
        gradientLayer.locations = [0.0, 0.0]
        gradientLayer.frame = self.view.bounds
                
        self.view.layer.insertSublayer(gradientLayer, at:0)
    }
    
    func initialiseSetUp() {
            myPlayer = DataManager.shared.audioBookPlayer
            initialiseAudioPlayer()
            // Do any additional setup after loading the view.
        
        if #available(iOS 13.0, *) {
            playPuseButton.setBackgroundImage(UIImage(systemName: "play.fill"), for: .selected)
        } else {
            // Fallback on earlier versions
        }
            
        if #available(iOS 13.0, *) {
            playPuseButton.setBackgroundImage(UIImage(systemName: "pause.fill"), for: .normal)
        } else {
            // Fallback on earlier versions
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       // self.view.layerGradient()
        self.setGradientBackground()

        RappleActivityIndicatorView.stopAnimation()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        
        
    // This check is check if this is via full screen media player
        if(favoriteButton != nil) {
            guard let audio = self.playingAudio else {
                return
            }
            let flag =
                favoriteButton.isSelected
            
            AudioRealm.saveAudio(audio, favFlag: flag, dwnloadFlag: audio.downloaded)
        }
    }
        
    @IBAction func volumeSliderUpdated(_ sender: UISlider) {
      //  player1?.volume = sender.value
    }
        
    @IBAction func prevClicked() {
        myPlayer?.previousTrackCommand()
    }
        
    @IBAction func nextClicked() {
        myPlayer?.nextTrackCommand()
    }
        
    @IBAction func playPauseClicked(_ sender: UIButton) {
        
        if(sender.isSelected) {
            // Play action requested
            myPlayer?.playTrackCommand()
        }
        else {
            myPlayer?.pauseTrackCommand()
        }
    }
    
    @IBAction func trackProgressChanged(_ slider: UISlider) {
        myPlayer?.seekPlayerToPosition(slider.value)

        }
    
    @IBAction func muteClicked(_ sender: UIButton) {
        //player1?.volume = 0.0
        volumeSlider.value = 0.0
    }
    
    @IBAction func maxVolumeClicked(_ sender: UIButton) {
        //player1?.volume = 1.0
        volumeSlider.value = 1.0
    }
    
    @IBAction func closePlayer(_ sender: UIButton) {
        myPlayer?.closePlayer()
        myPlayer = nil
        DataManager.shared.audioBookPlayer = nil
    }
    
    @IBAction func favoriteClicked(_ sender: UIButton) {
        //heart
        //heart.fill
          favoriteButton.isSelected = !favoriteButton.isSelected
    }
    
    @IBAction func shareClicked(_ sender: Any) {
        let shareText = "To listen to more audios like \"\(playingAudio?.url ?? "")\",  \(Constants.appShareText)"
        
        openShareView(text: shareText)
    }
}
