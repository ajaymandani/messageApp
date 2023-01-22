//
//  ChatsTableViewController.swift
//  whatsapp
//
//  Created by Ajay Mandani on 2023-01-13.
//

import UIKit

class ChatsTableViewController: UITableViewController {

    

    var allrec:[RecentChat] = []
    var filteredrec:[RecentChat] = []

    let searchcontroller = UISearchController(searchResultsController: nil)
    override func viewDidLoad() {
        super.viewDidLoad()
        donwloadrecentdata()
        navigationItem.searchController = searchcontroller
        navigationItem.hidesSearchBarWhenScrolling = true
        searchcontroller.searchResultsUpdater = self
        definesPresentationContext = true
        searchcontroller.obscuresBackgroundDuringPresentation = false
    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return searchcontroller.isActive ? filteredrec.count : allrec.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! RecentTableViewCell
        
        cell.configure(recent: searchcontroller.isActive ? filteredrec[indexPath.row] : allrec[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            let recent = searchcontroller.isActive ? filteredrec[indexPath.row] : allrec[indexPath.row]
            
            FirebaseRecentListner.shared.deleterecent(recent: recent)
            
            searchcontroller.isActive ? self.filteredrec.remove(at: indexPath.row) : allrec.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
  
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let recent = searchcontroller.isActive ? filteredrec[indexPath.row] : allrec[indexPath.row]
        
        FirebaseRecentListner.shared.clearunreadCounter(recent: recent)
        
        gotochat(recent:recent)
    }
    
    func gotochat(recent:RecentChat)
    {
        restartChat(chartRoomId: recent.chatRoomId, memeberIds: recent.memeberIds)
        let privatChatView = MessageViewController(chatId: recent.chatRoomId,recepientId: recent.receiverId,recepientName: recent.receriverName)
        privatChatView.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(privatChatView, animated: true)
    }

    
    private func donwloadrecentdata()
    {
        FirebaseRecentListner.shared.downloadallrecentchatfromfirestore { allrecent in
            if let allrecent = allrecent{
                self.allrec = allrecent
               
            }else{
                self.allrec = []
                
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        }
    }
  

    func filteredsearch(text:String)
    {
        filteredrec = allrec.filter({ rec -> Bool in
            return rec.receriverName.lowercased().contains(text.lowercased())
            
        })
        tableView.reloadData()
    }
}

extension ChatsTableViewController:UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
    
        filteredsearch(text: searchController.searchBar.text!)
    }
    
    
}
