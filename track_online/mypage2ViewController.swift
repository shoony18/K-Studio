//
//  mypage2ViewController.swift
//  track_online
//
//  Created by 刈田修平 on 2020/06/22.
//  Copyright © 2020 刈田修平. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class mypage2ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var sampleTableView2: UITableView!
    var QANameArray2 = [String]()
    var QAContentArray2 = [String]()
    var QAStatusArray2 = [String]()
    var QASpecialityArray2 = [String]()
    var TimeArray2 = [String]()
    var DateArray2 = [String]()
    var userNameArray2 = [String]()
    var uuidArray2 = [String]()
    var countAnswerArray2 = [String]()
    var QANameArray2_r = [String]()
    var QAContentArray2_r = [String]()
    var QAStatusArray2_r = [String]()
    var QASpecialityArray2_r = [String]()
    var TimeArray2_r = [String]()
    var DateArray2_r = [String]()
    var userNameArray2_r = [String]()
    var uuidArray2_r = [String]()
    var countAnswerArray2_r = [String]()

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
        sampleTableView2.dataSource = self
        sampleTableView2.delegate = self
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
       loadData_Firebase()
       super.viewWillAppear(animated)
    }

    func loadData_Firebase() {
        if QAContentArray2.isEmpty {
        }else{
            QANameArray2.removeAll()
            QAContentArray2.removeAll()
            QAStatusArray2.removeAll()
            DateArray2.removeAll()
            TimeArray2.removeAll()
            QASpecialityArray2.removeAll()
        }
        ref.child("QA").child(currentUid).child("private").observeSingleEvent(of: .value, with: {
            (snapshot) in
            if let snapdata = snapshot.value as? [String:NSDictionary]{
            for key in snapdata.keys.sorted(){
                let snap = snapdata[key]
                if let QAName = snap!["QAName"]{
                    self.QANameArray2.append(QAName as! String)
                    self.QANameArray2_r = self.QANameArray2.reversed()
                }
            }
            for key in snapdata.keys.sorted(){
                let snap = snapdata[key]
                if let QAContent = snap!["QAContent"]{
                    self.QAContentArray2.append(QAContent as! String)
                    self.QAContentArray2_r = self.QAContentArray2.reversed()
            }
            }
            for key in snapdata.keys.sorted(){
                let snap = snapdata[key]
                if let QAStatus = snap!["QAStatus"]{
                    self.QAStatusArray2.append(QAStatus as! String)
                    self.QAStatusArray2_r = self.QAStatusArray2.reversed()
                }
            }
            for key in snapdata.keys.sorted(){
                let snap = snapdata[key]
                if let date = snap!["date"]{
                    self.DateArray2.append(date as! String)
                    self.DateArray2_r = self.DateArray2.reversed()
                }
            }
            for key in snapdata.keys.sorted(){
                let snap = snapdata[key]
                if let time = snap!["time"]{
                    self.TimeArray2.append(time as! String)
                    self.TimeArray2_r = self.TimeArray2.reversed()
                }
            }
            for key in snapdata.keys.sorted(){
                    let snap = snapdata[key]
                    if let countAnswer = snap!["countAnswer"]{
                        self.countAnswerArray2.append(countAnswer as! String)
                        self.countAnswerArray2_r = self.countAnswerArray2.reversed()
                }
            }
            for key in snapdata.keys.sorted(){
                let snap = snapdata[key]
                if let speciality = snap!["QASpeciality"]{
                    self.QASpecialityArray2.append(speciality as! String)
                    self.QASpecialityArray2_r = self.QASpecialityArray2.reversed()
                }
            }
            for key in snapdata.keys.sorted(){
                let snap = snapdata[key]
                if let userName = snap!["userName"]{
                    self.userNameArray2.append(userName as! String)
                    self.userNameArray2_r = self.userNameArray2.reversed()
                }
            }
            for key in snapdata.keys.sorted(){
                    let snap = snapdata[key]
                    if let uuid = snap!["uuid"]{
                        self.uuidArray2.append(uuid as! String)
                        self.uuidArray2_r = self.uuidArray2.reversed()
                }
            }
            self.sampleTableView2.reloadData()
            }
        }
        )
    }
     
    func numberOfSections(in tableView: UITableView) -> Int {
            return 1
    }
           
        //表示するcellの数を指定
       
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return QANameArray2.count
    }
           
        //cellのコンテンツ
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                let cell = self.sampleTableView2.dequeueReusableCell(withIdentifier: "mypage2", for: indexPath as IndexPath) as? QATableViewCell
                cell!.QAContent2_2.text = QAContentArray2_r[indexPath.row]
                cell!.date2_2.text = DateArray2_r[indexPath.row]//①
                cell!.time2_2.text = TimeArray2_r[indexPath.row]
                cell!.QASpeciality2_2.text = QASpecialityArray2_r[indexPath.row]
                cell!.countAnswer2_2.text = countAnswerArray2_r[indexPath.row]
                return cell!
    }
        //cellが選択された時の処理
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            selectedText = QANameArray2_r[indexPath.row]
            selectedDate = DateArray2_r[indexPath.row]
            selectedTime = TimeArray2_r[indexPath.row]
            selectedSpeciality = QASpecialityArray2_r[indexPath.row]
            selectedUserNameQuestion = userNameArray2_r[indexPath.row]
            selectedUid = uuidArray2_r[indexPath.row]
            selectedQAContent = QAContentArray2_r[indexPath.row]
            performSegue(withIdentifier: "mypage2", sender: nil)
    }
           
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
                if (segue.identifier == "mypage2") {
                    if #available(iOS 13.0, *) {
                        let selectedQAList: SelectedQAList2ViewController = segue.destination as! SelectedQAList2ViewController
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
