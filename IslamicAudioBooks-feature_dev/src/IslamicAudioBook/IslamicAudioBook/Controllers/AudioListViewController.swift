//
//  AudioListViewController.swift
//  IslamicAudioBook
//
//  Created by Ameer Shaikh on 06/08/2020.
//  Copyright © 2020 Ameer. All rights reserved.
//

import UIKit
import RappleProgressHUD



class AudioListViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var topAudioCount: UIImageView!
    @IBOutlet weak var audioCountLabel: UILabel!
    
    @IBOutlet weak var playAll: UIImageView!
    @IBOutlet weak var playAllLabel: UILabel!
    
    @IBOutlet weak var audioTableView: UITableView!
    
  //  @IBOutlet weak var containerHeight: NSLayoutConstraint!
    var navTitle = ""
    var dataSource:Audios = []
    var chapterId:String = ""
    var topicId:String = ""
    
    var downlodingIndexes: [Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.audioTableView.tableFooterView = UIView()
        self.audioTableView.rowHeight = UITableView.automaticDimension
        self.audioTableView.estimatedRowHeight = 200
        
        self.navigationItem.title = navTitle
        
        /*
        if #available(iOS 13.0, *) {
            self.playAll.image =  UIImage.textEmbeded(image: UIImage(systemName: "play.fill")!, string: "Play All", isImageBeforeText: true)
        } else {
            // Fallback on earlier versions
        }
 */
        prepareDataSource()
    }
    
    func prepareDataSource() {
            RappleActivityIndicatorView.startAnimating()
                    
            ServerCommunications.audioListOfChapters(chapterId: chapterId, topicId: topicId,  completion: {(result) in
                RappleActivityIndicatorView.stopAnimation()

                guard let res = result else {
                    return
                }
                self.dataSource = res
                self.audioTableView.reloadData()
                
                self.audioCountLabel.text = "Audios(\(res.count))"
                /*
                if #available(iOS 13.0, *) {
                    self.topAudioCount.image =  UIImage.textEmbeded(image: UIImage(systemName: "music.note.list")!, string: "Audios(\(res.count))", isImageBeforeText: true)
                } else {
                    // Fallback on earlier versions
                    self.topAudioCount.image =  UIImage.textEmbeded(image: UIImage(named: "music")!, string: "Audios(\(res.count))", isImageBeforeText: true)
                }
                 */
            })
    }
    

    
    @IBAction func playAllClicked(_ sender: Any) {
        print("Play All clicked")
        DataManager.shared.initialisePlayer(audios: dataSource, position: 0)
        self.navigateToMediaPlayer()
    }
    
    @IBAction func playSelectedAudio(_ sender: UIButton) {
        let position = sender.tag
        DataManager.shared.initialisePlayer(audios: dataSource, position: position)
        self.navigateToMediaPlayer()
    }
    
    @IBAction func downloadAllAudios(_ sender: Any) {
        print("Download All clicked")
        downlodingIndexes = Array(0...dataSource.count)
        self.audioTableView.reloadData()

        for audio in dataSource {
            AudioDownloader.shared.downloadAudio(audio: audio) { (flag) in
                DispatchQueue.main.async {
                    let index = self.dataSource.firstIndex(of: audio) ?? 0
                    self.downlodingIndexes = self.downlodingIndexes.filter(){$0 != index}

                    self.audioTableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
                }
            }
        }
    }
    
    @IBAction func downloadSelectedAudio(_ sender: UIButton) {
        let tag = sender.tag
        sender.tintColor = .orange
        let audio = dataSource[tag]
        AudioDownloader.shared.downloadAudio(audio: audio) { (flag) in
            DispatchQueue.main.async {
                self.audioTableView.reloadRows(at: [IndexPath(row: tag, section: 0)], with: .fade)
            }
        }
    }
    
    // MARK: - Table view data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "audioCellIdentifier", for: indexPath) as! AudioTableViewCell
    
        let index = indexPath.row
        let audio = dataSource[index]
        
        let dbAudio = AudioRealm.audioFromURL(audio.url)
        
        if (dbAudio != nil && dbAudio?.downloaded == true) {
            cell.downloadBtn.tintColor =   .appThemeColor
            cell.downloadBtn.setImage(UIImage(systemName: "checkmark.icloud.fill"), for: .normal)
        } else {
            cell.downloadBtn.tintColor = self.downlodingIndexes.contains(indexPath.row) ? .orange : .gray
            cell.downloadBtn.setImage(UIImage(systemName: "icloud.and.arrow.down.fill"), for: .normal)
        }
        
        cell.audioIndex.text = audio.slno
        cell.audioTitle.text = audio.audioname
        cell.downloadBtn.tag = index
        cell.playBtn.tag = index
     
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            
         tableView.deselectRow(at: indexPath, animated: true)
        // present the player
        let position = indexPath.row
        DataManager.shared.initialisePlayer(audios: dataSource, position: position)
        self.navigateToMediaPlayer()
        //present(vc, animated: true)
    }
    

}
