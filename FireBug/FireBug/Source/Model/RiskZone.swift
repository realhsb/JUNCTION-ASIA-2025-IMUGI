//
//  RiskZone.swift
//  FireBug
//
//  Created by Subeen on 8/24/25.
//

import Foundation
import MapKit

// 위험도 영역 정의
struct RiskZone {
    let level: Double
    let boundary: [CLLocationCoordinate2D]
}

// MARK: - 위험도별 영역 (위로 이동 + 높이 30% 축소)
var riskZones: [RiskZone] {
    [
        // 가장 넓은 영역 - 낮음 (초록)
        // 가장 넓은 영역 - 낮음 (초록)
        // 가장 넓은 영역 - 낮음 (초록)
        RiskZone(level: 0.3, boundary: [
            CLLocationCoordinate2D(latitude: 36.68, longitude: 128.80),
            CLLocationCoordinate2D(latitude: 36.70, longitude: 128.85),
            CLLocationCoordinate2D(latitude: 36.71, longitude: 128.92),
            CLLocationCoordinate2D(latitude: 36.72, longitude: 129.00),
            CLLocationCoordinate2D(latitude: 36.71, longitude: 129.08),
            CLLocationCoordinate2D(latitude: 36.70, longitude: 129.15),
            CLLocationCoordinate2D(latitude: 36.68, longitude: 129.22),
            CLLocationCoordinate2D(latitude: 36.65, longitude: 129.28),
            CLLocationCoordinate2D(latitude: 36.62, longitude: 129.32),
            CLLocationCoordinate2D(latitude: 36.58, longitude: 129.33),
            CLLocationCoordinate2D(latitude: 36.54, longitude: 129.32),
            CLLocationCoordinate2D(latitude: 36.51, longitude: 129.28),
            CLLocationCoordinate2D(latitude: 36.49, longitude: 129.22),
            CLLocationCoordinate2D(latitude: 36.48, longitude: 129.15),
            CLLocationCoordinate2D(latitude: 36.47, longitude: 129.08),
            CLLocationCoordinate2D(latitude: 36.48, longitude: 129.00),
            CLLocationCoordinate2D(latitude: 36.49, longitude: 128.92),
            CLLocationCoordinate2D(latitude: 36.51, longitude: 128.85),
            CLLocationCoordinate2D(latitude: 36.54, longitude: 128.80),
            CLLocationCoordinate2D(latitude: 36.58, longitude: 128.78),
            CLLocationCoordinate2D(latitude: 36.62, longitude: 128.78),
            CLLocationCoordinate2D(latitude: 36.65, longitude: 128.79),
            CLLocationCoordinate2D(latitude: 36.68, longitude: 128.80)
        ]),
        
        // 중간 영역 - 보통 (노랑)
        // 중간 영역 - 보통 (노랑)
        RiskZone(level: 0.5, boundary: [
            CLLocationCoordinate2D(latitude: 36.66, longitude: 128.88),
            CLLocationCoordinate2D(latitude: 36.67, longitude: 128.92),
            CLLocationCoordinate2D(latitude: 36.68, longitude: 128.97),
            CLLocationCoordinate2D(latitude: 36.68, longitude: 129.02),
            CLLocationCoordinate2D(latitude: 36.67, longitude: 129.07),
            CLLocationCoordinate2D(latitude: 36.66, longitude: 129.12),
            CLLocationCoordinate2D(latitude: 36.64, longitude: 129.16),
            CLLocationCoordinate2D(latitude: 36.62, longitude: 129.19),
            CLLocationCoordinate2D(latitude: 36.59, longitude: 129.20),
            CLLocationCoordinate2D(latitude: 36.56, longitude: 129.19),
            CLLocationCoordinate2D(latitude: 36.54, longitude: 129.16),
            CLLocationCoordinate2D(latitude: 36.52, longitude: 129.12),
            CLLocationCoordinate2D(latitude: 36.51, longitude: 129.07),
            CLLocationCoordinate2D(latitude: 36.50, longitude: 129.02),
            CLLocationCoordinate2D(latitude: 36.51, longitude: 128.97),
            CLLocationCoordinate2D(latitude: 36.52, longitude: 128.92),
            CLLocationCoordinate2D(latitude: 36.54, longitude: 128.88),
            CLLocationCoordinate2D(latitude: 36.56, longitude: 128.85),
            CLLocationCoordinate2D(latitude: 36.59, longitude: 128.84),
            CLLocationCoordinate2D(latitude: 36.62, longitude: 128.85),
            CLLocationCoordinate2D(latitude: 36.64, longitude: 128.86),
            CLLocationCoordinate2D(latitude: 36.66, longitude: 128.88)
        ]),
        
        // 좁은 영역 - 높음 (주황)
        RiskZone(level: 0.7, boundary: [
            CLLocationCoordinate2D(latitude: 36.63, longitude: 128.93),
            CLLocationCoordinate2D(latitude: 36.64, longitude: 128.96),
            CLLocationCoordinate2D(latitude: 36.64, longitude: 129.00),
            CLLocationCoordinate2D(latitude: 36.63, longitude: 129.04),
            CLLocationCoordinate2D(latitude: 36.62, longitude: 129.07),
            CLLocationCoordinate2D(latitude: 36.60, longitude: 129.09),
            CLLocationCoordinate2D(latitude: 36.58, longitude: 129.10),
            CLLocationCoordinate2D(latitude: 36.56, longitude: 129.09),
            CLLocationCoordinate2D(latitude: 36.54, longitude: 129.07),
            CLLocationCoordinate2D(latitude: 36.53, longitude: 129.04),
            CLLocationCoordinate2D(latitude: 36.52, longitude: 129.00),
            CLLocationCoordinate2D(latitude: 36.52, longitude: 128.96),
            CLLocationCoordinate2D(latitude: 36.53, longitude: 128.93),
            CLLocationCoordinate2D(latitude: 36.54, longitude: 128.90),
            CLLocationCoordinate2D(latitude: 36.56, longitude: 128.88),
            CLLocationCoordinate2D(latitude: 36.58, longitude: 128.87),
            CLLocationCoordinate2D(latitude: 36.60, longitude: 128.88),
            CLLocationCoordinate2D(latitude: 36.62, longitude: 128.90),
            CLLocationCoordinate2D(latitude: 36.63, longitude: 128.93)
        ]),
        
        // 가장 좁은 영역 - 매우 높음 (빨강)
        RiskZone(level: 0.9, boundary: [
            CLLocationCoordinate2D(latitude: 36.60, longitude: 128.96),
            CLLocationCoordinate2D(latitude: 36.61, longitude: 128.99),
            CLLocationCoordinate2D(latitude: 36.60, longitude: 129.02),
            CLLocationCoordinate2D(latitude: 36.59, longitude: 129.04),
            CLLocationCoordinate2D(latitude: 36.57, longitude: 129.04),
            CLLocationCoordinate2D(latitude: 36.55, longitude: 129.02),
            CLLocationCoordinate2D(latitude: 36.54, longitude: 128.99),
            CLLocationCoordinate2D(latitude: 36.55, longitude: 128.96),
            CLLocationCoordinate2D(latitude: 36.57, longitude: 128.94),
            CLLocationCoordinate2D(latitude: 36.59, longitude: 128.94),
            CLLocationCoordinate2D(latitude: 36.60, longitude: 128.96)
        ])
    ]
    
}
