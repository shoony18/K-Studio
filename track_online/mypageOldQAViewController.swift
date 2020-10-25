//
//  mypageOldQAViewController.swift
//  track_online
//
//  Created by 刈田修平 on 2020/06/21.
//  Copyright © 2020 刈田修平. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class mypageOldQAViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    //スクリーンの横幅、縦幅を定義
    let screenWidth = Int(UIScreen.main.bounds.size.width)
    let screenHeight = Int(UIScreen.main.bounds.size.height)

    @IBOutlet var sampleTableView: UITableView!
    
    //テーブルに表示するセル配列
    var QAArray = [String]()
    var QAList = [String]()
    var QAStatusArray = [String]()
    let currentUid:String = Auth.auth().currentUser!.uid
    let ref = Database.database().reference()
    var selectedText: String?
    var segueNumber: Int?
    let refreshControl = UIRefreshControl()
    var QAStatusRe: String?

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
       loadData_Firebase()
       super.viewWillAppear(animated)
    }

        
    func loadData_Firebase() {
        if QAArray.isEmpty {
        }else{
            QAArray.removeAll()
            QAStatusArray.removeAll()
        }

        print("\(QAArray)")
            //データ取得開始
        ref.child("QA").child(currentUid).observeSingleEvent(of: .value, with: {
                (snapshot) in
            if let snapdata = snapshot.value as? [String:NSDictionary]{
                //snapdata!.keys : 階層
                //key : 階層
                for key in snapdata.keys.sorted(){
                    //snap : 階層下のデータを書くのすいた辞書
                    //今回なら、snap = ["videoname":"///"]
                    let snap = snapdata[key]
                    if let QAName = snap!["QAName"] as? String {
                        self.QAArray.append(QAName)
                    }
                    self.QAList = self.QAArray
                }
                for key in snapdata.keys.sorted(){
                    //snap : 階層下のデータを書くのすいた辞書
                    //今回なら、snap = ["videoname":"///"]
                    let snap = snapdata[key]
                    if let QAStatus = snap!["QAStatus"] as? String {
                        self.QAStatusArray.append(QAStatus)
                    }
                        print("\(self.QAStatusArray)")
    //                self.QAList = self.QAArray
                }
                self.sampleTableView.reloadData()
            }
        }
        )
    }
    //セクション数を指定
    func numberOfSections(in sampleTableView: UITableView) -> Int {
        return 1
    }
    //表示するcellの数を指定
    func tableView(_ sampleTableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return QAList.count
    }
    //cellのコンテンツ
    func tableView(_ sampleTableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("\(QAStatusArray)")
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "cell")
        //cellにはsampleArrayが一つずつ入るようにするよ！
        cell.textLabel?.text = QAList[indexPath.row]
        cell.accessoryView = UIImageView(image:UIImage(named: QAStatusArray[indexPath.row]))
        cell.accessoryView?.frame = CGRect(x:0,y:0,width:60,height:40)
        return cell
    }
    
    //cellが選択された時の処理
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("\(indexPath.row)番セルが押されたよ！")
        selectedText = QAList[indexPath.row]
        ref.child("QA").child(currentUid).child("\(selectedText!)").child("QAStatus").observe(.value) { (snap: DataSnapshot) in
            //処理したい内容
        
            print((snap.value! as AnyObject).description as Any)
            if ((snap.value! as AnyObject).description as String) == "QAStatus1.png"{
                let data = ["QAStatus": "QAStatus2.png"]
                self.ref.child("QA").child(self.currentUid).child("\(self.selectedText!)").updateChildValues(data)
                print("QAStatus変わったよ！")
                UIApplication.shared.applicationIconBadgeNumber = 0
            }
        }
        performSegue(withIdentifier: "selectedQAList1", sender: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "selectedQAList0")||(segue.identifier == "selectedQAList1") {
            if #available(iOS 13.0, *) {
                let selectedQAList: SelectedOldQAListViewController = segue.destination as! SelectedOldQAListViewController
                // 11. SecondViewControllerのtextに選択した文字列を設定する
                selectedQAList.text = self.selectedText!
            } else {
                // Fallback on earlier versions
            }
        }
    }
    @IBAction func doUnwind(segue: UIStoryboardSegue) {}


}
