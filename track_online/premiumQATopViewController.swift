//
//  premiumQATopViewController.swift
//  track_online
//
//  Created by 刈田修平 on 2020/08/18.
//  Copyright © 2020 刈田修平. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class premiumQATopViewController: UIViewController {

    let currentUid:String = Auth.auth().currentUser!.uid
    let ref = Database.database().reference()
    var firstLogin:String?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
//    @IBAction func moveToQAPage(_ sender: Any) {
//        if self.firstLogin != "1"{
//            let alert: UIAlertController = UIAlertController(title: "確認", message: "初回会員登録ボーナスとして300Pが贈呈されます。", preferredStyle:  UIAlertController.Style.alert)
//            let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{
//            (action: UIAlertAction!) -> Void in
//                let data=["firstLogin":"1","point":"300"]
//                let ref = Database.database().reference().child("QA").child("uuid").child(self.currentUid)
//                ref.updateChildValues(data)
//                let QAForm = self.storyboard?.instantiateViewController(withIdentifier: "premiumQAForm") as! QATopViewController
//                self.navigationController?.pushViewController(QAForm, animated: true)
//            })
//            let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel, handler:{
//                (action: UIAlertAction!) -> Void in
//                print("Cancel")
//            })
//            alert.addAction(cancelAction)
//            alert.addAction(defaultAction)
//            present(alert, animated: true, completion: nil)
//        }else if self.firstLogin == "1"{
//            let QAForm = self.storyboard?.instantiateViewController(withIdentifier: "premiumQAForm") as! QATopViewController
//            self.navigationController?.pushViewController(QAForm, animated: true)
//        }
//    }
}
