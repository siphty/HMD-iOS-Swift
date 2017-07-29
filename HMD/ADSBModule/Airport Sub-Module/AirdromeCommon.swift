//
//  AirdromeCommon.swift
//  ADSB Radar
//
//  Created by Yi JIANG on 23/7/17.
//  Copyright © 2017 Siphty. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import CoreLocation
import MapKit

final class AirdomeCommon {
    
    static let sharedInstance =  AirdomeCommon()
     var airports: [Airport] = []
    
    func parseRunwayCSV() {
        
    }
    
    func parseAirportCSV() {
//        // Load the CSV file and parse it
//        let separater = ","
//        if false {
//            return //if CoreData has been preloaded.
//        }
//        removeAllAirport()
//        guard let contentsOfUrl = Bundle.main.url(forResource:"airports", withExtension: "csv") else { return }
//        var content = ""
//        do {
//            content = try String(contentsOf: contentsOfUrl, encoding: .utf8)
//        } catch {
//            print("error")
//        }
////        if let content = String(   contentsOfURL: contentsOfUrl, encoding: NSUTF8StringEncoding, error: error) {
//            let lines = content.components(separatedBy: .newlines) as [String]
//        
//        let calendar = Calendar.current
//        let hour = calendar.component(.hour, from: Date())
//        let minutes = calendar.component(.minute, from: Date())
//        print("====================        Start preload database       ======================== \(hour):\(minutes)")
//            for line in lines {
//                var values:[String] = []
//                if line != "" {
//                    // For a line with double quotes
//                    if line.range(of: "\"") != nil {
//                        var lineToScan = line
//                        var value: String?
//                        var lineScanner = Scanner(string: lineToScan)
//                        while !lineScanner.isAtEnd {
//                            let scannerString = lineScanner.string
//                            let index = scannerString.index(scannerString.startIndex , offsetBy: 1)
//                            if (lineScanner.string as String).substring(to: index)  == "\"" {
//                                lineScanner.scanLocation += 1
//                                value = lineScanner.scanUpTo("\"") ?? ""
//                                lineScanner.scanLocation += 1
//                            } else {
//                                value = lineScanner.scanUpTo(separater) ?? ""
//                            }
//                            
//                            // Store the value into the values array
//                            values.append(value! as String)
//                            
//                            // Retrieve the unscanned remainder of the string
//                            if lineScanner.scanLocation < (lineScanner.string).count {
//                                let index = scannerString.index(lineToScan.startIndex, offsetBy: lineScanner.scanLocation + 1)
//                                lineToScan = scannerString.substring(from: index)
//                            } else {
//                                lineToScan = ""
//                            }
//                            lineScanner = Scanner(string: lineToScan)
//                        }
//                        
//                        // For a line without double quotes, we can simply separate the string
//                        // by using the separater (e.g. comma)
//                    } else  {
//                        values = line.components(separatedBy: separater)
//                    }
//                    // Put the values into the tuple and add it to the items array
//                    guard values.count != 0 else {
//                        print("Got no airport on this line")
//                        continue}
//                    saveAirport(values)
//                }
//            }
////        }
//        
//        let endHour = calendar.component(.hour, from: Date())
//        let endMinutes = calendar.component(.minute, from: Date())
//        print("====================        END preload database       ========================\(endHour):\(endMinutes)")
//        
//        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
//        let context = appDelegate.persistentContainer.viewContext
//        do {
//            try context.save()
//        } catch {
//            print("Could not save. ")//\(error), \(error.userInfo)")
//        }
//        
//        let defaults = UserDefaults.standard
//        defaults.set(true, forKey: "isPreloaded")
    }
    
    func saveAirport(_ values: [String]) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        let airport = Airport(context: context)
        let idString: String = values[0]
        guard idString.isInt else { return }
        airport.id = Int64(idString) ?? 0
        airport.ident = values[1]
        airport.type = values[2]
        airport.name = values[3]
        airport.latitude_deg = Double(values[4]) ?? 0
        airport.longitude_deg = Double(values[5]) ?? 0
        airport.elevation_ft = Int16(values[6]) ?? 0
        airport.continent = values[7]
        airport.iso_country = values[8]
        airport.iso_region = values[9]
        airport.municipality = values[10]
        if values[11] == "yes"  {
            airport.scheduled_service = true
        } else {
            airport.scheduled_service = false
        }
        airport.gps_code = values[12]
        airport.iata_code = values[13]
        airport.local_code = values[14]
        airport.home_link = values[15]
        airport.wikipedia_link = values[16]
        if values.count >= 18 {
            airport.keywords = values[17]
        }
        
    }

    func removeAllAirport() {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Airport")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        
        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch {
            print ("There was an error")
        }
    }

}

extension AirdomeCommon {
    func usePrePopulatedDB() {
        
    }
    
    func fetchNearestAirport(in span: MKCoordinateSpan, at location: CLLocationCoordinate2D, completion : @escaping (_ airports: [Airport]?) -> Void) {
        var airports: [Airport] = []
//        var longitudeRange: Double = Double(location.coordinate.longitude) + (radius / 111)
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        do {
            let request = Airport.getFetchRequest()
            let maxLatitudeDegree = Double(location.latitude) + Double(span.latitudeDelta)/2
            let minLatitudeDegree = Double(location.latitude) - Double(span.latitudeDelta)/2
            let maxLongitudeDegree = Double(location.longitude) + Double(span.longitudeDelta)/2
            let minLongitudeDegree = Double(location.longitude) - Double(span.longitudeDelta)/2
            
            let maxLatitudePredicate = NSPredicate(format: "latitude_deg < %f", maxLatitudeDegree)
            let minLatitudePredicate = NSPredicate(format: "latitude_deg > %f", minLatitudeDegree)
            let maxLongitudePredicate = NSPredicate(format: "longitude_deg < %f", maxLongitudeDegree)
            let minLongitudePredicate = NSPredicate(format: "longitude_deg > %f", minLongitudeDegree)
            let andPredicate = NSCompoundPredicate.init(type: .and, subpredicates: [maxLatitudePredicate, minLatitudePredicate, maxLongitudePredicate, minLongitudePredicate])
            request.predicate = andPredicate
            airports = try context.fetch(request)
        }
        catch {
            print("Fetching Failed")
            completion(nil)
        }
        completion(airports)
    }
}


extension AirdomeCommon {
}
