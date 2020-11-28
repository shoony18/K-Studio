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
    let Ref = Database.database().reference()
    var firstLogin:String?
    @IBOutlet var name1: UILabel!
    @IBOutlet var intro1: UILabel!
    @IBOutlet var name2: UILabel!
    @IBOutlet var intro2: UILabel!

    override func viewDidLoad() {
        let ref1 = Ref.child("purchase").child("premium").child("setting").child("coach").child("1")
        let ref2 = Ref.child("purchase").child("premium").child("setting").child("coach").child("2")
        ref1.observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let key = value?["name"] as? String ?? ""
            self.name1.text = key
        })
        ref1.observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let key = value?["intro"] as? String ?? ""
            self.intro1.text = key
        })
        ref2.observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let key = value?["name"] as? String ?? ""
            self.name2.text = key
        })
        ref2.observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let key = value?["intro"] as? String ?? ""
            self.intro2.text = key
        })

        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}
