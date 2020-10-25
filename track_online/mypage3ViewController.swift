//
//  mypage3ViewController.swift
//  track_online
//
//  Created by 刈田修平 on 2020/06/12.
//  Copyright © 2020 刈田修平. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class mypage3ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var sampleTableView3: UITableView!
    var QANameArray3 = [String]()
    var QAContentArray3 = [String]()
    var QAStatusArray3 = [String]()
    var QASpecialityArray3 = [String]()
    var TimeArray3 = [String]()
    var DateArray3 = [String]()
    var userNameArray3 = [String]()
    var uuidArray3 = [String]()
    var answerArray3 = [String]()
    var countAnswerArray3 = [String]()
    var warningFlagArray3 = [String]()
    var goodButtonArray3 = [String]()

    var QANameArray3_r = [String]()
    var QAContentArray3_r = [String]()
    var QAStatusArray3_r = [String]()
    var QASpecialityArray3_r = [String]()
    var TimeArray3_r = [String]()
    var DateArray3_r = [String]()
    var userNameArray3_r = [String]()
    var uuidArray3_r = [String]()
    var answerArray3_r = [String]()
    var countAnswerArray3_r = [String]()
    var warningFlagArray3_r = [String]()
    var goodButtonArray3_r = [String]()

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
        sampleTableView3.dataSource = self
        sampleTableView3.delegate = self
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
       loadData_Firebase()
       super.viewWillAppear(animated)
    }

    func loadData_Firebase() {
        if QAContentArray3.isEmpty {
        }else{
            QANameArray3.removeAll()
            QAContentArray3.removeAll()
            QAStatusArray3.removeAll()
            DateArray3.removeAll()
            TimeArray3.removeAll()
            QASpecialityArray3.removeAll()
        }
        ref.child("QA").child(currentUid).child("public").child("answer").observeSingleEvent(of: .value, with: {
            (snapshot) in
            if let snapdata = snapshot.value as? [String:NSDictionary]{
            for key in snapdata.keys.sorted(){
                let snap = snapdata[key]
                if let QAName = snap!["QAName"]{
                    self.QANameArray3.append(QAName as! String)
                    self.QANameArray3_r = self.QANameArray3.reversed()
                }
            }
            for key in snapdata.keys.sorted(){
                let snap = snapdata[key]
                if let QAContent = snap!["QAContent"]{
                    self.QAContentArray3.append(QAContent as! String)
                    self.QAContentArray3_r = self.QAContentArray3.reversed()
            }
            }
            for key in snapdata.keys.sorted(){
                let snap = snapdata[key]
                if let Qdate = snap!["Qdate"]{
                    self.DateArray3.append(Qdate as! String)
                    self.DateArray3_r = self.DateArray3.reversed()
                }
            }
            for key in snapdata.keys.sorted(){
                let snap = snapdata[key]
                if let Qtime = snap!["Qtime"]{
                    self.TimeArray3.append(Qtime as! String)
                    self.TimeArray3_r = self.TimeArray3.reversed()
                }
            }
            for key in snapdata.keys.sorted(){
                    let snap = snapdata[key]
                    if let answer = snap!["answer"]{
                        self.answerArray3.append(answer as! String)
                        self.answerArray3_r = self.answerArray3.reversed()
                }
            }
            for key in snapdata.keys.sorted(){
                    let snap = snapdata[key]
                    if let countAnswer = snap!["countAnswer"]{
                        self.countAnswerArray3.append(countAnswer as! String)
                        self.countAnswerArray3_r = self.countAnswerArray3.reversed()
                }
            }
            for key in snapdata.keys.sorted(){
                let snap = snapdata[key]
                if let speciality = snap!["QASpeciality"]{
                    self.QASpecialityArray3.append(speciality as! String)
                    self.QASpecialityArray3_r = self.QASpecialityArray3.reversed()
                }
            }
            for key in snapdata.keys.sorted(){
                let snap = snapdata[key]
                if let userName = snap!["userName"]{
                    self.userNameArray3.append(userName as! String)
                    self.userNameArray3_r = self.userNameArray3.reversed()
                }
            }
            for key in snapdata.keys.sorted(){
                    let snap = snapdata[key]
                    if let uuid = snap!["uuid"]{
                        self.uuidArray3.append(uuid as! String)
                        self.uuidArray3_r = self.uuidArray3.reversed()
                }
            }
            for key in snapdata.keys.sorted(){
                    let snap = snapdata[key]
                    if let warningFlag = snap!["warningFlag"]{
                        self.warningFlagArray3.append(warningFlag as! String)
                        self.warningFlagArray3_r = self.warningFlagArray3.reversed()
                }
            }
//                for key in snapdata.keys.sorted(){
//                    let snap = snapdata[key]
//                    if let goodButton = snap!["goodButton"] as? String {
//                        self.goodButtonArray3.append(goodButton)
//                        self.goodButtonArray3_r = self.goodButtonArray3.reversed()
//                    }
//                }

            self.sampleTableView3.reloadData()
            }
        }
        )
    }
     
    func numberOfSections(in tableView: UITableView) -> Int {
            return 1
    }
           
        //表示するcellの数を指定
       
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return QANameArray3.count
    }
           
        //cellのコンテンツ
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.sampleTableView3.dequeueReusableCell(withIdentifier: "mypage3", for: indexPath as IndexPath) as? QATableViewCell
        cell!.QAContent2_3.text = QAContentArray3_r[indexPath.row]
        cell!.answer2_3.text = answerArray3_r[indexPath.row]
        cell!.date2_3.text = DateArray3_r[indexPath.row]//①
        cell!.time2_3.text = TimeArray3_r[indexPath.row]
        cell!.QASpeciality2_3.text = QASpecialityArray3_r[indexPath.row]
        cell!.countAnswer2_3.text = countAnswerArray3_r[indexPath.row]
//        cell!.goodButton2_3.setImage(UIImage(named: "goodButton\(goodButtonArray3_r[indexPath.row])"), for: .normal)
        cell!.flag2_3.setImage(UIImage(named: "warningFlag\(warningFlagArray3_r[indexPath.row])"), for: .normal)
        return cell!
    }
        //cellが選択された時の処理
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            selectedText = QANameArray3_r[indexPath.row]
            selectedDate = DateArray3_r[indexPath.row]
            selectedTime = TimeArray3_r[indexPath.row]
            selectedSpeciality = QASpecialityArray3_r[indexPath.row]
            selectedUserNameQuestion = userNameArray3_r[indexPath.row]
            selectedUid = uuidArray3_r[indexPath.row]
            selectedQAContent = QAContentArray3_r[indexPath.row]
            performSegue(withIdentifier: "mypage3", sender: nil)
    }
           
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
                if (segue.identifier == "mypage3") {
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
