//
//  QATableViewCell.swift
//  track_online
//
//  Created by 刈田修平 on 2020/05/16.
//  Copyright © 2020 刈田修平. All rights reserved.
//

import UIKit

class QATableViewCell: UITableViewCell {
        
    // ①QA村ページのQA一覧テーブルビュー
    @IBOutlet weak var QAContent1: UILabel!
    @IBOutlet weak var date1: UILabel!
    @IBOutlet weak var time1: UILabel!
    @IBOutlet weak var TextFieldGenre1: UILabel!
    @IBOutlet weak var QASpeciality1: UILabel!
    //    @IBOutlet weak var QAStatusImageView1: UIImageView!
    @IBOutlet weak var userName1: UILabel!
    @IBOutlet weak var countAnswer1: UILabel!
    // >詳細ページの回答テーブルビュー
    @IBOutlet weak var userNameAnswer1_2: UILabel!
    @IBOutlet weak var answer1_2: UILabel!
    @IBOutlet weak var date1_2: UILabel!
    @IBOutlet weak var time1_2: UILabel!
    @IBOutlet weak var goodButton1_2: UIButton!
    @IBOutlet weak var sankouURL1_2: UILabel!
    @IBOutlet weak var flag1_2: UIButton!
    
    // ②マイページリストのテーブルビュー
    // >質問（一般公開）
    @IBOutlet weak var date2_1: UILabel!
    @IBOutlet weak var time2_1: UILabel!
    @IBOutlet weak var QASpeciality2_1: UILabel!
    @IBOutlet weak var QAContent2_1: UILabel!
    @IBOutlet weak var countAnswer2_1: UILabel!
    @IBOutlet weak var answer: UILabel!
    @IBOutlet weak var goodButton: UIButton!
    @IBOutlet weak var badButton: UIButton!
    @IBOutlet weak var sankouURL: UILabel!
    @IBOutlet weak var userNameAnswer: UILabel!
    
    // >質問（trackプレミアム）
    @IBOutlet weak var QAContent2_2: UILabel!
    @IBOutlet weak var date2_2: UILabel!
    @IBOutlet weak var time2_2: UILabel!
    @IBOutlet weak var QASpeciality2_2: UILabel!
    @IBOutlet weak var countAnswer2_2: UILabel!
    
    // >回答
    @IBOutlet weak var QAContent2_3: UILabel!
    @IBOutlet weak var date2_3: UILabel!
    @IBOutlet weak var time2_3: UILabel!
    @IBOutlet weak var QASpeciality2_3: UILabel!
    @IBOutlet weak var countAnswer2_3: UILabel!
    @IBOutlet weak var answer2_3: UILabel!
    @IBOutlet weak var goodButton2_3: UIButton!
    @IBOutlet weak var flag2_3: UIButton!
    
    // >リスト詳細ページの回答テーブルビュー
    @IBOutlet weak var userNameAnswer2_1_2: UILabel!
    @IBOutlet weak var answer2_1_2: UILabel!
    @IBOutlet weak var sankouURL2_1_2: UILabel!
    @IBOutlet weak var date2_1_2: UILabel!
    @IBOutlet weak var time2_1_2: UILabel!
    @IBOutlet weak var goodButton2_1_2: UIButton!
    @IBOutlet weak var badButton2_1_2: UIButton!
    
    // >リスト詳細ページの回答テーブルビュー（trackプレミアム）
    @IBOutlet weak var userNameAnswer2_2_2: UILabel!
    @IBOutlet weak var answer2_2_2: UILabel!
    @IBOutlet weak var sankouURL2_2_2: UITextView!
    @IBOutlet weak var date2_2_2: UILabel!
    @IBOutlet weak var time2_2_2: UILabel!
    @IBOutlet weak var goodButton2_2_2: UIButton!
    @IBOutlet weak var badButton2_2_2: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
