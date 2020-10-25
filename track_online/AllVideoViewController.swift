//
//  AllVideoViewController.swift
//  track_online
//
//  Created by 刈田修平 on 2019/11/15.
//  Copyright © 2019 刈田修平. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class AllVideoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
let TODO = ["牛乳を買う", "掃除をする", "アプリ開発の勉強をする"]
//    var videoArray: [String] = []
//
//    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
//        loadData_Firebase()
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
//    func loadData_Firebase() {
//        //Databaseの参照URLを取得
//        let ref = Database.database().reference()
//        //データ取得開始
//        let currentUid = Auth.auth().currentUser?.uid
//        ref.child("\(currentUid)").observeSingleEvent(of: .value) { (snap, error) in
//            //RoomList下の階層をまとめて取得
//            let snapdata = snap.value as? [String:NSDictionary]
//            //データを取得する配列
//            //もしデータがなければ無反応
//            if snapdata == nil {
//                return
//            }
//            //snapdata!.keys : 階層
//            //key : 階層
//            for key in snapdata!.keys.sorted() {
//                //snap : 階層下のデータを書くのすいた辞書
//                //今回なら、snap = ["RoomName":"はわはわ"]
//                let snap = snapdata![key]
//                if let videoname = snap!["videoname"] as? String {
//                    self.videoArray.append(videoname)
//                }
//            }
//        }
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TODO.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // セルを取得する
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        // セルに表示する値を設定する
        cell.textLabel!.text = TODO[indexPath.row]
        return cell
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
