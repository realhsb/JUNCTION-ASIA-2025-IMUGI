//
//  FireRiskPoint.swift
//  FireBug
//
//  Created by Subeen on 8/24/25.
//

import Foundation
import MapKit

struct FireRiskPoint: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
    let riskLevel: Double  // 0.0 ~ 1.0
    let hour: Int  // 0 = 현재, 24 = 24시간 전
}
