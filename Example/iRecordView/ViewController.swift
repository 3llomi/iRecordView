//
//  ViewController.swift
//  iRecordView
//
//  Created by Devlomi on 08/20/2019.
//  Copyright (c) 2019 Devlomi. All rights reserved.
//

import UIKit
import iRecordView

class ViewController: UIViewController,RecordViewDelegate {
    
    func onStart() {
        stateLabel.text = "onStart"
        print("onStart")
    }
    
    func onCancel() {
        stateLabel.text = "onCancel"
        print("onCancel")
    }
    
    func onFinished(duration: CGFloat) {
        stateLabel.text = "onFinished duration: \(duration)"
        print("onFinished \(duration)")
    }
    
    func onAnimationEnd() {
        stateLabel.text = "onAnimation End"
        print("onAnimationEnd")
    }
    
    
    var recordButton:RecordButton!
    var recordView:RecordView!
    var stateLabel:UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        let recordButton = RecordButton()
        recordButton.translatesAutoresizingMaskIntoConstraints = false
        
        let recordView = RecordView()
        recordView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(recordButton)
        view.addSubview(recordView)

        recordButton.widthAnchor.constraint(equalToConstant: 35).isActive = true
        recordButton.heightAnchor.constraint(equalToConstant: 35).isActive = true

        recordButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8).isActive = true
        recordButton.bottomAnchor.constraint(equalTo: view.safeBottomAnchor, constant: -16).isActive = true
        

        recordView.trailingAnchor.constraint(equalTo: recordButton.leadingAnchor, constant: -20).isActive = true
        recordView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        recordView.centerYAnchor.constraint(equalTo: recordButton.centerYAnchor).isActive = true
        recordButton.recordView = recordView

        recordView.delegate = self

        
        stateLabel = UILabel()
        stateLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stateLabel)
        stateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stateLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        
        
    }

}

