//
//  FireRiskDataGenerator.swift
//  FireBug
//
//  Created by Subeen on 8/24/25.
//

import Foundation
import MapKit

struct FireRiskDataGenerator {
    // 경상북도 주요 산지 중심점
    static let mountainCenters = [
        // 주왕산 일대
        CLLocationCoordinate2D(latitude: 36.3889, longitude: 129.1667),
        // 팔공산 일대
        CLLocationCoordinate2D(latitude: 36.0156, longitude: 128.6956),
        // 소백산 일대
        CLLocationCoordinate2D(latitude: 36.9542, longitude: 128.4889),
        // 보현산 일대
        CLLocationCoordinate2D(latitude: 36.1639, longitude: 128.9806),
        // 일월산 일대
        CLLocationCoordinate2D(latitude: 36.8833, longitude: 129.1000),
        // 금오산 일대
        CLLocationCoordinate2D(latitude: 36.0889, longitude: 128.3047),
        // 운문산 일대
        CLLocationCoordinate2D(latitude: 35.6389, longitude: 129.0333),
        // 가야산 일대
        CLLocationCoordinate2D(latitude: 35.8233, longitude: 128.1183),
        // 비슬산 일대
        CLLocationCoordinate2D(latitude: 35.7044, longitude: 128.5267),
        // 청량산 일대
        CLLocationCoordinate2D(latitude: 36.6500, longitude: 128.9167)
    ]
    
    // 고위험 클러스터 중심 (봄철 건조지역)
    static let highRiskClusters = [
        CLLocationCoordinate2D(latitude: 36.5656, longitude: 128.7250),  // 안동 인근 산지
        CLLocationCoordinate2D(latitude: 35.8562, longitude: 129.2247),  // 경주 인근 산지
        CLLocationCoordinate2D(latitude: 36.4500, longitude: 129.3700),  // 영덕 인근 산지
    ]
    
    static func generateFireRiskPoints() -> [FireRiskPoint] {
        var points: [FireRiskPoint] = []
        
        // 1. 주요 산지 주변 산불 위험 지점 생성 (200개)
        for center in mountainCenters {
            let pointCount = Int.random(in: 15...25)
            for _ in 0..<pointCount {
                let latOffset = Double.random(in: -0.05...0.05)
                let lonOffset = Double.random(in: -0.05...0.05)
                
                // 남향 사면(남쪽)에 더 많은 점 배치
                let southBias = Double.random(in: 0...1) > 0.6 ? -0.02 : 0
                
                let point = FireRiskPoint(
                    coordinate: CLLocationCoordinate2D(
                        latitude: center.latitude + latOffset + southBias,
                        longitude: center.longitude + lonOffset
                    ),
                    riskLevel: Double.random(in: 0.3...0.7)
                )
                points.append(point)
            }
        }
        
        // 2. 고위험 클러스터 지역 (밀집된 점들)
        for cluster in highRiskClusters {
            let clusterSize = Int.random(in: 30...40)
            for _ in 0..<clusterSize {
                // 클러스터는 더 좁은 범위에 밀집
                let latOffset = Double.random(in: -0.02...0.02)
                let lonOffset = Double.random(in: -0.02...0.02)
                
                let point = FireRiskPoint(
                    coordinate: CLLocationCoordinate2D(
                        latitude: cluster.latitude + latOffset,
                        longitude: cluster.longitude + lonOffset
                    ),
                    riskLevel: Double.random(in: 0.7...1.0)  // 높은 위험도
                )
                points.append(point)
            }
        }
        
        // 3. 랜덤 산재 지점 (경북 전역)
        for _ in 0..<50 {
            let point = FireRiskPoint(
                coordinate: CLLocationCoordinate2D(
                    latitude: Double.random(in: 35.6...37.0),
                    longitude: Double.random(in: 128.0...129.8)
                ),
                riskLevel: Double.random(in: 0.1...0.5)
            )
            points.append(point)
        }
        
        return points
    }
}
