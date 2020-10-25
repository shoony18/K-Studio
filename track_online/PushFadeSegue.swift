//
//  PushFadeSegue.swift
//  track_online
//
//  Created by 刈田修平 on 2019/11/10.
//  Copyright © 2019 刈田修平. All rights reserved.
//

import UIKit

class PushFadeSegue: UIStoryboardSegue {

    override func perform() {
        UIView.transition(
            with: (source.navigationController?.view)!,
            duration: 0.5,
            options: .transitionCrossDissolve,
            animations: {
                () -> Void in
                self.source.navigationController?.pushViewController(self.destination, animated: false)
            },
            completion: nil)
    }

}
