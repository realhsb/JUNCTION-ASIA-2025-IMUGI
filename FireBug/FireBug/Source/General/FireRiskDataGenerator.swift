//
//  FireRiskDataGenerator.swift
//  FireBug
//
//  Created by Subeen on 8/24/25.
//

import Foundation
import MapKit

struct FireRiskDataGenerator {
    // 2025년 3월 경북 산불 영향 지역 (서→동 진행)
    // 안동 북동부 ~ 청송 ~ 영덕 방향
    static let fireAffectedCenters = [
        // 서쪽 (시작점, 최고 위험)
        CLLocationCoordinate2D(latitude: 36.68, longitude: 128.82),
        CLLocationCoordinate2D(latitude: 36.61, longitude: 128.87),
//        CLLocationCoordinate2D(latitude: 36.64, longitude: 128.91),
        CLLocationCoordinate2D(latitude: 36.57, longitude: 128.88),
        CLLocationCoordinate2D(latitude: 36.53, longitude: 128.93),
        
        // 중앙부 (중간 위험)
        CLLocationCoordinate2D(latitude: 36.65, longitude: 129.02),
        CLLocationCoordinate2D(latitude: 36.59, longitude: 129.07),
//        CLLocationCoordinate2D(latitude: 36.62, longitude: 128.98),
        CLLocationCoordinate2D(latitude: 36.55, longitude: 129.04),
        CLLocationCoordinate2D(latitude: 36.51, longitude: 129.09),
        
        
        // 동쪽 (진행 방향, 높은 위험)
        CLLocationCoordinate2D(latitude: 36.63, longitude: 129.18),
        CLLocationCoordinate2D(latitude: 36.58, longitude: 129.23),
//        CLLocationCoordinate2D(latitude: 36.54, longitude: 129.27),
        CLLocationCoordinate2D(latitude: 36.49, longitude: 129.21),
        CLLocationCoordinate2D(latitude: 36.46, longitude: 129.32),
    ]
    
    static func generateFireRiskPoints() -> [FireRiskPoint] {
        var points: [FireRiskPoint] = []
        
        // 24시간 동안의 시간대별 데이터 생성
        for hour in 0...24 {
            let timeDecay = Double(hour) / 24.0  // 시간이 지날수록 위험도 감소
            
            for (index, center) in fireAffectedCenters.enumerated() {
                // 서→동 위치에 따른 위험도 계산
//                let locationFactor = 1.0 - (Double(index) / Double(fireAffectedCenters.count) * 0.5)
                let baseLocationRisk = Double.random(in: 0.5...0.9)
                                let westBias = index < 5 ? 1.2 : (index < 10 ? 0.9 : 0.7)  // 서쪽이 더 위험
                
                
                // 각 중심점 주변에 점들 생성
                let pointCount = Int.random(in: 3...8)
                for _ in 0..<pointCount {
                    let latOffset = Double.random(in: -0.05...0.05)
                    let lonOffset = Double.random(in: -0.05...0.05)
                    
                    // 강풍 방향(동쪽) 편향
                    let windBias = Double.random(in: 0...0.02)
                    
                    // 기본 위험도 계산
                    var risk = baseLocationRisk * westBias
                    
                    // 현재 시간(hour=0)일수록 위험도 높음
                    if hour <= 3 {
                         risk *= Double.random(in: 0.75...0.95)
                     } else if hour <= 8 {
                         risk *= Double.random(in: 0.65...0.85)
                     } else if hour <= 16 {
                         risk *= Double.random(in: 0.5...0.75)
                     } else {
                         risk *= Double.random(in: 0.3...0.6)
                     }
                    
                    // 노이즈 추가
                    risk += Double.random(in: -0.5...0.6)
                    risk = max(0.15, min(0.95, risk))  // 0.1~1.0 범위로 제한
                    
                    let point = FireRiskPoint(
                        coordinate: CLLocationCoordinate2D(
                            latitude: center.latitude + latOffset,
                            longitude: center.longitude + lonOffset + windBias
                        ),
                        riskLevel: risk,
                        hour: hour
                    )
                    points.append(point)
                }
            }
            
            // 주변 지역 산발적 위험 지점 (낮은 위험도)
            for _ in 0..<5 {
                let surroundingRisk = Double.random(in: 0.1...0.3) * (1.0 - timeDecay * 0.5)
                let point = FireRiskPoint(
                    coordinate: CLLocationCoordinate2D(
                        latitude: Double.random(in: 36.4...36.7),
                        longitude: Double.random(in: 128.8...129.4)
                    ),
                    riskLevel: surroundingRisk,
                    hour: hour
                )
                points.append(point)
            }
        }
        
        return points
    }
}

