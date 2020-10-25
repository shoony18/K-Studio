//
//  mypage1ViewController.swift
//  track_online
//
//  Created by 刈田修平 on 2020/06/12.
//  Copyright © 2020 刈田修平. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class mypage1ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var sampleTableView1: UITableView!

    var QANameArray1 = [String]()
    var QAContentArray1 = [String]()
    var QAStatusArray1 = [String]()
    var QASpecialityArray1 = [String]()
    var TimeArray1 = [String]()
    var DateArray1 = [String]()
    var userNameArray1 = [String]()
    var uuidArray1 = [String]()
    var countAnswerArray1 = [String]()
    var QANameArray1_r = [String]()
    var QAContentArray1_r = [String]()
    var QAStatusArray1_r = [String]()
    var QASpecialityArray1_r = [String]()
    var TimeArray1_r = [String]()
    var DateArray1_r = [String]()
    var userNameArray1_r = [String]()
    var uuidArray1_r = [String]()
    var countAnswerArray1_r = [String]()

    let currentUid:String = Auth.auth().currentUser!.uid
    let ref = Database.database().reference()
    var selectedText: String?
    var selectedDate: String?
    var selectedTime: String?
    var selectedSpeciality: String?
    var selectedQAContent: String?
    var selectedUserNameQuestion: String?
    var selectedUid: String?

    override func viewDidLoad() {
        sampleTableView1.dataSource = self
        sampleTableView1.delegate = self
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
       loadData_Firebase()
       super.viewWillAppear(animated)
    }

    func loadData_Firebase() {
        if QAContentArray1.isEmpty {
        }else{
            QANameArray1.removeAll()
            QAContentArray1.removeAll()
            QAStatusArray1.removeAll()
            DateArray1.removeAll()
            TimeArray1.removeAll()
            QASpecialityArray1.removeAll()
            uuidArray1.removeAll()
        }
                
        ref.child("QA").child(currentUid).child("public").observeSingleEvent(of: .value, with: {
            (snapshot) in
            if let snapdata = snapshot.value as? [String:NSDictionary]{
            for key in snapdata.keys.sorted(){
                let snap = snapdata[key]
                if let QAName = snap!["QAName"]{
                    self.QANameArray1.append(QAName as! String)
                    self.QANameArray1_r = self.QANameArray1.reversed()
                }
            }
            for key in snapdata.keys.sorted(){
                let snap = snapdata[key]
                if let QAContent = snap!["QAContent"]{
                    self.QAContentArray1.append(QAContent as! String)
                    self.QAContentArray1_r = self.QAContentArray1.reversed()
            }
            }
            for key in snapdata.keys.sorted(){
                let snap = snapdata[key]
                if let QAStatus = snap!["QAStatus"]{
                    self.QAStatusArray1.append(QAStatus as! String)
                    self.QAStatusArray1_r = self.QAStatusArray1.reversed()
                }
            }
            for key in snapdata.keys.sorted(){
                let snap = snapdata[key]
                if let date = snap!["date"]{
                    self.DateArray1.append(date as! String)
                    self.DateArray1_r = self.DateArray1.reversed()
                }
            }
            for key in snapdata.keys.sorted(){
                let snap = snapdata[key]
                if let time = snap!["time"]{
                    self.TimeArray1.append(time as! String)
                    self.TimeArray1_r = self.TimeArray1.reversed()
                }
            }
            for key in snapdata.keys.sorted(){
                let snap = snapdata[key]
                if let countAnswer = snap!["countAnswer"]{
                    self.countAnswerArray1.append(countAnswer as! String)
                    self.countAnswerArray1_r = self.countAnswerArray1.reversed()
                }
            }
            for key in snapdata.keys.sorted(){
                let snap = snapdata[key]
                if let speciality = snap!["QASpeciality"]{
                    self.QASpecialityArray1.append(speciality as! String)
                    self.QASpecialityArray1_r = self.QASpecialityArray1.reversed()
                }
            }
            for key in snapdata.keys.sorted(){
                let snap = snapdata[key]
                if let userName = snap!["userName"]{
                    self.userNameArray1.append(userName as! String)
                    self.userNameArray1_r = self.userNameArray1.reversed()
                }
            }
            for key in snapdata.keys.sorted(){
                    let snap = snapdata[key]
                    if let uuid = snap!["uuid"]{
                        self.uuidArray1.append(uuid as! String)
                        self.uuidArray1_r = self.uuidArray1.reversed()
                }
            }
            self.sampleTableView1.reloadData()
            }
        })
    }
     
    func numberOfSections(in tableView: UITableView) -> Int {
            return 1
    }
           
        //表示するcellの数を指定
       
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return QANameArray1.count
    }
           
        //cellのコンテンツ
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                let cell = self.sampleTableView1.dequeueReusableCell(withIdentifier: "mypage1", for: indexPath as IndexPath) as? QATableViewCell
                //質問（一般公開）テーブルビュー　sampleTableView0
                cell!.QAContent2_1.text = QAContentArray1_r[indexPath.row]
                cell!.date2_1.text = DateArray1_r[indexPath.row]//①
                cell!.time2_1.text = TimeArray1_r[indexPath.row]
                cell!.QASpeciality2_1.text = QASpecialityArray1_r[indexPath.row]
                cell!.countAnswer2_1.text = countAnswerArray1_r[indexPath.row]
                return cell!
    }
        //cellが選択された時の処理
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            selectedText = QANameArray1_r[indexPath.row]
            selectedDate = DateArray1_r[indexPath.row]
            selectedTime = TimeArray1_r[indexPath.row]
            selectedSpeciality = QASpecialityArray1_r[indexPath.row]
            selectedUserNameQuestion = userNameArray1_r[indexPath.row]
            selectedUid = uuidArray1_r[indexPath.row]
            selectedQAContent = QAContentArray1_r[indexPath.row]
            performSegue(withIdentifier: "mypage1", sender: nil)
    }
           
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
                if (segue.identifier == "mypage1") {
                    if #available(iOS 13.0, *) {
                        let selectedQAList: SelectedQAListViewController = segue.destination as! SelectedQAListViewController
                        // 11. SecondViewControllerのtextに選択した文字列を設定する
                        selectedQAList.text = self.selectedText!
                        selectedQAList.selectedDate = self.selectedDate!
                        selectedQAList.selectedTime = self.selectedTime!
                        selectedQAList.selectedSpeciality = self.selectedSpeciality!
                        selectedQAList.selectedQAContent = self.selectedQAContent!
                        selectedQAList.selectedUserNameQuestion = self.selectedUserNameQuestion!
                        selectedQAList.selectedUid = self.selectedUid!
                    } else {
                        // Fallback on earlier versions
                    }
                }
            }
            

            @IBAction func doUnwind(segue: UIStoryboardSegue) {}


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


}
