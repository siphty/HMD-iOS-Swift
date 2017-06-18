//
//  Date+Utility.swift
//  HMD
//
//  Created by Yi JIANG on 18/6/17.
//  Copyright © 2017 RobertYiJiang. All rights reserved.
//

import Foundation

extension Date {
    func timeStampeString() -> String {
        return "\(NSDate().timeIntervalSince1970 * 1000)"
    }
    
    func timeStampeInt() -> Int64! {
        return Int64(self.timeIntervalSince1970 * 1000)
    }
    
}
