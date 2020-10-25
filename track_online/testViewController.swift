//
//  testViewController.swift
//  track_online
//
//  Created by 刈田修平 on 2020/05/08.
//  Copyright © 2020 刈田修平. All rights reserved.
//

import UIKit

class testViewController: UIViewController ,UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate{
    
    var pickerview: UIPickerView = UIPickerView()
    var selectedTestField = [String]()
    var currentTextField = UITextField()
    @IBOutlet weak var testField: UITextField!

    override func viewDidLoad() {
        
        pickerview.delegate = self
        pickerview.dataSource = self
        pickerview.showsSelectionIndicator = true
        selectedTestField = ["","短距離","中距離","長距離","跳躍","投擲","混成","その他"]

        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 50))
        let spacelItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        toolbar.setItems([spacelItem, doneItem], animated: true)

        testField.inputView = pickerview
        testField.inputAccessoryView = toolbar
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @objc func done() {
        if currentTextField == testField{
            testField.endEditing(true)
            testField.text = "\(selectedTestField[pickerview.selectedRow(inComponent: 0)])"
        }
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        if currentTextField == testField {
////            print("\(selectedPrefecture)")
            return selectedTestField.count
//        } else {
//            print("ないよ")
//            return 0
//        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        if currentTextField == testField {
            return selectedTestField[row]
//        } else {
//            print("nil")
//            return ""
//        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.testField.text = selectedTestField[row]
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.pickerview.delegate = self
        self.pickerview.dataSource = self
        currentTextField = textField
        if currentTextField == testField{
            currentTextField.inputView = pickerview
        }else{
            print("nil")
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
