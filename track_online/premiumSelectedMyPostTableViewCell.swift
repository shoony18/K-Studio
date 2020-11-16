//
//  premiumSelectedMyPostTableViewCell.swift
//  track_online
//
//  Created by 刈田修平 on 2020/10/04.
//  Copyright © 2020 刈田修平. All rights reserved.
//

import UIKit

class premiumSelectedMyPostTableViewCell: UITableViewCell {

    @IBOutlet var userName: UILabel!
    @IBOutlet var title: UILabel!
    @IBOutlet var date: UILabel!
    @IBOutlet var time: UILabel!
    @IBOutlet var height: UILabel!
    @IBOutlet var weight: UILabel!
    @IBOutlet var event: UILabel!
    @IBOutlet var PB: UILabel!
    @IBOutlet var ImageView: UIImageView!
    @IBOutlet var playVideo: UIButton!
    @IBOutlet var titleLabel1: UILabel!
    @IBOutlet var titleLabel2: UILabel!
    @IBOutlet var answerLabel: UILabel!
    @IBOutlet var comment: UILabel!
    @IBOutlet var recommendTrainigLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
