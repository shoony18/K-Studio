//
//  premiumMyPostListViewController.swift
//  track_online
//
//  Created by 刈田修平 on 2020/10/04.
//  Copyright © 2020 刈田修平. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import Firebase
import FirebaseStorage
import FirebaseMessaging
import Photos
import MobileCoreServices
import AssetsLibrary

class premiumMyPostListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet var TableView: UITableView!
    
    var postIDArray = [String]()
    var dateArray = [String]()
    var timeArray = [String]()
    var eventArray = [String]()
    var answerFlagArray = [String]()
    var memoArray = [String]()
    
    var postIDArray_re = [String]()
    var dateArray_re = [String]()
    var timeArray_re = [String]()
    var eventArray_re = [String]()
    var answerFlagArray_re = [String]()
    var memoArray_re = [String]()
    
    var selectedPostID: String?
    
    let imagePickerController = UIImagePickerController()
    var cache: String?
    var videoURL: URL?
    var data:Data?
    var pickerview: UIPickerView = UIPickerView()
    
    let currentUid:String = Auth.auth().currentUser!.uid
    let currentUserName:String = Auth.auth().currentUser!.displayName!
    let Ref = Database.database().reference()
    
    override func viewDidLoad() {
        TableView.dataSource = self
        TableView.delegate = self
        
        loadData()
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.TableView.reloadData()
    }
    func loadData(){
        postIDArray.removeAll()
        dateArray.removeAll()
        timeArray.removeAll()
        eventArray.removeAll()
        answerFlagArray.removeAll()
        memoArray.removeAll()
        
        postIDArray_re.removeAll()
        dateArray_re.removeAll()
        timeArray_re.removeAll()
        eventArray_re.removeAll()
        answerFlagArray_re.removeAll()
        memoArray_re.removeAll()
        
        Ref.child("purchase").child("premium").child("uuid").child("\(self.currentUid)").child("post").observeSingleEvent(of: .value, with: {(snapshot) in
            if let snapdata = snapshot.value as? [String:NSDictionary]{
                for key in snapdata.keys.sorted(){
                    let snap = snapdata[key]
                    if let key = snap!["postID"] as? String {
                        self.postIDArray.append(key)
                        self.postIDArray_re = self.postIDArray.reversed()
                        self.TableView.reloadData()
                    }
                }
                for key in snapdata.keys.sorted(){
                    let snap = snapdata[key]
                    if let key = snap!["date"] as? String {
                        self.dateArray.append(key)
                        self.dateArray_re = self.dateArray.reversed()
                        self.TableView.reloadData()
                    }
                }
                for key in snapdata.keys.sorted(){
                    let snap = snapdata[key]
                    if let key = snap!["time"] as? String {
                        self.timeArray.append(key)
                        self.timeArray_re = self.timeArray.reversed()
                        self.TableView.reloadData()
                    }
                }
                for key in snapdata.keys.sorted(){
                    let snap = snapdata[key]
                    if let key = snap!["event"] as? String {
                        self.eventArray.append(key)
                        self.eventArray_re = self.eventArray.reversed()
                        self.TableView.reloadData()
                    }
                }
                for key in snapdata.keys.sorted(){
                    let snap = snapdata[key]
                    if let key = snap!["answerFlag"] as? String {
                        self.answerFlagArray.append(key)
                        self.answerFlagArray_re = self.answerFlagArray.reversed()
                        self.TableView.reloadData()
                    }
                }
                for key in snapdata.keys.sorted(){
                    let snap = snapdata[key]
                    if let key = snap!["memo"] as? String {
                        self.memoArray.append(key)
                        self.memoArray_re = self.memoArray.reversed()
                        self.TableView.reloadData()
                    }
                }
            }
        })
    }
    
    func numberOfSections(in myTableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ myTableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postIDArray_re.count
    }
    
    
    func tableView(_ myTableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print(postIDArray_re)
        
        let cell = self.TableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath) as? premiumMyPostListTableViewCell
        cell!.title.text = self.memoArray_re[indexPath.row]
        cell!.date.text = self.dateArray_re[indexPath.row]
        cell!.time.text = self.timeArray_re[indexPath.row]
        cell!.event.text = self.eventArray_re[indexPath.row]
        if self.answerFlagArray_re[indexPath.row] == "1"{
            cell!.status.text = "回答あり"
            cell!.status.backgroundColor = UIColor(red: 235/255, green: 109/255, blue: 113/255, alpha: 1)
        }else{
            cell!.status.text = "回答待ち"
            cell!.status.backgroundColor = UIColor(red: 25/255, green: 86/255, blue: 154/255, alpha: 1)
        }
        
        let textImage:String = self.postIDArray_re[indexPath.row]+".png"
        let refImage = Storage.storage().reference().child("purchase").child("premium").child("uuid").child("\(self.currentUid)").child("post").child("\(self.postIDArray_re[indexPath.row])").child("\(textImage)")
        cell!.ImageView.sd_setImage(with: refImage, placeholderImage: nil)
        return cell!
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedPostID = postIDArray_re[indexPath.row]
        performSegue(withIdentifier: "selectedPost", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "selectedPost") {
            if #available(iOS 13.0, *) {
                let nextData: premiumSelectedMyPostViewController = segue.destination as! premiumSelectedMyPostViewController
                nextData.selectedPostID = self.selectedPostID!
            } else {
                // Fallback on earlier versions
            }
        }
    }
}
