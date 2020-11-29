//
//  loginViewController.swift
//  track_online
//
//  Created by 刈田修平 on 2019/11/04.
//  Copyright © 2019 刈田修平. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI
import FirebaseMessaging

class loginViewController: UIViewController,FUIAuthDelegate {
    
    @IBOutlet weak var AuthButton: UIButton!
    var authUI: FUIAuth { get { return FUIAuth.defaultAuthUI()!}}
    var firstLogin:String?
    
    let providers: [FUIAuthProvider] = [
        FUIEmailAuth()
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.authUI.delegate = self
        self.authUI.providers = providers
        AuthButton.addTarget(self,action: #selector(self.AuthButtonTapped(sender:)),for: .touchUpInside)
        // Do any additional setup after loading the view.
    }
    
    @objc func AuthButtonTapped(sender : AnyObject) {
        
        // FirebaseUIのViewの取得
        let authViewController = self.authUI.authViewController()
        // FirebaseUIのViewの表示
        authViewController.modalPresentationStyle = .fullScreen
        self.present(authViewController, animated: true, completion: nil)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    public func authUI(_ authUI: FUIAuth, didSignInWith user: User?, error: Error?){
        
        // 認証に成功した場合
        if error == nil {
            
            self.performSegue(withIdentifier: "goHome", sender: self)
            if let bundlePath = Bundle.main.path(forResource: "FirebaseAuthUI", ofType: "strings") {
                let bundle = Bundle(path: bundlePath)
                authUI.customStringsBundle = bundle
            }
            
            UNUserNotificationCenter.current().getNotificationSettings(completionHandler: {setting in
                if setting.authorizationStatus == .authorized {
                    
                    let token:[String: AnyObject]=["fcmToken":Messaging.messaging().fcmToken as AnyObject,"fcmTokenStatus":"1" as AnyObject]
                    self.postToken(Token: token)
                    print("許可")
                }
                else {
                    let token:[String: AnyObject]=["fcmToken":Messaging.messaging().fcmToken as AnyObject,"fcmTokenStatus":"0" as AnyObject]
                    self.postToken(Token: token)
                    print("未許可")
                }
            })
            
            //            if (Messaging.messaging().fcmToken == nil) {
            //                let token:[String: AnyObject]=["fcmToken":Messaging.messaging().fcmToken as AnyObject,"fcmTokenStatus":"0" as AnyObject]
            //                self.postToken(Token: token)
            //            }else{
            //                let token:[String: AnyObject]=["fcmToken":Messaging.messaging().fcmToken as AnyObject,"fcmTokenStatus":"1" as AnyObject]
            //                self.postToken(Token: token)
            //            }
        }
        // エラー時の処理をここに書く
    }
    override func prepare(for segue: UIStoryboardSegue, sender _: Any?) {
        
        if segue.identifier == "goHome" {
            
            if let vc = segue.destination as? trackTabbarViewController {
                vc.modalPresentationStyle = .fullScreen
            }
        }
    }
    func postToken(Token:[String: AnyObject]){
        let currentUid:String = Auth.auth().currentUser!.uid
        
        print("FCM Token:\(Token)")
        let dbRef = Database.database().reference()
        dbRef.child("fcmToken").child(currentUid).setValue(Token)
        
        
    }
    
}
//
//extension loginViewController: FUIAuthDelegate{
//    func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {
//        if error != nil {
//           return
//        }
//        performSegue(withIdentifier: "goHome", sender: self)
//
//    }
//
//}
