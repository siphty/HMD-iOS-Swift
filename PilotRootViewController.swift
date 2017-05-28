//
//  PilotRootView.swift
//  HMD
//
//  Created by Yi JIANG on 28/5/17.
//  Copyright © 2017 RobertYiJiang. All rights reserved.
//

import Foundation
import DJIUILibrary


class PilotRootViewController: DULDefaultLayoutViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent;
    }
    
    @IBAction func close () {
        self.dismiss(animated: true) {
            
        }
    }
    
}

