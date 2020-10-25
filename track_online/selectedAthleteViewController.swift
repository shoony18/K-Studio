//
//  selectedAthleteViewController.swift
//  track_online
//
//  Created by 刈田修平 on 2020/08/14.
//  Copyright © 2020 刈田修平. All rights reserved.
//

import UIKit
import Charts
import Firebase
import FirebaseStorage

class selectedAthleteViewController: UIViewController {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var belong: UILabel!
    @IBOutlet weak var PB: UILabel!
    @IBOutlet weak var champion: UILabel!
    @IBOutlet weak var top3: UILabel!
    @IBOutlet weak var prize: UILabel!
    @IBOutlet weak var RadarChartView: RadarChartView!
    @IBOutlet weak var starImageview0: UIImageView!
    @IBOutlet weak var starImageview1: UIImageView!
    @IBOutlet weak var starImageview2: UIImageView!
    @IBOutlet weak var starImageview3: UIImageView!
    @IBOutlet weak var starImageview4: UIImageView!
    let scWid: CGFloat = UIScreen.main.bounds.width     //画面の幅
    let scHei: CGFloat = UIScreen.main.bounds.height    //画面の高さ
//    let scInch:CGFloat = sqrt((scWid*scWid)+(scHei*scHei))/400
//    var subject: [String] = ["PBランク","安定性","爆発力","経験","勝負強さ"]
    var pointData = [String]()
    var pointData_re = [Double]()
    var subjectData = [String]()
    var subjectData_re = [String]()

    var selectedID: String?
    var selectedEvent: String?
    var selectedType: String?
    var selectedName: String?
    var selectedBelong: String?
//    var selectedPB: String?
//    var selectedChampion: String?
//    var selectedPrize: String?

    
    override func viewDidLoad() {
        loadDataForOther()
        loadDataForRadar()
        super.viewDidLoad()
//        self.view.addSubview(RadarChartView)
//        RadarChartView.chartDescription?.text = ""
//        setChart(subjectData_re, values: pointData_re)
    }
    func loadDataForRadar(){
        let ref = Database.database().reference()
        ref.child("column").child("chaosMap").child("\(selectedEvent!)").child("\(selectedType!)").child("\(selectedID!)").child("RadarChart").observeSingleEvent(of: .value, with: {
                        (snapshot) in
            if let snapdata = snapshot.value as? [String:NSDictionary]{
                for key in snapdata.keys.sorted(){
                    let snap = snapdata[key]
                    if let data = snap!["value"]{
                        self.pointData.append(data as! String)
                        self.pointData_re = self.pointData.compactMap(Double.init)
                        self.setChart(self.subjectData_re, values: self.pointData_re)
                    }
                }
                for key in snapdata.keys.sorted(){
                    let snap = snapdata[key]
                    if let data = snap!["subject"]{
                        self.subjectData.append(data as! String)
                        self.subjectData_re = self.subjectData
                        self.setChart(self.subjectData_re, values: self.pointData_re)
                    }
                }
            }
        })
    }

    func loadDataForOther(){
        name.text = selectedName
        belong.text = "("+"\(selectedBelong!)"+")"
        let ref0 = Database.database().reference().child("column").child("chaosMap").child("\(selectedEvent!)").child("\(selectedType!)").child("\(selectedID!)")
        ref0.observeSingleEvent(of: .value, with: { (snapshot) in
          let value = snapshot.value as? NSDictionary
            let key = value?["PB"] as? String ?? ""
            self.PB.text = key
        })
        ref0.observeSingleEvent(of: .value, with: { (snapshot) in
          let value = snapshot.value as? NSDictionary
          let key = value?["champion"] as? String ?? ""
            self.champion.text = key
        })
        ref0.observeSingleEvent(of: .value, with: { (snapshot) in
          let value = snapshot.value as? NSDictionary
          let key = value?["top3"] as? String ?? ""
            self.top3.text = key
        })
        ref0.observeSingleEvent(of: .value, with: { (snapshot) in
          let value = snapshot.value as? NSDictionary
          let key = value?["prize"] as? String ?? ""
            self.prize.text = key
        })
    }

    func setChart(_ dataPoints: [String], values: [Double]) {

        RadarChartView.noDataText = "You need to provide data for the chart."
        //点数を入れる配列
        var dataEntries: [ChartDataEntry] = []
        //点数を格納
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(x: Double(i), y: values[i])
            dataEntries.append(dataEntry)
            if i == 0{
                starImageview0.image = UIImage(named:"star\(values[i])")!
            }else if i == 1{
                starImageview1.image = UIImage(named:"star\(values[i])")!
            }else if i == 2{
                starImageview2.image = UIImage(named:"star\(values[i])")!
            }else if i == 3{
                starImageview3.image = UIImage(named:"star\(values[i])")!
            }else if i == 4{
                starImageview4.image = UIImage(named:"star\(values[i])")!
            }else{
            }
        }
        //y軸のラベルを作る
        let chartDataSet = RadarChartDataSet(entries: dataEntries, label: "評価")
        
        RadarChartView.xAxis.valueFormatter = RadarChartFormatter(labels: dataPoints)
        
        //チャートを塗りつぶす
        chartDataSet.drawFilledEnabled = true
        //チャートの外の線の色
        chartDataSet.setColor(UIColor.red)
        //塗りつぶしの色
        chartDataSet.fillColor = UIColor(red: 240/255, green: 177/255, blue: 160/255, alpha: 1)
        //ラベルの値を非表示
        chartDataSet.drawValuesEnabled = false

        //x軸とy軸をセット
        let chartData = RadarChartData(dataSet: chartDataSet)
        //レーダーチャートの回転禁止
        RadarChartView.rotationEnabled = false
        //タップ時にデータを選択できないようにする
        RadarChartView.highlightPerTapEnabled = false
        // グラフの余白
        RadarChartView.setExtraOffsets(left: 0, top: 0, right: 0, bottom: 0)
        //レーダーチャートのy軸の最小値と最大値
        RadarChartView.yAxis.axisMinimum = 0
        RadarChartView.yAxis.axisMaximum = 4
        RadarChartView.yAxis.drawAxisLineEnabled = true
        //レーダーチャートのラベルのフォントは非表示（フォント0にして）
//        RadarChartView.yAxis.labelFont = UIFont.systemFont(ofSize: scInch*3)
        //レーダーチャートの表示
        RadarChartView.data = chartData
    }
}
private class RadarChartFormatter: NSObject, IAxisValueFormatter {
    
    var labels: [String] = []
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        if Int(value) < labels.count {
            return labels[Int(value)]
        }else{
            return String("")
        }
    }
    
    init(labels: [String]) {
        super.init()
        self.labels = labels
    }
}
