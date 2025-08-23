//
//  Marker.swift
//  FireBug
//
//  Created by 이승진 on 8/24/25.
//

import Foundation
import MapKit

struct Marker: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
    let title: String
}
