//
//  HUDViewRenderer.swift
//  Stereoscopic
//
//  Created by Yi JIANG on 17/4/17.
//  Copyright © 2017 RobertYiJiang. All rights reserved.
//

import UIKit
import CoreGraphics

class HUDViewRenderer: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    var label: UILabel = UILabel()
    var myNames = ["dipen","laxu","anis","aakash","santosh","raaa","ggdds","house"]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addCustomView()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addCustomView() {
        label.frame = CGRect.init(x: 50, y: 10, width: 200, height: 100)
        label.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        label.textAlignment = NSTextAlignment.center
        label.text = "test label"
        label.isHidden = true
        self.addSubview(label)
        
        let btn: UIButton = UIButton()
        btn.frame=CGRect.init(x: 50, y: 120, width: 200, height: 100)
        btn.backgroundColor=UIColor.red
        btn.setTitle("button", for: UIControlState.normal)
        btn.addTarget(self, action:Selector(("changeLabel")), for: UIControlEvents.touchUpInside)
        self.addSubview(btn)
        
        let txtField : UITextField = UITextField()
        btn.frame=CGRect.init(x: 50, y: 250, width: 100, height: 50)
        txtField.backgroundColor = UIColor.gray
        self.addSubview(txtField)
    }

}
