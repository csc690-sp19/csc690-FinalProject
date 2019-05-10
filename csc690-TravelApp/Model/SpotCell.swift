//
//  SpotCell.swift
//  csc690-TravelApp
//
//  Created by SiuChun Kung on 5/2/19.
//  Copyright © 2019 SiuChun Kung. All rights reserved.
//

import UIKit


class SpotCell: UITableViewCell{
    
    @IBOutlet weak var spotDescription: UILabel!
    @IBOutlet weak var spotNameLabel: UILabel!
    @IBOutlet weak var spotImage: UIImageView!
    @IBOutlet weak var address: UILabel!
    
    
    var spot: Spot! {
        didSet{
            let spotname = spot.spotName
            let description = spot.description
            let iconURL = URL(string: spot.IconURL)!
            let addr = spot.spotAddress
            let spotLat = spot.spotLat
            let spotLng = spot.spotLng
            
            spotNameLabel.text = spotname
            spotDescription.text = description
            address.text = addr
            spotImage.af_setImage(withURL: iconURL)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
