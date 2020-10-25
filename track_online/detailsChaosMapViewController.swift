//
//  detailsChaosMapViewController.swift
//  track_online
//
//  Created by 刈田修平 on 2020/08/09.
//  Copyright © 2020 刈田修平. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class detailsChaosMapViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var IDArray = [String]()
    var typeImageArray = [String]()
    var nameArray = [String]()
    var belongArray = [String]()
    var PBArray = [String]()
    var championArray = [String]()
    var prizeArray = [String]()

    var selectedID: String?
    var selectedEvent: String?
    var selectedType: String?
    var selectedName: String?
    var selectedBelong: String?

    @IBOutlet weak var defToptier: UILabel!
    @IBOutlet weak var defKogou: UILabel!
    @IBOutlet weak var defSyouraisei: UILabel!
    @IBOutlet weak var defKenjitsu: UILabel!

    @IBOutlet weak var detailsChaosMapTableView: UITableView!
    
    override func viewDidLoad() {
        print("\(selectedEvent!)")
        loadData()
        detailsChaosMapTableView.dataSource = self
        detailsChaosMapTableView.delegate = self
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
            return 1
    }
           
        //表示するcellの数を指定
       
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nameArray.count
    }
           
        //cellのコンテンツ
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                let cell = self.detailsChaosMapTableView.dequeueReusableCell(withIdentifier: "detailsChaosMap", for: indexPath as IndexPath) as? chaosMapTableViewCell
                //質問（一般公開）テーブルビュー　sampleTableView0
                cell!.typeImage.image = UIImage(named:"\(typeImageArray[indexPath.row])")!
                cell!.name.text = nameArray[indexPath.row]
                cell!.belong.text = belongArray[indexPath.row]
                cell!.PB.text = PBArray[indexPath.row]
                cell!.champion.text = championArray[indexPath.row]
                cell!.prize.text = prizeArray[indexPath.row]
                return cell!
    }
        //cellが選択された時の処理
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedID = self.IDArray[indexPath.row]
        selectedName = self.nameArray[indexPath.row]
        selectedBelong = self.belongArray[indexPath.row]
        selectedType = self.typeImageArray[indexPath.row]
        performSegue(withIdentifier: "selectedAthlete", sender: nil)
    }
           
        
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "selectedAthlete") {
            if #available(iOS 13.0, *) {
                let selectedView: selectedAthleteViewController = segue.destination as! selectedAthleteViewController
                selectedView.selectedID = selectedID
                selectedView.selectedEvent = selectedEvent
                selectedView.selectedName = selectedName
                selectedView.selectedBelong = selectedBelong
                selectedView.selectedType = selectedType
            } else {
            }
        }
    }
    
    func loadData(){
        let ref = Database.database().reference()
        ref.child("column").child("chaosMap").child("\(selectedEvent!)").child("全て").observeSingleEvent(of: .value, with: {(snapshot) in
            if let snapdata = snapshot.value as? [String:NSDictionary]{
                for key in snapdata.keys.sorted(){
                    let snap = snapdata[key]
                    if let data = snap!["ID"] as? String {
                        self.IDArray.append(data)
                    }
                    self.detailsChaosMapTableView.reloadData()
                }
                for key in snapdata.keys.sorted(){
                    let snap = snapdata[key]
                    if let data = snap!["type"] as? String {
                        self.typeImageArray.append(data)
                        print(self.typeImageArray)
                    }
                    self.detailsChaosMapTableView.reloadData()
                }
                for key in snapdata.keys.sorted(){
                    let snap = snapdata[key]
                    if let data = snap!["name"] as? String {
                        self.nameArray.append(data)
                    }
                    self.detailsChaosMapTableView.reloadData()
                }
                for key in snapdata.keys.sorted(){
                    let snap = snapdata[key]
                    if let data = snap!["belong"] as? String {
                        self.belongArray.append(data)
                    }
                    self.detailsChaosMapTableView.reloadData()
                }
                for key in snapdata.keys.sorted(){
                    let snap = snapdata[key]
                    if let data = snap!["PB"] as? String {
                        self.PBArray.append(data)
                    }
                    self.detailsChaosMapTableView.reloadData()
                }
                for key in snapdata.keys.sorted(){
                    let snap = snapdata[key]
                    if let data = snap!["champion"] as? String {
                        self.championArray.append(data)
                    }
                    self.detailsChaosMapTableView.reloadData()
                }
                for key in snapdata.keys.sorted(){
                    let snap = snapdata[key]
                    if let data = snap!["prize"] as? String {
                        self.prizeArray.append(data)
                    }
                    self.detailsChaosMapTableView.reloadData()
                }
            }
        })
//        let ref1 = Database.database().reference().child("column").child("chaosMap").child("event").child("\(selectedEvent!)")
//        ref1.observeSingleEvent(of: .value, with: { (snapshot) in
//            let value = snapshot.value as? NSDictionary
//            let key = value?["defToptier"] as? String ?? ""
//            self.defToptier.text = key
//        }) { (error) in
//            print(error.localizedDescription)
//        }
//        ref1.observeSingleEvent(of: .value, with: { (snapshot) in
//            let value = snapshot.value as? NSDictionary
//            let key = value?["defKogou"] as? String ?? ""
//            self.defKogou.text = key
//        }) { (error) in
//            print(error.localizedDescription)
//        }
//        ref1.observeSingleEvent(of: .value, with: { (snapshot) in
//            let value = snapshot.value as? NSDictionary
//            let key = value?["defSyouraisei"] as? String ?? ""
//            self.defSyouraisei.text = key
//        }) { (error) in
//            print(error.localizedDescription)
//        }
//        ref1.observeSingleEvent(of: .value, with: { (snapshot) in
//            let value = snapshot.value as? NSDictionary
//            let key = value?["defKenjitsu"] as? String ?? ""
//            self.defKenjitsu.text = key
//        }) { (error) in
//            print(error.localizedDescription)
//        }
    }
}
