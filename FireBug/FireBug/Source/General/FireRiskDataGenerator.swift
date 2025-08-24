//
//  FireRiskDataGenerator.swift
//  FireBug
//
//  Created by Subeen on 8/24/25.
//

import SwiftUI
import MapKit



// MARK: - 시간대별 산불 데이터
struct HourlyFireRiskData {
    let hour: Int  // 0-23 (24시간 전부터 현재까지)
    let timestamp: Date
    let points: [FireRiskPoint]
}

// MARK: - 전체 24시간 데이터셋
struct FireRiskDataset {
    let startTime: Date  // 24시간 전
    let endTime: Date    // 현재
    let hourlyData: [HourlyFireRiskData]  // 24개 시간대 데이터
    
    // 특정 시간대의 데이터 조회
    func getData(forHour hour: Int) -> [FireRiskPoint] {
        guard hour >= 0 && hour < hourlyData.count else { return [] }
        return hourlyData[hour].points
    }
    
    // 특정 시간의 데이터 조회
    func getData(at date: Date) -> [FireRiskPoint] {
        // 가장 가까운 시간대의 데이터 반환
        let targetHour = Calendar.current.component(.hour, from: date)
        return getData(forHour: targetHour)
    }
}

// MARK: - 산불 위험 데이터 생성기
struct FireRiskDataGenerator {
    // 2025년 3월 경북 산불 영향 지역 (불규칙한 분포)
    static let fireAffectedCenters = [
        // 서쪽 지역 (높은 위험, 불규칙 배치)
        CLLocationCoordinate2D(latitude: 36.68, longitude: 128.82),
        CLLocationCoordinate2D(latitude: 36.61, longitude: 128.87),
        CLLocationCoordinate2D(latitude: 36.64, longitude: 128.91),
        CLLocationCoordinate2D(latitude: 36.57, longitude: 128.88),
        CLLocationCoordinate2D(latitude: 36.53, longitude: 128.93),
        
        // 중앙부 (중간 위험, 산발적)
        CLLocationCoordinate2D(latitude: 36.65, longitude: 129.02),
        CLLocationCoordinate2D(latitude: 36.59, longitude: 129.07),
        CLLocationCoordinate2D(latitude: 36.62, longitude: 128.98),
        CLLocationCoordinate2D(latitude: 36.55, longitude: 129.04),
        CLLocationCoordinate2D(latitude: 36.51, longitude: 129.09),
        
        // 동쪽 지역 (진행 방향, 분산)
        CLLocationCoordinate2D(latitude: 36.63, longitude: 129.18),
        CLLocationCoordinate2D(latitude: 36.58, longitude: 129.23),
        CLLocationCoordinate2D(latitude: 36.54, longitude: 129.27),
        CLLocationCoordinate2D(latitude: 36.49, longitude: 129.21),
        CLLocationCoordinate2D(latitude: 36.46, longitude: 129.32),
    ]
    
    // 전체 24시간 데이터셋 생성
    static func generateFullDataset() -> FireRiskDataset {
        let currentTime = Date()
        let startTime = currentTime.addingTimeInterval(-24 * 3600)  // 24시간 전
        var hourlyDataArray: [HourlyFireRiskData] = []
        
        // 24시간 동안 1시간 단위로 데이터 생성
        for hourIndex in 0..<24 {
            let timestamp = startTime.addingTimeInterval(Double(hourIndex) * 3600)
            let points = generatePointsForHour(hourIndex: hourIndex, timestamp: timestamp)
            
            let hourlyData = HourlyFireRiskData(
                hour: hourIndex,
                timestamp: timestamp,
                points: points
            )
            hourlyDataArray.append(hourlyData)
        }
        
        return FireRiskDataset(
            startTime: startTime,
            endTime: currentTime,
            hourlyData: hourlyDataArray
        )
    }
    
    // 특정 시간대의 위험 지점들 생성
    private static func generatePointsForHour(hourIndex: Int, timestamp: Date) -> [FireRiskPoint] {
        var points: [FireRiskPoint] = []
        
        // 시간 진행에 따른 위험도 변화 계산
        let timeFactor = Double(hourIndex) / 24.0  // 0.0 (24시간전) ~ 1.0 (현재 근처)
        
        for (centerIndex, center) in fireAffectedCenters.enumerated() {
            // 시간대별로 다른 위험도 패턴
            let baseRisk = Double.random(in: 0.3...0.85)
            let westBias = centerIndex < 5 ? 1.15 : (centerIndex < 10 ? 0.9 : 0.7)
            
            // 시간대별 점 개수 변화 (최근일수록 많음)
            let pointCount = timeFactor > 0.5 ? Int.random(in: 18...25) : Int.random(in: 12...17)
            
            for _ in 0..<pointCount {
                // 시간 진행에 따른 분산 변화
                let spread = 0.05 + (timeFactor * 0.03)
                let latOffset = Double.random(in: -spread...spread)
                let lonOffset = Double.random(in: -spread...spread)
                
                // 풍향에 따른 동쪽 이동 (시간이 지날수록 동쪽으로)
                let windDrift = timeFactor * 0.02
                
                // 시간대별 위험도 계산
                var risk = baseRisk * westBias
                
                // 최근 시간대일수록 위험도 증가
                if hourIndex >= 18 {  // 마지막 6시간 (현재에 가까움)
                    risk *= Double.random(in: 0.85...1.0)
                    risk += 0.15
                } else if hourIndex >= 12 {  // 12-18시간
                    risk *= Double.random(in: 0.7...0.9)
                } else if hourIndex >= 6 {  // 6-12시간
                    risk *= Double.random(in: 0.5...0.75)
                } else {  // 0-6시간 (24시간 전에 가까움)
                    risk *= Double.random(in: 0.3...0.6)
                }
                
                // 노이즈 추가
                risk += Double.random(in: -0.1...0.1)
                risk = max(0.1, min(0.95, risk))
                
                let point = FireRiskPoint(
                    coordinate: CLLocationCoordinate2D(
                        latitude: center.latitude + latOffset,
                        longitude: center.longitude + lonOffset + windDrift
                    ),
                    riskLevel: risk,
                    timestamp: timestamp
                )
                points.append(point)
            }
        }
        
        // 주변 지역 산발적 위험 지점
        let surroundingCount = hourIndex > 12 ? Int.random(in: 8...12) : Int.random(in: 5...8)
        for _ in 0..<surroundingCount {
            let risk = Double.random(in: 0.05...0.3) * (0.5 + timeFactor * 0.5)
            let point = FireRiskPoint(
                coordinate: CLLocationCoordinate2D(
                    latitude: Double.random(in: 36.35...36.75),
                    longitude: Double.random(in: 128.7...129.5)
                ),
                riskLevel: risk,
                timestamp: timestamp
            )
            points.append(point)
        }
        
        return points
    }
}

// MARK: - 산림청 위치
struct KFSLocation: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
}

struct FireRiskCenter {
    static let kfsCenters: [KFSLocation] = [
        .init(coordinate: .init(latitude: 36.552203,  longitude: 128.682800)), // 남부지방산림청
        .init(coordinate: .init(latitude: 36.0725171, longitude: 128.349741)),// 구미국유림관리소
        .init(coordinate: .init(latitude: 36.821193,  longitude: 128.588967)),// 영주국유림관리소
        .init(coordinate: .init(latitude: 36.832297,  longitude: 128.632367)),// 영주국유림관리소2
        .init(coordinate: .init(latitude: 36.541463,  longitude: 129.402471)),// 영덕국유림관리소
        .init(coordinate: .init(latitude: 36.986477,  longitude: 129.394694)) // 울진국유림관리소
    ]
}
