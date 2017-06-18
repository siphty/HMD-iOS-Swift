//
//  String+UserLogin.swift
//  HMD
//
//  Created by Yi JIANG on 9/6/17.
//  Copyright © 2017 RobertYiJiang. All rights reserved.
//

import Foundation

extension String {
    func isEmail() -> Bool {
        let emailString: String? = self
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: emailString)
    }
    
    func isSecurePassword() -> Bool {
        print("Haven't implement yet")
        return false
    }
    
    
    func isLeagalUserName() -> Bool {
        print("Haven't implement yet")
        return false
    }
    
    
}
