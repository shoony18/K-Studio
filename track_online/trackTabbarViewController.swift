//
//  trackTabbarViewController.swift
//  track_online
//
//  Created by 刈田修平 on 2019/10/05.
//  Copyright © 2019年 刈田修平. All rights reserved.
//

import UIKit

class trackTabbarViewController: UITabBarController, UITabBarControllerDelegate {

    @IBOutlet var TabBar: UITabBar!
    
    let modalButton: UIButton = UIButton()

    override func viewDidLoad() {
        
//        self.delegate = self
//        let display: CGSize = UIScreen.main.bounds.size
//        modalButton.frame = CGRect(x: self.TabBar.center.x, y: 0, width: display.width/4, height: 30)
//
//        let image = UIImage(named: "plus.circle.fill")
//        self.modalButton.setBackgroundImage(image, for: .normal)
//        self.modalButton.addTarget(self, action: Selector(("openModal")), for: UIControl.Event.touchUpInside)
//        self.TabBar.addSubview(self.modalButton)
//        let firstViewController  = self.viewControllers![0]
//        let secondViewController = self.viewControllers![1]
//        let thirdViewController = self.viewControllers![2]
        
        //TabBarのボタンの画像のパーツ
//        let image = UIImage(named: "plus.circle.fill")
//        let highlightedHomeImage = UIImage(named: "highlighted_home")
//        let addTweetImage            = UIImage(named: "addTweet")
//        let highlightedAddTweetImage = UIImage(named: "highlighted_addTweet")
//        let myPageImage            = UIImage(named: "myPage")
//        let highlightedMyPageImage = UIImage(named: "highlighted_myPage")
        
        //それぞれのView Controllerのボタン(Tab Bar Item)に用意した画像を設定
//        firstViewController.tabBarItem  = UITabBarItem(title: "HOME", image: homeImage, selectedImage: highlightedHomeImage)
//        secondViewController.tabBarItem = UITabBarItem(title: "質問する", image: UIImage(named: "plus.circle.fill"), selectedImage: image)
//        thirdViewController.tabBarItem = UITabBarItem(title: "マイページ", image: myPageImage, selectedImage: highlightedMyPageImage)

    }
//    func openModal() {
//        let vc = (self.storyboard?.instantiateViewController(withIdentifier: "QAForm"))! as UIViewController?
//        if let vc = vc {
//            self.present(vc, animated: true, completion: nil)
//        }
//    }
//    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
//        if viewController is QATopViewController { //もしShareTweetViewController.swiftをclass指定してあるページ行きのボタンをタップしたら
//            if let newVC = tabBarController.storyboard?.instantiateViewController(withIdentifier: "QAForm"){ //withIdentifier: にはStory Board IDを設定
//                tabBarController.present(newVC, animated: true, completion: nil)//newVCで設定したページに遷移
//                return false
//            }
//        }
//        return true
//    }
}
