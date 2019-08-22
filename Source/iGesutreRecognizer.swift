//
//  iGesutreRecognizer.swift
//  iRecordView
//
//  Created by Devlomi on 8/18/19.
//  Copyright © 2019 Devlomi. All rights reserved.
//

import UIKit

protocol GesutreDelegate {
    func onStart()
    func onEnd()
}


class iGesutreRecognizer: UIGestureRecognizer {
    var gestureDelegate: GesutreDelegate?


    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        gestureDelegate?.onStart()
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        gestureDelegate?.onEnd()
    }

}
