//
//  selectedChaosMapViewController.swift
//  track_online
//
//  Created by 刈田修平 on 2020/08/05.
//  Copyright © 2020 刈田修平. All rights reserved.
//
import UIKit
import Firebase
import FirebaseStorage

class selectedChaosMapViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
 
    @IBOutlet weak var CollectionView1: UICollectionView!
    @IBOutlet weak var CollectionView2: UICollectionView!
    @IBOutlet weak var CollectionView3: UICollectionView!
    @IBOutlet weak var CollectionView4: UICollectionView!
    @IBOutlet weak var selectedEvent: UILabel!
    
    var toptierIDArray = [String]()
    var toptierNameArray = [String]()
    var toptierBelongArray = [String]()
    var toptierTypeArray = [String]()
    var kogouIDArray = [String]()
    var kogouNameArray = [String]()
    var kogouBelongArray = [String]()
    var kogouTypeArray = [String]()
    var syouraiseiIDArray = [String]()
    var syouraiseiNameArray = [String]()
    var syouraiseiBelongArray = [String]()
    var syouraiseiTypeArray = [String]()
    var kenjitsuIDArray = [String]()
    var kenjitsuNameArray = [String]()
    var kenjitsuBelongArray = [String]()
    var kenjitsuTypeArray = [String]()

    var toptierIDArray_re = [String]()
    var toptierNameArray_re = [String]()
    var toptierBelongArray_re = [String]()
    var toptierTypeArray_re = [String]()
    var kogouIDArray_re = [String]()
    var kogouNameArray_re = [String]()
    var kogouBelongArray_re = [String]()
    var kogouTypeArray_re = [String]()
    var syouraiseiIDArray_re = [String]()
    var syouraiseiNameArray_re = [String]()
    var syouraiseiBelongArray_re = [String]()
    var syouraiseiTypeArray_re = [String]()
    var kenjitsuIDArray_re = [String]()
    var kenjitsuNameArray_re = [String]()
    var kenjitsuBelongArray_re = [String]()
    var kenjitsuTypeArray_re = [String]()

    var eventName: String?
    var selectedText: String?
    var selectedID: String?
    var selectedType: String?
    var selectedName: String?
    var selectedBelong: String?
    var selectedPB: String?
    var selectedChampion: String?
    var selectedPrize: String?

    override func viewDidLoad() {

        receiveData()
        loadData()

        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 
    //**************************************************
    // UICollectionViewDelegate,UICollectionViewDataSource
    //**************************************************
    
    // セクション数
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    // セルの数
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.CollectionView1 {
            return toptierNameArray_re.count
        }else if collectionView == self.CollectionView2{
            return kogouNameArray_re.count
        }else if collectionView == self.CollectionView3{
            return syouraiseiNameArray_re.count
        }else{
            return kenjitsuNameArray_re.count
        }
    }
    
    // セルを返す
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.CollectionView1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell1", for: indexPath) as! CollectionViewCell
            cell.name1.text = self.toptierNameArray_re[indexPath.row]
            cell.belong1.text = self.toptierBelongArray_re[indexPath.row]
            return cell
        }else if collectionView == self.CollectionView2{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell2", for: indexPath) as! CollectionViewCell
            cell.name2.text = self.kogouNameArray_re[indexPath.row]
            cell.belong2.text = self.kogouBelongArray_re[indexPath.row]
            return cell
        }else if collectionView == self.CollectionView3{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell3", for: indexPath) as! CollectionViewCell
            cell.name3.text = self.syouraiseiNameArray_re[indexPath.row]
            cell.belong3.text = self.syouraiseiBelongArray_re[indexPath.row]
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell4", for: indexPath) as! CollectionViewCell
            cell.name4.text = self.kenjitsuNameArray_re[indexPath.row]
            cell.belong4.text = self.kenjitsuBelongArray_re[indexPath.row]
            return cell
        }
        
    }
    
    // セルをタップした時に呼ばれる
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(self.toptierIDArray_re)
        if collectionView == self.CollectionView1 {
            print(self.toptierIDArray_re[indexPath.row])
            selectedID = self.toptierIDArray_re[indexPath.row]
            selectedName = self.toptierNameArray_re[indexPath.row]
            selectedBelong = self.toptierBelongArray_re[indexPath.row]
            selectedType = self.toptierTypeArray_re[indexPath.row]
        }else if collectionView == self.CollectionView2{
            selectedID = kogouIDArray_re[indexPath.row]
            selectedName = kogouNameArray_re[indexPath.row]
            selectedBelong = kogouBelongArray_re[indexPath.row]
            selectedType = kogouTypeArray_re[indexPath.row]
        }else if collectionView == self.CollectionView3{
            selectedID = syouraiseiIDArray_re[indexPath.row]
            selectedName = syouraiseiNameArray_re[indexPath.row]
            selectedBelong = syouraiseiBelongArray_re[indexPath.row]
            selectedType = syouraiseiTypeArray_re[indexPath.row]
        }else{
            selectedID = kenjitsuIDArray_re[indexPath.row]
            selectedName = kenjitsuNameArray_re[indexPath.row]
            selectedBelong = kenjitsuBelongArray_re[indexPath.row]
            selectedType = kenjitsuTypeArray_re[indexPath.row]
        }
        performSegue(withIdentifier: "selectedAthlete", sender: nil)

    }
    
    //**************************************************
    // UICollectionViewDelegateFlowLayout
    //**************************************************
    
    // UICollectionViewの外周余白
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 15, bottom: 0, right: 15)
    }
    
    // Cellのサイズ
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 70, height: 30)
    }
    // 行の最小余白
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    // 列の最小余白
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "selectedAthlete") {
            if #available(iOS 13.0, *) {
                let selectedView: selectedAthleteViewController = segue.destination as! selectedAthleteViewController
                selectedView.selectedID = selectedID
                selectedView.selectedEvent = eventName
                selectedView.selectedName = selectedName
                selectedView.selectedBelong = selectedBelong
                selectedView.selectedType = selectedType
            } else {
            }
        }else if (segue.identifier == "detailsChaosMap"){
            if #available(iOS 13.0, *) {
                let selectedView: detailsChaosMapViewController = segue.destination as! detailsChaosMapViewController
                selectedView.selectedEvent = eventName
            } else {
            }

        }
    }

    func receiveData(){
        selectedEvent.text = eventName
    }
    func loadData(){
        let ref = Database.database().reference()
        ref.child("column").child("chaosMap").child("\(eventName!)").child("トップティア").observeSingleEvent(of: .value, with: {
                        (snapshot) in
            if let snapdata = snapshot.value as? [String:NSDictionary]{
                for key in snapdata.keys.sorted(){
                    let snap = snapdata[key]
                    if let data = snap!["ID"] as? String {
                        self.toptierIDArray.append(data)
                        self.toptierIDArray_re = self.toptierIDArray
                        print(self.toptierIDArray_re)
                        self.CollectionView1.reloadData()
                    }
                }
                for key in snapdata.keys.sorted(){
                    let snap = snapdata[key]
                    if let data = snap!["name"] as? String {
                        self.toptierNameArray.append(data)
                        self.toptierNameArray_re = self.toptierNameArray
                        print(self.toptierNameArray_re)
                        self.CollectionView1.reloadData()
                    }
                }
                for key in snapdata.keys.sorted(){
                    let snap = snapdata[key]
                    if let data = snap!["belong"] as? String {
                        self.toptierBelongArray.append(data)
                        self.toptierBelongArray_re = self.toptierBelongArray
                        self.CollectionView1.reloadData()
                    }
                }
                for key in snapdata.keys.sorted(){
                    let snap = snapdata[key]
                    if let data = snap!["type"] as? String {
                        self.toptierTypeArray.append(data)
                        self.toptierTypeArray_re = self.toptierTypeArray
                        self.CollectionView1.reloadData()
                    }
                }
            }
        }
        )
        ref.child("column").child("chaosMap").child("\(eventName!)").child("古豪").observeSingleEvent(of: .value, with: {
                        (snapshot) in
            if let snapdata = snapshot.value as? [String:NSDictionary]{
                for key in snapdata.keys.sorted(){
                    let snap = snapdata[key]
                    if let data = snap!["ID"] as? String {
                        self.kogouIDArray.append(data)
                        self.kogouIDArray_re = self.kogouIDArray
                        self.CollectionView2.reloadData()
                    }
                }
                for key in snapdata.keys.sorted(){
                    let snap = snapdata[key]
                    if let data = snap!["name"] as? String {
                        self.kogouNameArray.append(data)
                        self.kogouNameArray_re = self.kogouNameArray
                        self.CollectionView2.reloadData()
                    }
                }
                for key in snapdata.keys.sorted(){
                    let snap = snapdata[key]
                    if let data = snap!["belong"] as? String {
                        self.kogouBelongArray.append(data)
                        self.kogouBelongArray_re = self.kogouBelongArray
                        self.CollectionView2.reloadData()
                    }
                }
                for key in snapdata.keys.sorted(){
                    let snap = snapdata[key]
                    if let data = snap!["type"] as? String {
                        self.kogouTypeArray.append(data)
                        self.kogouTypeArray_re = self.kogouTypeArray
                        self.CollectionView2.reloadData()
                    }
                }
            }
        })
        ref.child("column").child("chaosMap").child("\(eventName!)").child("将来性").observeSingleEvent(of: .value, with: {
                        (snapshot) in
            if let snapdata = snapshot.value as? [String:NSDictionary]{
                for key in snapdata.keys.sorted(){
                    let snap = snapdata[key]
                    if let data = snap!["ID"] as? String {
                        self.syouraiseiIDArray.append(data)
                        self.syouraiseiIDArray_re = self.syouraiseiIDArray
                        self.CollectionView3.reloadData()
                    }
                }
                for key in snapdata.keys.sorted(){
                    let snap = snapdata[key]
                    if let data = snap!["name"] as? String {
                        self.syouraiseiNameArray.append(data)
                        self.syouraiseiNameArray_re = self.syouraiseiNameArray
                        self.CollectionView3.reloadData()
                    }
                }
                for key in snapdata.keys.sorted(){
                    let snap = snapdata[key]
                    if let data = snap!["belong"] as? String {
                        self.syouraiseiBelongArray.append(data)
                        self.syouraiseiBelongArray_re = self.syouraiseiBelongArray
                        self.CollectionView3.reloadData()
                    }
                }
                for key in snapdata.keys.sorted(){
                    let snap = snapdata[key]
                    if let data = snap!["type"] as? String {
                        self.syouraiseiTypeArray.append(data)
                        self.syouraiseiTypeArray_re = self.syouraiseiTypeArray
                        self.CollectionView3.reloadData()
                    }
                }
            }
        })
        ref.child("column").child("chaosMap").child("\(eventName!)").child("堅実").observeSingleEvent(of: .value, with: {
                        (snapshot) in
            if let snapdata = snapshot.value as? [String:NSDictionary]{
                for key in snapdata.keys.sorted(){
                    let snap = snapdata[key]
                    if let data = snap!["ID"] as? String {
                        self.kenjitsuIDArray.append(data)
                        self.kenjitsuIDArray_re = self.kenjitsuIDArray
                        self.CollectionView4.reloadData()
                    }
                }
                for key in snapdata.keys.sorted(){
                    let snap = snapdata[key]
                    if let data = snap!["name"] as? String {
                        self.kenjitsuNameArray.append(data)
                        self.kenjitsuNameArray_re = self.kenjitsuNameArray
                        self.CollectionView4.reloadData()
                    }
                }
                for key in snapdata.keys.sorted(){
                    let snap = snapdata[key]
                    if let data = snap!["belong"] as? String {
                        self.kenjitsuBelongArray.append(data)
                        self.kenjitsuBelongArray_re = self.kenjitsuBelongArray
                        self.CollectionView4.reloadData()
                    }
                }
                for key in snapdata.keys.sorted(){
                    let snap = snapdata[key]
                    if let data = snap!["type"] as? String {
                        self.kenjitsuTypeArray.append(data)
                        self.kenjitsuTypeArray_re = self.kenjitsuTypeArray
                        self.CollectionView4.reloadData()
                    }
                }
            }
        })
    }
    
    
    
}
