//
//  ListenHistoryTableViewController.swift
//  SmashMusic
//
//  Created by Mubaarak Hassan on 08/11/2017.
//  Copyright © 2017 Mubaarak Hassan. All rights reserved.
//

import UIKit
import CoreData

class ListenHistoryTableViewController: UITableViewController {
    var listOfSongs = [HistoryData]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fetchRequest: NSFetchRequest<HistoryData> = HistoryData.fetchRequest()
        do{
            let songs = try PersistenceService.context.fetch(fetchRequest)
            self.listOfSongs = songs
            tableView.reloadData()
        }catch{
            
        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func viewDidAppear(_ animated: Bool) {
        let fetchRequest: NSFetchRequest<HistoryData> = HistoryData.fetchRequest()
        do{
            let songs = try PersistenceService.context.fetch(fetchRequest)
            self.listOfSongs = songs
            tableView.reloadData()
        }catch{
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return listOfSongs.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "historyCell", for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = "\(String(describing: listOfSongs[indexPath.row].song ?? "")) from playlist: \(String(describing: listOfSongs[indexPath.row].playlist ?? ""))"
        cell.textLabel?.adjustsFontSizeToFitWidth = true

        return cell
    }
 
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete
        {
            let cell = tableView.cellForRow(at: indexPath)
            deleteCell(cell: cell!)
            tableView.reloadData()
        }
    }
    
    func deleteCell(cell: UITableViewCell) {
        if let deletionIndexPath = tableView.indexPath(for: cell) {
            let context: NSManagedObjectContext = PersistenceService.context
            context.delete((listOfSongs[deletionIndexPath.row]))
            listOfSongs.remove(at: deletionIndexPath.row)
            do{
                try context.save()
            }catch let error as NSError{
                print("Could not save. \(error.localizedDescription)")
            }
        }
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
