//
//  trackPremiumRegisterViewController.swift
//  track_online
//
//  Created by 刈田修平 on 2020/07/19.
//  Copyright © 2020 刈田修平. All rights reserved.
//

import UIKit
import StoreKit
import Firebase
import FirebaseUI
import FirebaseStorage

class trackPremiumRegisterViewController: UIViewController, SKProductsRequestDelegate,SKPaymentTransactionObserver {

    var myProduct:SKProduct?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        fetchProducts()
        // Do any additional setup after loading the view.
    }
    func fetchProducts(){
        let productIdentifier:Set = ["com.trackOnline.AutoRenewingSubscription.1"] // 製品ID
        let productsRequest: SKProductsRequest = SKProductsRequest.init(productIdentifiers: productIdentifier)
//        let request = SKProductsRequest(productIdentifiers: ["com.trackOnline.AutoRenewingSubscription.1"])
        productsRequest.delegate = self
        productsRequest.start()
    }
    @IBAction func tappedButton(_ sender: Any) {
        guard  let myProduct = myProduct else {
            return
        }
        if SKPaymentQueue.canMakePayments(){
            let payment = SKPayment(product: myProduct)
            SKPaymentQueue.default().add(self)
            SKPaymentQueue.default().add(payment)
        }
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        if let product = response.products.first{
            myProduct = product
            print(product)
        }
    }

    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        
        for transaction in transactions {
            switch transaction.transactionState {
            case .failed:
                queue.finishTransaction(transaction)
                print("Transaction Failed \(transaction)")
            case .purchased, .restored:
                receiptValidation(url: "https://buy.itunes.apple.com/verifyReceipt")
                queue.finishTransaction(transaction)
                print("Transaction purchased or restored: \(transaction)")
            case .deferred, .purchasing:
                print("Transaction in progress: \(transaction)")
            @unknown default:
                break
            }
        }
    }
    
    func restorePurchase() {
        SKPaymentQueue.default().add(self as SKPaymentTransactionObserver)
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        print("The Payment was successfull!")
    }

    func receiptValidation(url: String) {
        let receiptUrl = Bundle.main.appStoreReceiptURL
        let receiptData = try! Data(contentsOf: receiptUrl!)

        let requestContents = [
            "receipt-data": receiptData.base64EncodedString(options: .endLineWithCarriageReturn),
            "password": "d6eb0bc554844ce6b6774924b66e8359" // appstoreconnectからApp 用共有シークレットを取得しておきます
        ]
        
        let requestData = try! JSONSerialization.data(withJSONObject: requestContents, options: .init(rawValue: 0))

        var request = URLRequest(url: URL(string: url)!)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField:"content-type")
        request.timeoutInterval = 5.0
        request.httpMethod = "POST"
        request.httpBody = requestData
        
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: {(data, response, error) -> Void in
            
            guard let jsonData = data else {
                return
            }
            
            do {
                let json:Dictionary<String, AnyObject> = try JSONSerialization.jsonObject(with: jsonData, options: .init(rawValue: 0)) as! Dictionary<String, AnyObject>
                
                let status:Int = json["status"] as! Int
                if status == receiptErrorStatus.invalidReceiptForProduction.rawValue {
                    self.receiptValidation(url: "https://sandbox.itunes.apple.com/verifyReceipt")
                }
                
                guard let receipts:Dictionary<String, AnyObject> = json["receipt"] as? Dictionary<String, AnyObject> else {
                    return
                }
                
                // 機能開放
                self.provideFunctions(receipts: receipts)
            } catch let error {
                print("SKPaymentManager : Failure to validate receipt: \(error)")
            }
        })
        task.resume()
    }
    
    enum receiptErrorStatus: Int {
        case invalidJson = 21000
        case invalidReceiptDataProperty = 21002
        case authenticationError = 21003
        case commonSecretKeyMisMatch = 21004
        case receiptServerNotWorking = 21005
        case invalidReceiptForProduction = 21007
        case invalidReceiptForSandbox = 21008
        case unknownError = 21010
    }
    
    private func provideFunctions(receipts:Dictionary<String, AnyObject>) {
       let in_apps = receipts["in_app"] as! Array<Dictionary<String, AnyObject>>
       
       var latestExpireDate:Int = 0
       for in_app in in_apps {
           let receiptExpireDateMs = Int(in_app["expires_date_ms"] as? String ?? "") ?? 0
           let receiptExpireDateS = receiptExpireDateMs / 1000
           if receiptExpireDateS > latestExpireDate {
               latestExpireDate = receiptExpireDateS
           }
       }
        
        // UNIX時間 "dateUnix" をNSDate型 "date" に変換
        let dateUnix: TimeInterval = TimeInterval(latestExpireDate)
        let date = NSDate(timeIntervalSince1970: dateUnix)

        // NSDate型を日時文字列に変換するためのNSDateFormatterを生成
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

        // NSDateFormatterを使ってNSDate型 "date" を日時文字列 "dateStr" に変換
        let dateStr: String = formatter.string(from: date as Date)

        let currentUid:String = Auth.auth().currentUser!.uid
        let data = ["expires_date_ms":"\(dateStr)"]
        let ref1 = Database.database().reference().child("purchase").child("trackPremium").child(currentUid).child("latest")
        let ref2 = Database.database().reference().child("purchase").child("trackPremium").child(currentUid).child("all").childByAutoId()
        ref1.setValue(data)
        ref2.setValue(data)

       UserDefaults.standard.set(latestExpireDate, forKey: "expireDate")
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
