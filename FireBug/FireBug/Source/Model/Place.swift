//
//  Place.swift
//  FireBug
//
//  Created by 이승진 on 8/24/25.
//

import Foundation
import MapKit

struct Place: Identifiable, Hashable {
    let id = UUID()
    let mapItem: MKMapItem
}
