//
//  SearchViewController.swift
//  IslamicAudioBook
//
//  Created by Ameer Shaikh on 13/09/2020.
//  Copyright © 2020 Ameer. All rights reserved.
//

import UIKit
import RappleProgressHUD

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
           return bookSearchData.count
        case 1:
           return chapterSearchData.count
        default:
           return audioSearchData.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchCellIdentifier", for: indexPath) as! SearchTableViewCell
        
        var engTitle = ""
        var urduTitle = ""
        
        let section = indexPath.section
        switch section {
        case 0:
            let book = bookSearchData[indexPath.row]
            engTitle = book.name
            urduTitle = book.nameurdu
            cell.searchImageView.loadAsyncImage(imageUrl: book.profileImage)

        case 1:
            let chapter = chapterSearchData[indexPath.row]
            engTitle = chapter.chapter ?? ""
            urduTitle = chapter.chapterurdu ?? ""
            cell.searchImageView.image = UIImage(named: "search_chapter")
            
        default:
            let audio = audioSearchData[indexPath.row]
            engTitle = audio.audioname
            urduTitle = audio.audionameurdu
            cell.searchImageView.image = UIImage(named: "search_audio")
        }
        cell.engTitle.text = engTitle
        cell.urduTitle.text = urduTitle
                
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         tableView.deselectRow(at: indexPath, animated: true)
        // present the player
        switch indexPath.section {
        case 0:
            AppLogger.log("Not implemented yet")
        case 1:
            AppLogger.log("Not implemented yet")
        default:
            let audio = audioSearchData[indexPath.row]
           DataManager.shared.initialisePlayer(audios: [audio], position: 0)
           self.navigateToMediaPlayer()
        }
        //present(vc, animated: true)
    }
}


class SearchViewController: BaseViewController, UISearchBarDelegate {
    
    @IBOutlet weak var searchTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchLabel: UILabel!
    
    var audioSearchData:Audios = []
    var chapterSearchData:Chapters = []
    var bookSearchData:Books = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.showShareNavigationItem()

        self.searchTableView.tableFooterView = UIView()
        self.searchTableView.rowHeight = UITableView.automaticDimension

       // self.view.layerGradient()
        // Do any additional setup after loading the view.
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.reload(_:)), object: searchBar)
            perform(#selector(self.reload(_:)), with: searchBar, afterDelay: 0.75)
        }

        @objc func reload(_ searchBar: UISearchBar) {
            guard let searchText = searchBar.text, searchText.trimmingCharacters(in: .whitespaces) != "" else {
                shouldShowSearchResult(false)
                return
            }
        
            shouldShowSearchResult(true)
            
            bookSearchData = Book.searchBooks(searchStr:searchText)
            chapterSearchData = Chapter.searchChapters(searchStr: searchText)
            
            //RappleActivityIndicatorView.startAnimating()
            ServerCommunications.searchText(inputText: searchText ) { result in
               // RappleActivityIndicatorView.stopAnimation()
                guard let res = result else {
                    return
                }
                self.audioSearchData = res
                self.searchTableView.reloadData()
            }
    }
    
    func shouldShowSearchResult(_ showResult: Bool) {
        if(showResult) {
            searchLabel.isHidden = true
            searchTableView.isHidden = false
        }
        else {
            searchLabel.isHidden = false
            searchTableView.isHidden = true
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
       self.searchBar.endEditing(true)
    }
}
