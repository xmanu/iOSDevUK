//
//  Location.swift
//  iOSDevUK
//
//  Created by David Kababyan on 10/09/2022.
//

import SwiftUI
import MapKit

enum LocationType: String, Codable, CaseIterable {
    case au, transport, ev, pubs, sm, other
    
    var name: String {
        switch self {
        case .au:
            return "Aberystwyth University"
        case .transport:
            return "Transport"
        case .ev:
            return "Electric Vehicle"
        case .pubs:
            return "Pubs"
        case .sm:
            return "Supermarket"
        case .other:
            return "Other"
        }
    }

}

struct Location: Codable, Identifiable, Hashable, Comparable {
    let id: String
    let name: String
    let note: String
    let imageLink: String?
    let latitude: Double
    let longitude: Double
    let webLink: Weblink?
    let locationType: LocationType
    
    var coordinate: CLLocationCoordinate2D {
        CLLocation(latitude: latitude, longitude: longitude).coordinate
    }
    
    static func ==(lhs: Location, rhs: Location) -> Bool {
        lhs.id == rhs.id
    }
    
    static func <(lhs: Location, rhs: Location) -> Bool {
        lhs.name < rhs.name
    }
    
    var imageUrl: URL? {
        URL(string: imageLink ?? "")
    }
}

