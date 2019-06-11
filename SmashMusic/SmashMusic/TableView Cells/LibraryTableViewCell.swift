//
//  LibraryTableViewCell.swift
//  SmashMusic
//
//  Created by Mubaarak Hassan on 03/11/2017.
//  Copyright © 2017 Mubaarak Hassan. All rights reserved.
//

import UIKit

class LibraryTableViewCell: UITableViewCell {

    @IBOutlet weak var tableText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
