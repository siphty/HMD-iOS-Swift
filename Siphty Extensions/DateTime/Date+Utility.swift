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


typealias UnixTime = Int64

extension UnixTime {
    private func formatType(form: String) -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US") as Locale!
        dateFormatter.dateFormat = form
        return dateFormatter
    }
    var dateFull: NSDate {
        return NSDate(timeIntervalSince1970: Double(self))
    }
    var toHour: String {
        return formatType(form: "hh:mm").string(from: dateFull as Date)
    }
    var toDay: String {
        return formatType(form: "MM/dd/yyyy").string(from: dateFull as Date)
    }
    var toDayAndHour: String {
        return formatType(form: "MM/dd/yyyy hh:mm").string(from: dateFull as Date)
    }
}
