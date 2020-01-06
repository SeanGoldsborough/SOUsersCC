//
//  AlertViews.swift
//  ScratchApp
//
//  Created by Sean Goldsborough on 1/3/20.
//  Copyright © 2020 Sean Goldsborough. All rights reserved.
//

import Foundation
import UIKit

class AlertView {
    
    class func alertPopUp(view: UIViewController, alertMessage: String) {
        let alert = UIAlertController(title: "ERROR", message: alertMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Try Again", style: .default, handler: nil))
        
        performUpdatesOnMain {
            view.present(alert, animated: true, completion: nil)
        }
    }
}
