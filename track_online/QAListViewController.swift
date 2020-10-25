//
//  QAListViewController.swift
//  track_online
//
//  Created by 刈田修平 on 2020/02/25.
//  Copyright © 2020 刈田修平. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class QAListViewController: UIViewController{

    //テーブルビューインスタンス作成    
    @IBOutlet weak var QAStatus: UIImageView!
    @IBOutlet weak var point: UILabel!
    @IBOutlet weak var QuestionTimes: UILabel!
    @IBOutlet weak var QuestionTimes2: UILabel!
    @IBOutlet weak var AnswerTimes: UILabel!
    @IBOutlet weak var seeMoreQuestion: UILabel!
    //テーブルに表示するセル配列
    var QAArray = [String]()
    var QAList = [String]()
    var PointArray = [String]()
    var CountQuestion = Int()
    let currentUid:String = Auth.auth().currentUser!.uid
    let ref = Database.database().reference()
    var selectedText: String?
    var selectedDate: String?
    var selectedTime: String?
    var selectedSpeciality: String?
    var selectedQAContent: String?
    var selectedUserNameQuestion: String?
    var selectedUid: String?
    var segueNumber: Int?
    let refreshControl = UIRefreshControl()
    var QAStatusRe: String?
    
    var QANameArray = [String]()
    var QAContentArray = [String]()
    var QAStatusArray = [String]()
    var QASpecialityArray = [String]()
    var TimeArray = [String]()
    var DateArray = [String]()
    var userNameArray = [String]()
    var uuidArray = [String]()
    var CountAnswer = Int()
    var countAnswerArray = [String]()

    var QANameArray0 = [String]()
    var QAContentArray0 = [String]()
    var QAStatusArray0 = [String]()
    var QASpecialityArray0 = [String]()
    var TimeArray0 = [String]()
    var DateArray0 = [String]()
    var userNameArray0 = [String]()
    var uuidArray0 = [String]()
    var countAnswerArray0 = [String]()

    var QANameArray1 = [String]()
    var QAContentArray1 = [String]()
    var QAStatusArray1 = [String]()
    var QASpecialityArray1 = [String]()
    var TimeArray1 = [String]()
    var DateArray1 = [String]()
    var userNameArray1 = [String]()
    var uuidArray1 = [String]()
    var countAnswerArray1 = [String]()

    var QANameArray2 = [String]()
    var QAContentArray2 = [String]()
    var QAStatusArray2 = [String]()
    var QASpecialityArray2 = [String]()
    var TimeArray2 = [String]()
    var DateArray2 = [String]()
    var userNameArray2 = [String]()
    var uuidArray2 = [String]()
    var countAnswerArray2 = [String]()

    var tag:Int = 0
    var Tag:Int = 0
    var cellIdentifier:String = ""
    
    var firstLogin:String?
    
    override func viewDidLoad() {
        firstLoginChecked()
        UIApplication.shared.applicationIconBadgeNumber = 0
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        firstLoginChecked()
       loadData_Firebase()
       super.viewWillAppear(animated)
    }

    @IBAction func refreshValue(_ sender: Any) {
        loadData_Firebase()
    }
    func firstLoginChecked(){
        let ref = Database.database().reference().child("QA").child("uuid").child(self.currentUid)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
        // Get user value
            let value = snapshot.value as? NSDictionary
            let key = value?["firstLogin"] as? String ?? ""
            self.firstLogin = key
          }) { (error) in
              print(error.localizedDescription)
        }
        print("ぷよぷよ!!")

    }

    @IBAction func moveToQAPage(_ sender: Any) {
        if self.firstLogin != "1"{
            let alert: UIAlertController = UIAlertController(title: "確認", message: "初回会員登録ボーナスとして300Pが贈呈されます。", preferredStyle:  UIAlertController.Style.alert)
            let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{
            (action: UIAlertAction!) -> Void in
                let data=["firstLogin":"1","point":"300"]
                let ref = Database.database().reference().child("QA").child("uuid").child(self.currentUid)
                ref.updateChildValues(data)
                let QAForm = self.storyboard?.instantiateViewController(withIdentifier: "QAForm") as! QATopViewController
                self.navigationController?.pushViewController(QAForm, animated: true)
            })
            let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel, handler:{
                (action: UIAlertAction!) -> Void in
                print("Cancel")
            })
            alert.addAction(cancelAction)
            alert.addAction(defaultAction)
            present(alert, animated: true, completion: nil)
        }else if self.firstLogin == "1"{
            let QAForm = self.storyboard?.instantiateViewController(withIdentifier: "QAForm") as! QATopViewController
            self.navigationController?.pushViewController(QAForm, animated: true)
        }
    }


    //Firebaseからルーム一覧を取得する
    func loadData_Firebase() {
            QANameArray0.removeAll()
            QANameArray1.removeAll()
            QANameArray2.removeAll()
//            QAContentArray0.removeAll()
//            QAStatusArray0.removeAll()
//            DateArray0.removeAll()
//            TimeArray0.removeAll()
//            QASpecialityArray0.removeAll()
        ref.child("QA").child("uuid").child("\(currentUid)").observeSingleEvent(of: .value, with: { (snapshot) in
          // Get user value
          let value = snapshot.value as? NSDictionary
          let key = value?["point"] as? String ?? ""
            if key.isEmpty{
                self.point.text = "-"
            }else{
                self.point.text = key + "P"
            }
          }) { (error) in
            print(error.localizedDescription)
        }
        ref.child("QA").child(currentUid).child("private").observeSingleEvent(of: .value, with: {
            (snapshot) in
            if let snapdata = snapshot.value as? [String:NSDictionary]{
            for key in snapdata.keys.sorted(){
                let snap = snapdata[key]
                if let QAName = snap!["QAName"]{
                    self.QANameArray1.append(QAName as! String)
                self.CountQuestion = self.QANameArray1.count
                self.QuestionTimes2.text = self.CountQuestion.description
                }
            }
            }
        }
        )
        ref.child("QA").child(currentUid).child("public").child("answer").observeSingleEvent(of: .value, with: {
            (snapshot) in
            if let snapdata = snapshot.value as? [String:NSDictionary]{
            for key in snapdata.keys.sorted(){
                let snap = snapdata[key]
                if let QAName = snap!["QAName"]{
                    self.QANameArray2.append(QAName as! String)
                self.CountAnswer = self.QANameArray2.count
                self.AnswerTimes.text = self.CountAnswer.description
                }
            }
            }
        }
        )
        ref.child("QA").child(currentUid).child("public").observeSingleEvent(of: .value, with: {
            (snapshot) in
            if let snapdata = snapshot.value as? [String:NSDictionary]{
            for key in snapdata.keys.sorted(){
                let snap = snapdata[key]
                if let QAName = snap!["QAName"]{
                    self.QANameArray0.append(QAName as! String)
                self.CountQuestion = self.QANameArray0.count
                self.QuestionTimes.text = self.CountQuestion.description
                }
            }
            }
        }
        )
    }

    
}
