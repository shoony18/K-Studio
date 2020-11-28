//
//  QAAllListViewController.swift
//  track_online
//
//  Created by 刈田修平 on 2020/05/23.
//  Copyright © 2020 刈田修平. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import UserNotifications
import FirebaseMessaging

class QAAllListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource, UIApplicationDelegate {
    var scrollView: UIScrollView!
    var scrollViewBar: UIView!
    var myHeaderView: UIView!
    var lastContentOffset: CGFloat = 0
    var lastContentOffsetX: CGFloat = 0
    var scrollViewLabelArray: [UILabel] = []
    var QAArray = [String]()
    var QAList = [String]()
    var PointArray = [String]()
    var AllCountAnswerArray = [String]()
    
    var countAnswerArray = [String]()
    var QANameArray = [String]()
    var QAContentArray = [String]()
    var QAStatusArray = [String]()
    var TitleMenuArray = [String]()
    var userNameArray = [String]()
    var CountQuestion = Int()
    var CountAnswer = Int()
    var uuidArray = [String]()
    var QASpecialityArray = [String]()
    var TimeArray = [String]()
    var DateArray = [String]()
    
    var countAnswerArray0 = [String]()
    var QANameArray0 = [String]()
    var QAContentArray0 = [String]()
    var QAStatusArray0 = [String]()
    var TitleMenuArray0 = [String]()
    var userNameArray0 = [String]()
    var CountQuestion0 = Int()
    var CountAnswer0 = Int()
    var uuidArray0 = [String]()
    var QASpecialityArray0 = [String]()
    var TimeArray0 = [String]()
    var DateArray0 = [String]()
    
    let currentUid:String = Auth.auth().currentUser!.uid
    var selectedText: String?
    var selectedDate: String?
    var selectedTime: String?
    var selectedSpeciality: String?
    var selectedUserNameQuestion: String?
    var selectedUid: String?
    let ref = Database.database().reference()
    var settingIndex = Int()
    var firstLogin:String?
    let refreshControl = UIRefreshControl()
    
    
    struct data {
        let TitleMenu = ["最新","短距離","中距離","長距離","跳躍","投擲","混成","その他"]
        var index = 0
        mutating func setIndex(v: Int) {
            index = v
            print(TitleMenu[index])
        }
        func getTitle() -> String {
            return TitleMenu[index]
        }
    }
    var Data = data()
    
    @IBOutlet var myTableView: UITableView!
    
    override func viewDidLoad() {
        notificationSetting()
        loadData_Firebase(selectedIndex:settingIndex)
        myTableView.dataSource = self
        myTableView.delegate = self
        
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.myTableView.reloadData()
        //       loadData_Firebase(selectedIndex:settingIndex)
        super.viewWillAppear(animated)
    }
    func notificationSetting(){
        UNUserNotificationCenter.current().getNotificationSettings(completionHandler: {setting in
            if setting.authorizationStatus == .authorized {

                 let token:[String: AnyObject]=["fcmToken":Messaging.messaging().fcmToken as AnyObject,"fcmTokenStatus":"1" as AnyObject]
                 self.postToken(Token: token)
                 print("許可")
            }
            else {
                let token:[String: AnyObject]=["fcmToken":Messaging.messaging().fcmToken as AnyObject,"fcmTokenStatus":"0" as AnyObject]
                self.postToken(Token: token)
                print("未許可")
            }
         })
    }
    func postToken(Token:[String: AnyObject]){
        let currentUid:String = Auth.auth().currentUser!.uid
        print("FCM Token:\(Token)")
        let dbRef = Database.database().reference()
        dbRef.child("fcmToken").child(currentUid).setValue(Token)
    }
    @IBAction func refreshControl(_ sender: Any) {
        loadData_Firebase(selectedIndex:settingIndex)
    }
    func loadData_Firebase(selectedIndex:Int) {
        QANameArray.removeAll()
        countAnswerArray.removeAll()
        QAContentArray.removeAll()
        QAStatusArray.removeAll()
        DateArray.removeAll()
        TimeArray.removeAll()
        QASpecialityArray.removeAll()
        userNameArray.removeAll()
        uuidArray.removeAll()
        QANameArray0.removeAll()
        countAnswerArray0.removeAll()
        QAContentArray0.removeAll()
        QAStatusArray0.removeAll()
        DateArray0.removeAll()
        TimeArray0.removeAll()
        QASpecialityArray0.removeAll()
        userNameArray0.removeAll()
        uuidArray0.removeAll()
        
        var title = Data.TitleMenu[selectedIndex]
        if Data.TitleMenu[selectedIndex] == "最新"{
            title = "全て"
        }
        ref.child("QA").child("public").child("\(title)").observeSingleEvent(of: .value, with: {
            (snapshot) in
            
            if let snapdata = snapshot.value as? [String:NSDictionary]{
                
                for key in snapdata.keys.sorted(){
                    let snap = snapdata[key]
                    if let QAName = snap!["QAName"] as? String {
                        self.QANameArray.append(QAName)
                    }
                }
                for key in snapdata.keys.sorted(){
                    let snap = snapdata[key]
                    if let QAContent = snap!["QAContent"] as? String {
                        self.QAContentArray.append(QAContent)
                    }
                }
                for key in snapdata.keys.sorted(){
                    let snap = snapdata[key]
                    if let date = snap!["date"] as? String {
                        self.DateArray.append(date)
                    }
                }
                for key in snapdata.keys.sorted(){
                    let snap = snapdata[key]
                    if let time = snap!["time"] as? String {
                        self.TimeArray.append(time)
                    }
                }
                for key in snapdata.keys.sorted(){
                    let snap = snapdata[key]
                    if let speciality = snap!["QASpeciality"] as? String {
                        self.QASpecialityArray.append(speciality)
                    }
                }
                for key in snapdata.keys.sorted(){
                    let snap = snapdata[key]
                    if let userName = snap!["userName"] as? String {
                        self.userNameArray.append(userName)
                    }
                }
                for key in snapdata.keys.sorted(){
                    let snap = snapdata[key]
                    if let countAnswer = snap!["countAnswer"] as? String {
                        self.countAnswerArray.append(countAnswer)
                    }
                }
                for key in snapdata.keys.sorted(){
                    let snap = snapdata[key]
                    if let uuid = snap!["uuid"] as? String {
                        self.uuidArray.append(uuid)
                    }
                }
            }
            let data = self.QANameArray.count
            var dataArray = [Int]()
            var dataArray_r = [Int]()
            for key in 0..<data{
                dataArray.append(key)
            }
            dataArray_r = dataArray.shuffled()
            for key in dataArray_r{
                self.QANameArray0.append(self.QANameArray[key])
                self.QAContentArray0.append(self.QAContentArray[key])
                self.DateArray0.append(self.DateArray[key])
                self.TimeArray0.append(self.TimeArray[key])
                self.QASpecialityArray0.append(self.QASpecialityArray[key])
                self.userNameArray0.append(self.userNameArray[key])
                self.countAnswerArray0.append(self.countAnswerArray[key])
                self.uuidArray0.append(self.uuidArray[key])
            }
            self.myTableView.reloadData()
        })
    }
    
    func numberOfSections(in myTableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ myTableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if QANameArray.count > 11{
            return 11
        }else{
            return QANameArray.count
        }
    }
    
    func tableView(_ myTableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.myTableView.dequeueReusableCell(withIdentifier: "TableViewCell1", for: indexPath as IndexPath) as? QATableViewCell
        cell!.QAContent1.text = self.QAContentArray0[indexPath.row] //①
        print(DateArray.count)
        cell!.date1.text = self.DateArray0[indexPath.row] //①
        cell!.time1.text = self.TimeArray0[indexPath.row] //①
        cell!.TextFieldGenre1.text = self.QASpecialityArray0[indexPath.row]
        cell!.userName1.text = self.userNameArray0[indexPath.row]
        cell!.countAnswer1.text = self.countAnswerArray0[indexPath.row]
        return cell!
    }
    
    //cellが選択された時の処理
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedText = QANameArray0[indexPath.row]
        print(selectedText!)
        selectedDate = DateArray0[indexPath.row]
        selectedTime = TimeArray0[indexPath.row]
        selectedSpeciality = QASpecialityArray0[indexPath.row]
        selectedUserNameQuestion = userNameArray0[indexPath.row]
        selectedUid = uuidArray0[indexPath.row]
        
        performSegue(withIdentifier: "selectedQAAllList", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "selectedQAAllList") {
            if #available(iOS 13.0, *) {
                let selectedQAALLList: SelectedQAAllListViewController = segue.destination as! SelectedQAAllListViewController
                // 11. SecondViewControllerのtextに選択した文字列を設定する
                print(selectedText as Any)
                print("chinatsu")
                selectedQAALLList.text = self.selectedText!
                selectedQAALLList.selectedDate = self.selectedDate!
                selectedQAALLList.selectedTime = self.selectedTime!
                selectedQAALLList.selectedSpeciality = self.selectedSpeciality!
                selectedQAALLList.selectedUserNameQuestion = self.selectedUserNameQuestion!
                selectedQAALLList.selectedUid = self.selectedUid!
            } else {
                // Fallback on earlier versions
            }
        }
    }

}
