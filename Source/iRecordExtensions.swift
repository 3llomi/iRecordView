//
//  iRecordExtensions.swift
//  iRecordView
//
//  Created by Devlomi on 8/21/19.
//

import UIKit

extension CGFloat {
    func fromatSecondsFromTimer() -> String {
        let minutes = Int(self) / 60 % 60
        let seconds = Int(self) % 60
        return String(format: "%02i:%02i", minutes, seconds)
    }
}

extension UIImage{
    
static func fromPod(_ name: String) -> UIImage {
    let traitCollection = UITraitCollection(displayScale: 3)
    var bundle = Bundle(for: RecordView.self)
    
    if let resource = bundle.resourcePath, let resourceBundle = Bundle(path: resource + "/iRecordView.bundle") {
        bundle = resourceBundle
    }
    
    return UIImage(named: name, in: bundle, compatibleWith: traitCollection) ?? UIImage()
    }
}


