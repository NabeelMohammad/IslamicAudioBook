//
//  RecordListViewController.swift
//  IslamicAudioBook
//
//  Created by Ameer Shaikh on 22/09/2020.
//  Copyright © 2020 Ameer. All rights reserved.
//

import UIKit

enum RecordMode {
    case favorite, history, download
}

class RecordListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var noDataLabel: UILabel!
    @IBOutlet weak var recordTableView: UITableView!
    var dataSource : Audios = []
    var recordMode : RecordMode = .favorite
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        self.title = screenTitle()

        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)

        // Do any additional setup after loading the view.
        self.recordTableView.tableFooterView = UIView()
        self.recordTableView.rowHeight = UITableView.automaticDimension
        self.recordTableView.estimatedRowHeight = 200
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateTableDataSource()
        self.noDataLabel.isHidden = dataSource.count == 0 ? false : true
    }
    
    func screenTitle() -> String {
        switch recordMode {
        case .favorite:
            return "Favorite"
        case .download:
            return "Download"
        case .history:
            return "History"
        }
    }
 
    func updateTableDataSource()  {
        switch recordMode {
        case .favorite:
            dataSource = AudioRealm.favoriteAudios()
        case .download:
            dataSource = AudioRealm.downloadedAudios()
        case .history:
            dataSource = AudioRealm.historyAudios()
        }
        recordTableView.reloadData()
    }
    
    // MARK: - Table view data source
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "recordCellIdentifier", for: indexPath) as! RecordTableViewCell
    
        let index = indexPath.row
        let audio = dataSource[index]
        cell.chapterIndex.text = "\(index+1). "
        cell.chapterTitle.text =  audio.chapter
        cell.engTitle.text = audio.audioname
        cell.urduTitle.text = audio.audionameurdu

        let colorBottom = UIColor().hexStringToUIColor(hex: "#c7eaff")

        cell.backgroundColor = (index % 2) == 0 ? colorBottom : UIColor.white
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         tableView.deselectRow(at: indexPath, animated: true)
        // present the player
        let position = indexPath.row
        DataManager.shared.initialisePlayer(audios: dataSource, position: position)
        guard let vc = storyboard?.instantiateViewController(identifier: "MediaPlayerViewController") as? MediaPlayerViewController else {
            return
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
     func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let deleteAudio = dataSource[indexPath.row]
            
            let player = DataManager.shared.audioBookPlayer
            if(player != nil){
                let playingAudio = player?.selectedMedia
                if(playingAudio != nil && deleteAudio.url == playingAudio?.url){
                    DataManager.shared.resetAudioPlayer()
                }
            }
                        
            dataSource.remove(at: indexPath.row)
           // tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.reloadData()
            
            if(dataSource.count == 0) {
                self.noDataLabel.isHidden = false
            }
            
            switch recordMode {
            case .favorite:
                AudioRealm.updateFavoriteFlag(deleteAudio, favFlag: false)
            case .download:
                AudioRealm.updateDownloadedFlag(deleteAudio, flag: false)
                FileManager.deleteAudioFile(audio: deleteAudio.url )
            case .history:
                AudioRealm.updateHistory(deleteAudio, shouldReset: true)
            }
        }
    }
    
    
    @IBAction func deleteAllRecords(_ sender: Any) {
        showAlertForDeletingAllRecords()
    }
    
    func showAlertForDeletingAllRecords() {
        let alertController = UIAlertController(title: "Delete All", message: "Do you want to delete all saved records ?", preferredStyle: .alert)
        let ok = UIAlertAction(title: "Yes", style: .default, handler: { (action) -> Void in
            self.deleteAllRecordsHandler()
        })
        
        let cancel = UIAlertAction(title: "Cancel", style: .default)
        alertController.addAction(cancel)
        alertController.addAction(ok)

        self.present(alertController, animated: true, completion: nil)
    }
    
    func deleteAllRecordsHandler() {
        let player = DataManager.shared.audioBookPlayer
        if(player != nil){
            let playingAudio = player?.selectedMedia
            if(playingAudio != nil ){
                let matchedAudio = dataSource.first(where: { (audio) -> Bool in
                    audio.url == playingAudio?.url
                })
                
                if (matchedAudio != nil) {
                    DataManager.shared.resetAudioPlayer()
                }
            }
        }

        dataSource.removeAll()
        recordTableView.reloadData()
        self.noDataLabel.isHidden = false
        
        switch recordMode {
        case .favorite:
            AudioRealm.resetAllFavoriteAudio()
        case .download:
            AudioRealm.resetAllDownloadedAudioFlag()
            FileManager.deleteAllAudiosFromDirectory()
        case .history:
            AudioRealm.resetAllAudioHistory()
        }
    }
    
}
