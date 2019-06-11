//
//  SecondViewController.swift
//  SmashMusic
//
//  Created by Mubaarak Hassan on 23/10/2017.
//  Copyright © 2017 Mubaarak Hassan. All rights reserved.
//

import UIKit

class LibraryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var listOfTableViewCells = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        listOfTableViewCells = ["Playlist", "Artists", "Albums", "Songs"]
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listOfTableViewCells.count
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("LibraryTableViewCell", owner: self, options: nil)?.first as! LibraryTableViewCell
        // Configure the cell...
        cell.tableText.text = listOfTableViewCells[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "playlistSegue", sender: Any?.self)
    }
    
    // MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "playlistSegue" {
            segue.destination as? PlaylistViewController
        }
        
    }
    
}

