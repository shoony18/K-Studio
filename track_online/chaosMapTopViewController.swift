//
//  chaosMapTopViewController.swift
//  track_online
//
//  Created by 刈田修平 on 2020/08/10.
//  Copyright © 2020 刈田修平. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class chaosMapTopViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var eventNameArray = [String]()
    var abstractArray = [String]()
    var selectedText: String?

    @IBOutlet weak var chaosMapTopTableView: UITableView!
    
    override func viewDidLoad() {
        loadData()
        chaosMapTopTableView.dataSource = self
        chaosMapTopTableView.delegate = self
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        eventNameArray.removeAll()
        abstractArray.removeAll()
        loadData()
        super.viewWillAppear(animated)
    }

     
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
               
            //表示するcellの数を指定
           
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventNameArray.count
    }
               
            //cellのコンテンツ
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.chaosMapTopTableView.dequeueReusableCell(withIdentifier: "chaosMapTop", for: indexPath as IndexPath) as? chaosMapTableViewCell
        cell!.event.text = eventNameArray[indexPath.row]
        cell!.abstract.text = abstractArray[indexPath.row]
        return cell!
    }
    
    //cellが選択された時の処理
       
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedText = eventNameArray[indexPath.row]
        performSegue(withIdentifier: "selectedChaosMap", sender: nil)
    }
        
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "selectedChaosMap") {
            if #available(iOS 13.0, *) {
                let selectedView: selectedChaosMapViewController = segue.destination as! selectedChaosMapViewController
                selectedView.eventName = self.selectedText!
            } else {
                            // Fallback on earlier versions
            }
        }
    }
       
    func loadData(){    
        let ref = Database.database().reference()
        ref.child("column").child("chaosMap").child("event").observeSingleEvent(of: .value, with: {(snapshot) in
            if let snapdata = snapshot.value as? [String:NSDictionary]{
                for key in snapdata.keys.sorted(){
                    let snap = snapdata[key]
                    if let data = snap!["name"] as? String {
                        self.eventNameArray.append(data)
                    }
                    self.chaosMapTopTableView.reloadData()
                }
                for key in snapdata.keys.sorted(){
                    let snap = snapdata[key]
                    if let data = snap!["abstract"] as? String {
                        self.abstractArray.append(data)
                    }
                    self.chaosMapTopTableView.reloadData()
                }
            }
        })
    }
}
