//
//  HomeMoiesTableViewCell.swift
//  Movies
//
//  Created by Admin on 1/2/19.
//  Copyright © 2019 Hema. All rights reserved.
//

import UIKit

class HomeMoviesTableViewCell: UITableViewCell {

    @IBOutlet weak var imaveView: UIImageView!
    @IBOutlet weak var MovieName: UILabel!
    @IBOutlet weak var MovieDescription: UILabel!
    @IBOutlet weak var MovieGeners: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
