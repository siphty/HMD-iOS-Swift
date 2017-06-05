//
//  PilotRootView.swift
//  HMD
//
//  Created by Yi JIANG on 28/5/17.
//  Copyright © 2017 RobertYiJiang. All rights reserved.
//

import Foundation
import DJIUILibrary
import VideoPreviewer


class PilotRootViewController: DULDefaultLayoutViewController {
    
    
    var aircraft: DJIBaseProduct?
//    var hmdLayer = HMDLayer()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent;
    }
    
    @IBAction func close () {
        self.dismiss(animated: true) {
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        removeLeftVersatileViewController()
        removeRightVersatileViewController()
//        let hmdWidth = view.bounds.height - 60
//        let hmdHeight = hmdWidth
//        hmdLayer.frame = CGRect(x: (view.bounds.width - hmdWidth) / 2,
//                                y: 30,
//                                width: hmdWidth,
//                                height: hmdHeight)
//        hmdLayer.borderWidth = 1
//        hmdLayer.borderColor = UIColor.yellow.cgColor
//        view.layer.addSublayer(hmdLayer)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        print("View will dispear")
        
        VideoPreviewer.instance().close()
        VideoPreviewer.instance().unSetView()
        VideoPreviewer.instance().clearRender()
        VideoPreviewer.instance().clearVideoData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        VideoPreviewer.instance().close()
        VideoPreviewer.instance().unSetView()
        VideoPreviewer.instance().clearRender()
        VideoPreviewer.instance().clearVideoData()
    }
    
}

