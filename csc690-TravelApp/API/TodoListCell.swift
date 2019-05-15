//
//  TodoListCell.swift
//  csc690-TodoApp
//
//  Created by SiuChun Kung on 5/11/19.
//  Copyright © 2019 SiuChun Kung. All rights reserved.
//

import UIKit

class TodoListCell: UITableViewCell {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var spotImage: UIImageView!
    
    var done:Bool = false

    
    @IBAction func tapButton(_ sender: Any) {
        if (!done) {
            let image = UIImage(named: "done")
            button.setImage(image, for: UIControl.State.normal)
            done = true
        } else {
            let image = UIImage(named: "undone")
            button.setImage(image, for: UIControl.State.normal)
            done = false
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
