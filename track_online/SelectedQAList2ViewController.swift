//
//  SelectedQAList2ViewController.swift
//  track_online
//
//  Created by 刈田修平 on 2020/06/13.
//  Copyright © 2020 刈田修平. All rights reserved.
//

import UIKit
import AVKit
import Firebase
import FirebaseStorage
import AVFoundation
import MobileCoreServices
import AssetsLibrary
import SDWebImage

class SelectedQAList2ViewController: UIViewController,UITextViewDelegate,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var selectedText: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var speciality: UILabel!
    @IBOutlet weak var goodButton: UIButton!
    @IBOutlet weak var badButton: UIButton!
    @IBOutlet weak var userQAText: UILabel!
    @IBOutlet weak var UIimageView: UIImageView!
    @IBOutlet weak var PlayButton: UIButton!
    @IBOutlet weak var shadowView1: UIView!
    @IBOutlet weak var shadowView2: UIView!
    @IBOutlet weak var shadowView3: UIView!
    @IBOutlet weak var sankouURL: UITextView!
    @IBOutlet weak var editQA: UIButton!
    @IBOutlet weak var userNameQuestion: UILabel!
    @IBOutlet weak var mypageUserAnswerTableView: UITableView!
    @IBOutlet weak var contentView: UIView!
    
    var roomArray = [String]()
    //    var player: AVPlayer?
    let bundleDataType: String = "mp4"
    var text: String?
    var cache: String?
    var selectedDate: String?
    var selectedTime: String?
    var selectedSpeciality: String?
    var selectedQAContent: String?
    var selectedUserNameQuestion: String?
    var selectedUid: String?
    var playUrl:NSURL?
    var attachedUrl:NSURL?
    let currentUid:String = Auth.auth().currentUser!.uid
    var goodButtonValue:String?
    var badButtonValue:String?
    var fromUidArray = [String]()
    var answerArray = [String]()
    var sankouURLArray = [String]()
    var userNameAnswerArray = [String]()
    var TimeArray = [String]()
    var DateArray = [String]()
    var goodButtonArray = [String]()

    override func viewDidLoad() {
        mypageUserAnswerTableView.dataSource = self
        mypageUserAnswerTableView.delegate = self

        self.PlayButton.isHidden = true
        userQuestion()
        download()
        let label = UILabel(frame: .zero)
        label.lineBreakMode = .byWordWrapping
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
     override func viewWillAppear(_ animated: Bool) {
        userNameAnswerArray.removeAll()
        answerArray.removeAll()
        DateArray.removeAll()
        TimeArray.removeAll()
        sankouURLArray.removeAll()
        userQuestion()
        userAnswer()
        download()
        self.contentView.addSubview(UIimageView)
        self.contentView.sendSubviewToBack(UIimageView);
        super.viewWillAppear(animated)
     }
     func textView(_ textView: UITextView,
                  shouldInteractWith URL: URL,
                  in characterRange: NSRange,
                  interaction: UITextItemInteraction) -> Bool {

        UIApplication.shared.open(URL)

        return false
    }

    func numberOfSections(in myTableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ myTableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userNameAnswerArray.count
    }

    func tableView(_ myTableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.mypageUserAnswerTableView.dequeueReusableCell(withIdentifier: "TableViewCell4", for: indexPath as IndexPath) as? QATableViewCell
        cell!.userNameAnswer2_2_2.text = self.userNameAnswerArray[indexPath.row] //①
        cell!.answer2_2_2.text = self.answerArray[indexPath.row]
        cell!.date2_2_2.text = self.DateArray[indexPath.row] //①
        cell!.time2_2_2.text = self.TimeArray[indexPath.row] //①
//        cell!.goodButton2_2_2.setImage(UIImage(named: "goodButton\(goodButtonArray[indexPath.row])"), for: .normal)
//        cell?.goodButton2_2_2.addTarget(self, action: #selector(tapCellButton(_:)), for: .touchUpInside)
//        //タグを設定
//        cell!.goodButton2_2_2.tag = indexPath.row
        cell!.sankouURL2_2_2.text = self.sankouURLArray[indexPath.row]
        let key = self.sankouURLArray[indexPath.row]
        if key != ""{
            let attributedString = NSMutableAttributedString(string: key)
            attributedString.addAttribute(.link,value: key,range: NSString(string: key).range(of: key))
            cell!.sankouURL2_2_2.attributedText = attributedString
            cell!.sankouURL2_2_2.isSelectable = true
            cell!.sankouURL2_2_2.isEditable = false
        //        self.sankouURL.delegate = self as UITextViewDelegate
        }
        
        cell!.goodButton2_2_2.setImage(UIImage(named: "goodButton\(goodButtonArray[indexPath.row])"), for: .normal)
        let ref0 = Database.database().reference().child("QA").child("public").child("\(self.selectedSpeciality!)").child("\(self.text!)").child("trackAnswer").child("\(self.fromUidArray[indexPath.row])")

        ref0.observeSingleEvent(of: .value, with: {(snapshot) in
            let value = snapshot.value as? NSDictionary
            let key = value?["goodButton"] as? String ?? ""
            self.goodButtonValue = key
        })
        cell?.goodButton2_2_2.addTarget(self, action: #selector(tapCellButton(_:)), for: .touchUpInside)
        //タグを設定
        cell!.goodButton2_2_2.tag = indexPath.row


        return cell!
    }
    @objc func tapCellButton(_ sender: UIButton) {
        let ref0 = Database.database().reference().child("QA").child("private").child("\(selectedSpeciality!)").child("\(text!)").child("trackAnswer").child("\(fromUidArray[sender.tag])")
        let ref1 = Database.database().reference().child("QA").child("private").child("全て").child("\(text!)").child("trackAnswer").child("\(fromUidArray[sender.tag])")
        let ref2 = Database.database().reference().child("QA").child("\(fromUidArray[sender.tag])").child("goodButton").child("\(self.currentUid)").childByAutoId()
        ref0.observeSingleEvent(of: .value, with: {(snapshot) in
            let value = snapshot.value as? NSDictionary
            let key = value?["goodButton"] as? String ?? ""
            self.goodButtonValue = key
            print("\(self.goodButtonValue!)")
            if self.goodButtonValue == "0"{
                let data1 = ["goodButton":"1"];
                ref0.updateChildValues(data1)
                ref1.updateChildValues(data1)
                ref2.updateChildValues(data1)
                self.userNameAnswerArray.removeAll()
                self.answerArray.removeAll()
                self.DateArray.removeAll()
                self.TimeArray.removeAll()
                self.sankouURLArray.removeAll()
                self.goodButtonArray.removeAll()
                self.userQuestion()
                self.userAnswer()
            }
            else if self.goodButtonValue == "1"{
                let data0 = ["goodButton":"0"];
                ref0.updateChildValues(data0)
                ref1.updateChildValues(data0)
                ref2.updateChildValues(data0)
                self.userNameAnswerArray.removeAll()
                self.answerArray.removeAll()
                self.DateArray.removeAll()
                self.TimeArray.removeAll()
                self.sankouURLArray.removeAll()
                self.goodButtonArray.removeAll()
                self.userQuestion()
                self.userAnswer()
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }

            
        func userAnswer(){
                let ref0 = Database.database().reference().child("QA").child("private").child("\(selectedSpeciality!)").child("\(text!)").child("trackAnswer")
                ref0.observeSingleEvent(of: .value, with: {
                    (snapshot) in
                    if let snapdata = snapshot.value as? [String:NSDictionary]{
                    for key in snapdata.keys.sorted(){
                        let snap = snapdata[key]
                        if let fromUid = snap!["fromUid"] as? String {
                        self.fromUidArray.append(fromUid)
                    }
                    }
                    for key in snapdata.keys.sorted(){
                        let snap = snapdata[key]
                        if let userNameAnswer = snap!["fromUserName"] as? String {
                        self.userNameAnswerArray.append(userNameAnswer)
                    }
                    }
                    for key in snapdata.keys.sorted(){
                        let snap = snapdata[key]
                        if let answer = snap!["answer"] as? String {
                        self.answerArray.append(answer)
                            print("\(self.answerArray)")
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
                        if let sankouURL = snap!["sankouURL"] as? String {
                            self.sankouURLArray.append(sankouURL)
                        }
                    }
                    for key in snapdata.keys.sorted(){
                        let snap = snapdata[key]
                        if let goodButton = snap!["goodButton"] as? String {
                            self.goodButtonArray.append(goodButton)
                        }
                    }
                    self.mypageUserAnswerTableView.reloadData()
                    }
                }
                )
        }

        func userQuestion(){
            date.text = selectedDate
            time.text = selectedTime
            speciality.text = selectedSpeciality
            userNameQuestion.text = selectedUserNameQuestion
            userQAText.text = selectedQAContent
            let ref0 = Database.database().reference().child("QA").child("\(currentUid)").child("private").child("\(text!)")


    //        let good_picture0 = UIImage(named: "hand.thumbsup")
    //        self.goodButton.setImage(good_picture0, for: .normal)
    //        let bad_picture0 = UIImage(named: "hand.thumbsdown")
    //        self.badButton.setImage(bad_picture0, for: .normal)

//            ref0.observeSingleEvent(of: .value, with: { (snapshot) in
//              // Get user value
//                let value = snapshot.value as? NSDictionary
//                let key = value?["sankouURL"] as? String ?? ""
//    //          self.trackAnswer.text = key
//    //            let baseString = "これは設定アプリへのリンクを含む文章です。\n\nこちらのリンクはGoogle検索です"
//                let attributedString = NSMutableAttributedString(string: key)
//                attributedString.addAttribute(.link,
//                                              value: key,
//                                              range: NSString(string: key).range(of: key))
//                self.sankouURL.attributedText = attributedString
//                // isSelectableをtrue、isEditableをfalseにする必要がある
//                // （isSelectableはデフォルトtrueだが説明のため記述）
//                self.sankouURL.isSelectable = true
//                self.sankouURL.isEditable = false
//                self.sankouURL.delegate = self as UITextViewDelegate
//                print("sankouURL")
//
//              // ...
//              }) { (error) in
//                print(error.localizedDescription)
//            }
//            ref0.observeSingleEvent(of: .value, with: {(snapshot) in
//                let value = snapshot.value as? NSDictionary
//                let key = value?["cache"] as? String ?? ""
//                self.cache = key
//            }) { (error) in
//                print(error.localizedDescription)
//            }
            ref0.observeSingleEvent(of: .value, with: {(snapshot) in
                let value = snapshot.value as? NSDictionary
                let key = value?["goodButton"] as? String ?? ""
                self.goodButtonValue = key
                print("\(self.goodButtonValue!)")
                if self.goodButtonValue == "1"{
                    print("\(key)")
                    let picture1 = UIImage(named: "hand.thumbsup.fill")
                    self.goodButton.setImage(picture1, for: .normal)
                    let picture0 = UIImage(named: "hand.thumbsdown")
                    self.badButton.setImage(picture0, for: .normal)
                }
            }) { (error) in
                print(error.localizedDescription)
            }
            ref0.observeSingleEvent(of: .value, with: {(snapshot) in
                let value = snapshot.value as? NSDictionary
                let key = value?["badButton"] as? String ?? ""
                self.badButtonValue = key
                print("\(self.badButtonValue!)")
                if self.badButtonValue == "1"{
                    print("badButton == 1")
                    let picture1 = UIImage(named: "hand.thumbsdown.fill")
                    self.goodButton.setImage(picture1, for: .normal)
                    let picture0 = UIImage(named: "hand.thumbsup")
                    self.badButton.setImage(picture0, for: .normal)
                }
            }) { (error) in
                print(error.localizedDescription)
            }
        }
        func download(){
            
            let textVideo:String = text!+".mp4"
            let textImage:String = text!+".png"
            let refVideo = Storage.storage().reference().child("QA").child("\(currentUid)").child("private").child(text!).child("\(textVideo)")
            print("\(refVideo)")
            refVideo.downloadURL{ url, error in
            if (error != nil) {
                print("QA添付動画なし")
                let imageView: UIImageView = self.UIimageView
                // Placeholder image
                let placeholderImage = UIImage(named: "rikujou_track_top.png")
                imageView.image = placeholderImage
            } else {
                self.playUrl = url as NSURL?
                print("download success!! URL:", url!)
                print("QA添付動画あり")
                self.PlayButton.isHidden = false
            }
            }
            if self.cache == "1"{
                SDImageCache.shared.clearMemory()
                SDImageCache.shared.clearDisk()
                let ref0 = Database.database().reference().child("QA").child("\(currentUid)").child("private").child("\(text!)")
                let data = ["cache":"0" as Any] as [String : Any]
                ref0.updateChildValues(data)

            }
            let refImage = Storage.storage().reference().child("QA").child("\(currentUid)").child("private").child(text!).child("\(textImage)")

            // Load the image using SDWebImage
            if UIimageView != nil {
                let imageView: UIImageView = self.UIimageView
            // Placeholder image
//                let placeholderImage = UIImage(named: "placeholder.png")
                imageView.sd_setImage(with: refImage, placeholderImage: nil)
            }

        }
        @IBAction func PlayButton(_ sender: Any) {
            let player = AVPlayer(url: playUrl! as URL
            )

            // Create a new AVPlayerViewController and pass it a reference to the player.
            let controller = AVPlayerViewController()
            controller.player = player

            // Modally present the player and call the player's play() method when complete.
            present(controller, animated: true) {
                controller.player!.play()
            }
        }
        
        @IBAction func removeQA(_ sender: Any) {
            // ① UIAlertControllerクラスのインスタンスを生成
            // タイトル, メッセージ, Alertのスタイルを指定する
            // 第3引数のpreferredStyleでアラートの表示スタイルを指定する
            let alert: UIAlertController = UIAlertController(title: "削除", message: "この質問を削除してもいいですか？\n消費したtrackポイントは返還されません。", preferredStyle:  UIAlertController.Style.alert)

            // ② Actionの設定
            // Action初期化時にタイトル, スタイル, 押された時に実行されるハンドラを指定する
            // 第3引数のUIAlertActionStyleでボタンのスタイルを指定する
            // OKボタン
            let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{
                // ボタンが押された時の処理を書く（クロージャ実装）
                (action: UIAlertAction!) -> Void in
                Database.database().reference().child("QA").child("\(self.currentUid)").child("private").child("\(self.text!)").removeValue()
                Database.database().reference().child("QA").child("private").child("\(self.selectedSpeciality!)").child("\(self.text!)").removeValue()
                Database.database().reference().child("QA").child("private").child("全て").child("\(self.text!)").removeValue()
                self.navigationController?.popViewController(animated: true)
                //            self.dismiss(animated: true, completion: nil)

                
                print("OK")
            })
            // キャンセルボタン
            let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel, handler:{
                // ボタンが押された時の処理を書く（クロージャ実装）
                (action: UIAlertAction!) -> Void in
                print("Cancel")
            })

            // ③ UIAlertControllerにActionを追加
            alert.addAction(cancelAction)
            alert.addAction(defaultAction)

            // ④ Alertを表示
            present(alert, animated: true, completion: nil)
        }
        
        
        /*
        // MARK: - Navigation

        // In a storyboard-based application, you will often want to do a little preparation before navigation
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            // Get the new view controller using segue.destination.
            // Pass the selected object to the new view controller.
        }
        */
        
        @IBAction func goodButtonTapped(_ sender: Any) {
            let ref0 = Database.database().reference().child("QA").child("\(self.currentUid)").child("private").child("\(self.text!)").child("trackanswer")
            let ref1 = Database.database().reference().child("QA").child("private").child("\(self.selectedSpeciality!)").child("\(self.text!)").child("trackanswer")
            let ref2 = Database.database().reference().child("QA").child("private").child("全て").child("\(self.text!)").child("trackanswer")
            ref0.observeSingleEvent(of: .value, with: {(snapshot) in
                let value = snapshot.value as? NSDictionary
                let key = value?["goodButton"] as? String ?? ""
                self.goodButtonValue = key
                print("\(self.goodButtonValue!)")
                if self.goodButtonValue == "0"{
                    let data1 = ["goodButton":"1","badButton":"0"];
                    ref0.updateChildValues(data1)
                    ref1.updateChildValues(data1)
                    ref2.updateChildValues(data1)
                    let picture1 = UIImage(named: "hand.thumbsup.fill")
                    let picture0 = UIImage(named: "hand.thumbsdown")
                    self.goodButton.setImage(picture1, for: .normal)
                    self.badButton.setImage(picture0, for: .normal)
                }
                else if self.goodButtonValue == "1"{
                    let data0 = ["goodButton":"0"];
                    ref0.updateChildValues(data0)
                    ref1.updateChildValues(data0)
                    ref2.updateChildValues(data0)
                    let picture0 = UIImage(named: "hand.thumbsup")
                    self.goodButton.setImage(picture0, for: .normal)
                }

            }) { (error) in
                print(error.localizedDescription)
            }
        }
        @IBAction func badButtonTapped(_ sender: Any) {
            let ref0 = Database.database().reference().child("QA").child("\(self.currentUid)").child("private").child("\(self.text!)").child("trackanswer")
            let ref1 = Database.database().reference().child("QA").child("private").child("\(self.selectedSpeciality!)").child("\(self.text!)").child("trackanswer")
            let ref2 = Database.database().reference().child("QA").child("private").child("全て").child("\(self.text!)").child("trackanswer")
            ref0.observeSingleEvent(of: .value, with: {(snapshot) in
                let value = snapshot.value as? NSDictionary
                let key = value?["badButton"] as? String ?? ""
                self.badButtonValue = key
                print("\(self.badButtonValue!)")
                if self.badButtonValue == "0"{
                    let data1 = ["goodButton":"0","badButton":"1"];
                    ref0.updateChildValues(data1)
                    ref1.updateChildValues(data1)
                    ref2.updateChildValues(data1)
                    let picture1 = UIImage(named: "hand.thumbsdown.fill")
                    let picture0 = UIImage(named: "hand.thumbsup")
                    self.badButton.setImage(picture1, for: .normal)
                    self.goodButton.setImage(picture0, for: .normal)
                }
                else if self.badButtonValue == "1"{
                    let data0 = ["badButton":"0"];
                    ref0.updateChildValues(data0)
                    ref1.updateChildValues(data0)
                    ref2.updateChildValues(data0)
                    let picture0 = UIImage(named: "hand.thumbsdown")
                    self.badButton.setImage(picture0, for: .normal)
                }

            }) { (error) in
                print(error.localizedDescription)
            }
        }
        @IBAction func editQA(_ sender: Any) {
            //        let ref0 = Database.database().reference().child("QA").child("\(currentUid)").child("\(text!)")
    //        ref0.observeSingleEvent(of: .value, with: { (snapshot) in
    //          // Get user value
    //          let value = snapshot.value as? NSDictionary
    //          let key = value?["trackAnswer"] as? String ?? ""
    //          self.trackAnswer.text = key
    //          // ...
    //          }) { (error) in
    //            print(error.localizedDescription)
    //        }
            if selectedUid == currentUid{
                if userNameAnswerArray.isEmpty{
               
                    let SelectedQAListEdit = self.storyboard?.instantiateViewController(withIdentifier: "editQA2") as! SelectedQAListEdit2ViewController
                    SelectedQAListEdit.text = text
                    SelectedQAListEdit.selectedspeciality = selectedSpeciality
                    SelectedQAListEdit.selectedQAContent = selectedQAContent
                    SelectedQAListEdit.selectedUid = selectedUid
                    print("質問の編集")
                    self.navigationController?.pushViewController(SelectedQAListEdit, animated: true)
                }else{
                    let alert: UIAlertController = UIAlertController(title: "確認", message: "既に回答があるため編集できません", preferredStyle:  UIAlertController.Style.alert)

                                let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{
                                    (action: UIAlertAction!) -> Void in
                                })
                                alert.addAction(defaultAction)
                                present(alert, animated: true, completion: nil)
                
                }
                
            }
        }
}
