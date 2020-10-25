//
//  chaosMapTableViewCell.swift
//  track_online
//
//  Created by 刈田修平 on 2020/08/09.
//  Copyright © 2020 刈田修平. All rights reserved.
//

import UIKit

class chaosMapTableViewCell: UITableViewCell {
    
    @IBOutlet var event: UILabel!
    @IBOutlet weak var abstract: UILabel!

    @IBOutlet weak var typeImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var belong: UILabel!
    @IBOutlet weak var PB: UILabel!
    @IBOutlet weak var champion: UILabel!
    @IBOutlet weak var prize: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
