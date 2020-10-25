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

class QAAllListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
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
//    fileprivate let refreshCtl = UIRefreshControl()
//    var bilibili = true

    override func viewDidLoad() {
        firstLoginChecked()
        loadData_Firebase(selectedIndex:settingIndex)
        createHeaderView()
        myTableView.dataSource = self
        myTableView.delegate = self
        myTableView.contentInset.top = 30 //ヘッダーの高さ分下げる
        scrollView.delegate = self as UIScrollViewDelegate
//        myTableView.refreshControl = refreshControl
//        refreshControl.addTarget(self, action: #selector(QAAllListViewController.refreshControlValueChanged(sender:)), for: .valueChanged)
//        myTableView.addSubview(refreshControl)
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        firstLoginChecked()
        self.myTableView.reloadData()
//       loadData_Firebase(selectedIndex:settingIndex)
       super.viewWillAppear(animated)
    }
//    @objc func refreshControlValueChanged(sender: UIRefreshControl) {
//        print(settingIndex)
//        loadData_Firebase(selectedIndex:settingIndex)
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//            self.myTableView.reloadData()
//            self.refreshControl.endRefreshing()
//        }
//    }
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
//                        self.QANameArray0 = self.QANameArray.reversed()
//                        if self.QANameArray.count >= number{
//                            break
//                        }
                    }
                }
                for key in snapdata.keys.sorted(){
                    let snap = snapdata[key]
                    if let QAContent = snap!["QAContent"] as? String {
                        self.QAContentArray.append(QAContent)
//                        self.QAContentArray0 = self.QAContentArray.reversed()
//                        if self.QAContentArray.count >= number{
//                            break
//                        }

                    }
                }
//                for key in snapdata.keys.sorted(){
//                    let snap = snapdata[key]
//                    if let QAStatus = snap!["QAStatus"] as? String {
//                        self.QAStatusArray.append(QAStatus)
//                        self.QAStatusArray.append(QAStatus)
//                    }
//                }
                for key in snapdata.keys.sorted(){
                    let snap = snapdata[key]
                    if let date = snap!["date"] as? String {
                        self.DateArray.append(date)
//                        self.DateArray0 = self.DateArray.reversed()
//                        if self.DateArray.count >= number{
//                            break
//                        }
                    }
                }
                for key in snapdata.keys.sorted(){
                    let snap = snapdata[key]
                    if let time = snap!["time"] as? String {
                        self.TimeArray.append(time)
//                        self.TimeArray0 = self.TimeArray.reversed()
//                        if self.TimeArray.count >= number{
//                            break
//                        }

                    }
                }
                for key in snapdata.keys.sorted(){
                    let snap = snapdata[key]
                    if let speciality = snap!["QASpeciality"] as? String {
                        self.QASpecialityArray.append(speciality)
//                        self.QASpecialityArray0 = self.QASpecialityArray.reversed()
//                        if self.QASpecialityArray.count >= number{
//                            break
//                        }
                    }
                }
                for key in snapdata.keys.sorted(){
                    let snap = snapdata[key]
                    if let userName = snap!["userName"] as? String {
                        self.userNameArray.append(userName)
//                        self.userNameArray0 = self.userNameArray.reversed()
//                        if self.userNameArray.count >= number{
//                            break
//                        }
                    }
                }
                for key in snapdata.keys.sorted(){
                    let snap = snapdata[key]
                    if let countAnswer = snap!["countAnswer"] as? String {
                        self.countAnswerArray.append(countAnswer)
//                        self.countAnswerArray0 = self.countAnswerArray.reversed()
//                        if self.countAnswerArray.count >= number{
//                            break
//                        }
                    }
                }
                for key in snapdata.keys.sorted(){
                    let snap = snapdata[key]
                    if let uuid = snap!["uuid"] as? String {
                        self.uuidArray.append(uuid)
//                        self.uuidArray0 = self.uuidArray.reversed()
//                        if self.uuidArray.count >= number{
//                            break
//                        }
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
            print(dataArray_r)
            print("プペル")
            for key in dataArray_r{
                self.QANameArray0.append(self.QANameArray[key])
                self.QAContentArray0.append(self.QAContentArray[key])
                self.DateArray0.append(self.DateArray[key])
                self.TimeArray0.append(self.TimeArray[key])
                self.QASpecialityArray0.append(self.QASpecialityArray[key])
                self.userNameArray0.append(self.userNameArray[key])
                self.countAnswerArray0.append(self.countAnswerArray[key])
                self.uuidArray0.append(self.uuidArray[key])
                print("MUP")
                print(self.QANameArray0)
            }
            self.myTableView.reloadData()
            
        })
        
        
    }

    
    func numberOfSections(in myTableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ myTableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        QANameArray.count
//        return QANameArray.count

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
        print("yeah")
        return cell!
    }
    
    //cellが選択された時の処理
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("\(indexPath.row)番セルが押されたよ！")
        selectedText = QANameArray0[indexPath.row]
        print(selectedText!)
        selectedDate = DateArray0[indexPath.row]
        selectedTime = TimeArray0[indexPath.row]
        selectedSpeciality = QASpecialityArray0[indexPath.row]
        selectedUserNameQuestion = userNameArray0[indexPath.row]
        selectedUid = uuidArray0[indexPath.row]
//        ref.child("QA").child("public").child("\(selectedText!)").observe(.value) { (snap: DataSnapshot) in
//            //処理したい内容
//
//            print((snap.value! as AnyObject).description as Any)
//            if ((snap.value! as AnyObject).description as String) == "QAStatus1.png"{
//                let data = ["QAStatus": "QAStatus2.png"]
//                self.ref.child("QA").child(self.currentUid).child("\(self.selectedText!)").updateChildValues(data)
//                print("QAStatus変わったよ！")
//                UIApplication.shared.applicationIconBadgeNumber = 0
//            }
//        }
        performSegue(withIdentifier: "selectedQAAllList", sender: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
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


}
extension QAAllListViewController {
    private func createHeaderView() {
        let displayWidth: CGFloat! = self.view.frame.width
        // 上に余裕を持たせている（後々アニメーションなど追加するため）
        myHeaderView = UIView(frame: CGRect(x: 0, y: -230, width: displayWidth, height: 230))
        myHeaderView.alpha = 1
//        myHeaderView.backgroundColor = UIColor(red: 142/255, green: 237/255, blue: 220/255, alpha: 1)
        myTableView.addSubview(myHeaderView)
        scrollView = UIScrollView(frame: CGRect(x: 0, y: 200, width: displayWidth, height: 30))
        scrollView.bounces = false
        scrollView.alwaysBounceHorizontal = false
        scrollView.alwaysBounceVertical = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.backgroundColor = UIColor(red: 235/255, green: 147/255, blue: 106/255, alpha: 1)
        makeScrollMenu(scrollView: &scrollView)
        myHeaderView.addSubview(scrollView)
        scrollViewBar = UIView(frame: CGRect(x: 0, y: 225, width: 70, height: 5))
        scrollViewBar.backgroundColor = UIColor(red: 240/255, green: 177/255, blue: 160/255, alpha: 1)
        myHeaderView.addSubview(scrollViewBar)
//        let image = UIImageView(frame: CGRect(x: (displayWidth-100)/2, y: 100, width: 100, height: 100))
//        if bilibili {
//            image.image = UIImage(named: "bili2")
//        } else {
//            image.image = UIImage(named: "bili")
//        }
//        myHeaderView.addSubview(image)
    }
    
//    private func updateHeaderView() {
//        let displayWidth: CGFloat! = self.view.frame.width
//        self.myHeaderView.subviews[2].removeFromSuperview()
//        let image = UIImageView(frame: CGRect(x: (displayWidth-100)/2, y: 100, width: 100, height: 100))
//        if bilibili {
//            image.image = UIImage(named: "bili2")
//        } else {
//            image.image = UIImage(named: "bili")
//        }
//        myHeaderView.addSubview(image)
//    }
    
//    func addHeaderViewGif() {
//        let displayWidth: CGFloat! = self.view.frame.width
//        let image = UIImageView(frame: CGRect(x: (displayWidth-100)/2, y: 100, width: 100, height: 100))
////        if bilibili {
////            image.loadGif(name: "bili2")
////        } else {
////            image.loadGif(name: "bili")
////        }
//        myHeaderView.addSubview(image)
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//            self.myHeaderView.subviews[2].removeFromSuperview()
//        }
//    }
    
    func makeScrollMenu(scrollView: inout(UIScrollView)) {
        let menuLabelWidth:CGFloat = 70
        let titles = Data.TitleMenu
        let menuLabelHeight:CGFloat = scrollView.frame.height
        var X: CGFloat = 0
        var count = 1
        for title in titles {
            let scrollViewLabel = UILabel()
            scrollViewLabel.textAlignment = .center
            scrollViewLabel.frame = CGRect(x:X, y:0, width:menuLabelWidth, height:menuLabelHeight)
            scrollViewLabel.text = title
            scrollViewLabel.isUserInteractionEnabled = true
            scrollViewLabel.tag = count
            scrollView.addSubview(scrollViewLabel)
            X += menuLabelWidth
            count += 1
            scrollViewLabelArray.append(scrollViewLabel)
        }
        changeColorScrollViewLabel(tag: 1)
        scrollView.contentSize = CGSize(width:X, height:menuLabelHeight)
    }
    
    private func changeColorScrollViewLabel(tag: Int) {
        for label in scrollViewLabelArray {
            if label.tag == tag {
                label.textColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
            } else {
                label.textColor = .white
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.next?.touchesBegan(touches, with: event)
        print("touch")
        for touch: AnyObject in touches {
            let t: UITouch = touch as! UITouch
            guard t.view is UILabel else {
                return
            }
            switch t.view!.tag {
            case 1:
                print(1)
                UIView.animate(withDuration: 0.3, delay: 0.0, options: [],animations: {
                    self.scrollViewBar.frame.origin.x = t.view!.frame.origin.x - self.scrollView.contentOffset.x
                }, completion: nil)
                changeColorScrollViewLabel(tag: 1)
                Data.setIndex(v: 0)
                print("hoo")
                print(Data.setIndex(v: 0))
                settingIndex = 0
                loadData_Firebase(selectedIndex:0)
                myTableView.reloadData()
            case 2:
                print(2)
                UIView.animate(withDuration: 0.3, delay: 0.0, options: [],animations: {
                    self.scrollViewBar.frame.origin.x = t.view!.frame.origin.x - self.scrollView.contentOffset.x
                }, completion: nil)
                changeColorScrollViewLabel(tag: 2)
                Data.setIndex(v: 1)
                settingIndex = 1
                loadData_Firebase(selectedIndex:1)
                myTableView.reloadData()
            case 3:
                print(3)
                UIView.animate(withDuration: 0.3, delay: 0.0, options: [],animations: {
                    self.scrollViewBar.frame.origin.x = t.view!.frame.origin.x - self.scrollView.contentOffset.x
                }, completion: nil)
                changeColorScrollViewLabel(tag: 3)
                Data.setIndex(v: 2)
                settingIndex = 2
                loadData_Firebase(selectedIndex:2)
                myTableView.reloadData()
            case 4:
                print(4)
                UIView.animate(withDuration: 0.3, delay: 0.0, options: [],animations: {
                    self.scrollViewBar.frame.origin.x = t.view!.frame.origin.x - self.scrollView.contentOffset.x
                }, completion: nil)
                changeColorScrollViewLabel(tag: 4)
                Data.setIndex(v: 3)
                settingIndex = 3
                loadData_Firebase(selectedIndex:3)
                myTableView.reloadData()
            case 5:
                print(5)
                UIView.animate(withDuration: 0.3, delay: 0.0, options: [],animations: {
                    self.scrollViewBar.frame.origin.x = t.view!.frame.origin.x - self.scrollView.contentOffset.x
                }, completion: nil)
                changeColorScrollViewLabel(tag: 5)
                Data.setIndex(v: 4)
                settingIndex = 4
                loadData_Firebase(selectedIndex:4)
                myTableView.reloadData()
            case 6:
                print(6)
                UIView.animate(withDuration: 0.3, delay: 0.0, options: [],animations: {
                    self.scrollViewBar.frame.origin.x = t.view!.frame.origin.x - self.scrollView.contentOffset.x
                }, completion: nil)
                changeColorScrollViewLabel(tag: 6)
                Data.setIndex(v: 5)
                settingIndex = 5
                loadData_Firebase(selectedIndex:5)
                myTableView.reloadData()
            case 7:
                print(7)
                UIView.animate(withDuration: 0.3, delay: 0.0, options: [],animations: {
                    self.scrollViewBar.frame.origin.x = t.view!.frame.origin.x - self.scrollView.contentOffset.x
                }, completion: nil)
                changeColorScrollViewLabel(tag: 7)
                Data.setIndex(v: 6)
                settingIndex = 6
                loadData_Firebase(selectedIndex:6)
                myTableView.reloadData()
            case 8:
                print(8)
                UIView.animate(withDuration: 0.3, delay: 0.0, options: [],animations: {
                    self.scrollViewBar.frame.origin.x = t.view!.frame.origin.x - self.scrollView.contentOffset.x
                }, completion: nil)
                changeColorScrollViewLabel(tag: 8)
                Data.setIndex(v: 7)
                settingIndex = 7
                loadData_Firebase(selectedIndex:7)
                myTableView.reloadData()
            default:
                break
            }
        }
    }
}

extension UIScrollView {
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.next?.touchesBegan(touches, with: event)
    }
}

