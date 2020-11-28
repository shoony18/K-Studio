//
//  MenuViewController.swift
//  track_online
//
//  Created by 刈田修平 on 2020/11/21.
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

class MenuViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var menuArray = ["プロフィール情報","QA（質問）","QA（回答）","プレミアム質問","利用規約"]


    @IBOutlet var menuView: UIView!
    @IBOutlet var TableView: UITableView!
    @IBOutlet var userName: UILabel!
    @IBOutlet var pointText: UILabel!
    
    let currentUid:String = Auth.auth().currentUser!.uid
    let currentUserName:String = Auth.auth().currentUser!.displayName!
    let Ref = Database.database().reference()

    override func viewDidLoad() {
        UIApplication.shared.applicationIconBadgeNumber = 0
        loadData()
        TableView.dataSource = self
        TableView.delegate = self
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.TableView.reloadData()
        super.viewWillAppear(animated)
        
    }
    
    func loadData(){
        userName.text = "ようこそ、 "+"\(currentUserName)"+" さん"

    }
    
    func numberOfSections(in myTableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ myTableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuArray.count
    }
                
       
    func tableView(_ myTableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = self.TableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath) as? menuTableViewCell
        cell!.menu.text = self.menuArray[indexPath.row]
        return cell!
    }
        

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0{
            performSegue(withIdentifier: "myProfile", sender: nil)
        }else if indexPath.row == 1{
            performSegue(withIdentifier: "mypage1", sender: nil)
        }else if indexPath.row == 2{
            performSegue(withIdentifier: "mypage3", sender: nil)
        }else if indexPath.row == 3{
            performSegue(withIdentifier: "premiumQA", sender: nil)
        }else if indexPath.row == 4{
            performSegue(withIdentifier: "appRule", sender: nil)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
    }

    // メニューエリア以外タップ時の処理
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        for touch in touches {
            if touch.view?.tag == 1 {
                UIView.animate(
                    withDuration: 0.2,
                    delay: 0,
                    options: .curveEaseIn,
                    animations: {
                        self.menuView.layer.position.x = -self.menuView.frame.width
                },
                    completion: { bool in
                        self.dismiss(animated: true, completion: nil)
                }
                )
            }
        }
    }
}
