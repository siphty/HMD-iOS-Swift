//
//  Runway+CoreDataProperties.swift
//  ADSB Radar
//
//  Created by Yi JIANG on 25/7/17.
//  Copyright © 2017 Siphty. All rights reserved.
//
//

import Foundation
import CoreData


extension Runway {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Runway> {
        return NSFetchRequest<Runway>(entityName: "Runway")
    }

    @NSManaged public var airport_ident: String?
    @NSManaged public var airport_ref: Int32
    @NSManaged public var closed: Bool
    @NSManaged public var he_displaced_threshold_ft: Int16
    @NSManaged public var he_elevation_ft: Int16
    @NSManaged public var he_heading_degT: Double
    @NSManaged public var he_ident: String?
    @NSManaged public var he_latitude_deg: Double
    @NSManaged public var he_longitude_deg: Double
    @NSManaged public var id: Int32
    @NSManaged public var le_displaced_threshold_ft: Int16
    @NSManaged public var le_elevation_ft: Int16
    @NSManaged public var le_heading_degT: Double
    @NSManaged public var le_ident: String?
    @NSManaged public var le_latitude_deg: Double
    @NSManaged public var le_longitude_deg: Double
    @NSManaged public var length_ft: Int16
    @NSManaged public var lighted: Bool
    @NSManaged public var surface: String?
    @NSManaged public var width_ft: Int16

}
