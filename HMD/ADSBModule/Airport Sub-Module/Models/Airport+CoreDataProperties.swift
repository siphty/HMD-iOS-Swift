//
//  Airport+CoreDataProperties.swift
//  ADSB Radar
//
//  Created by Yi JIANG on 25/7/17.
//  Copyright © 2017 Siphty. All rights reserved.
//
//

import Foundation
import CoreData


extension Airport {

    @nonobjc public class func getFetchRequest() -> NSFetchRequest<Airport> {
        return NSFetchRequest<Airport>(entityName: "Airport")
    }

    @NSManaged public var continent: String?
    @NSManaged public var elevation_ft: Int16
    @NSManaged public var gps_code: String?
    @NSManaged public var home_link: String?
    @NSManaged public var iata_code: String?
    @NSManaged public var id: Int64
    @NSManaged public var ident: String?
    @NSManaged public var iso_country: String?
    @NSManaged public var iso_region: String?
    @NSManaged public var keywords: String?
    @NSManaged public var latitude_deg: Double
    @NSManaged public var local_code: String?
    @NSManaged public var longitude_deg: Double
    @NSManaged public var municipality: String?
    @NSManaged public var name: String?
    @NSManaged public var scheduled_service: Bool
    @NSManaged public var type: String?
    @NSManaged public var wikipedia_link: String?

}
