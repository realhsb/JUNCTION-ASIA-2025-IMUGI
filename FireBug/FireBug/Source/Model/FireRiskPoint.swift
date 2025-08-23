//
//  FireRiskPoint.swift
//  FireBug
//
//  Created by Subeen on 8/24/25.
//

import Foundation
import MapKit

// MARK: - 산불 위험 지점 모델
struct FireRiskPoint: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
    let riskLevel: Double  // 0.0 ~ 1.0
    let timestamp: Date     // 실제 시간
}
