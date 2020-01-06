//
//  CustomTableViewCell.swift
//  ScratchApp
//
//  Created by Sean Goldsborough on 1/3/20.
//  Copyright © 2020 Sean Goldsborough. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    @IBOutlet weak var userAvatarImage: UIImageView!
    @IBOutlet weak var imageActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var goldBadgeImage: UIImageView!
    @IBOutlet weak var goldBadgeCount: UILabel!
    
    @IBOutlet weak var silverBadgeImage: UIImageView!
    @IBOutlet weak var silverBadgeCount: UILabel!
    
    @IBOutlet weak var bronzeBadgeImage: UIImageView!
    @IBOutlet weak var bronzeBadgeCount: UILabel!
    
    var goldBadgeNumber = Int("5201")
    var silverBadgeNumber = Int("3401")
    var bronzeBadgeNumber = Int("7501")
    
    var imageUrl = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
