//
//  CollectionViewCell.swift
//  track_online
//
//  Created by 刈田修平 on 2020/08/06.
//  Copyright © 2020 刈田修平. All rights reserved.
//

import Foundation

import UIKit

class CollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var name1: UILabel!
    @IBOutlet weak var belong1: UILabel!
    @IBOutlet weak var name2: UILabel!
    @IBOutlet weak var belong2: UILabel!
    @IBOutlet weak var name3: UILabel!
    @IBOutlet weak var belong3: UILabel!
    @IBOutlet weak var name4: UILabel!
    @IBOutlet weak var belong4: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
