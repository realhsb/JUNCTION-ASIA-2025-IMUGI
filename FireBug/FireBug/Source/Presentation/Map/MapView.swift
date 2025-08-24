//
//  MapView.swift
//  FireBug
//
//  Created by Subeen on 8/23/25.
//

import SwiftUI
import MapKit

struct MapView: View {
    // 경상북도 중심 좌표 및 영역 설정
    @State private var cameraPosition: MapCameraPosition = .region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 36.4919, longitude: 128.8889),
            span: MKCoordinateSpan(latitudeDelta: 1.0, longitudeDelta: 1.0)
        )
    )
    
    @State private var showAnnotationPanel = false
    @State private var showSliderPanel = false
    @State private var heatOpacity: Double = 0.26
    @State private var touchedCoordinate: CLLocationCoordinate2D = .init()
    @State private var showCenterPannel = false
    
    // 전체 24시간 데이터셋 (한번에 생성되어 저장)
    let fireRiskDataset = FireRiskDataGenerator.generateFullDataset()
    
    // 테스트용: 현재 시간 데이터 표시 (실제로는 사용자가 조회)
    @State private var selectedHour = 23  // 가장 최근 시간
    
    var body: some View {
        ZStack {
            Map(position: $cameraPosition) {
                // 선택된 시간대의 데이터 표시
                if showAnnotationPanel {
                    ForEach(fireRiskDataset.getData(forHour: selectedHour)) { point in
                        if heatOpacity <= point.riskLevel {
                            Annotation("", coordinate: point.coordinate) {
                                Circle()
                                    .fill(.red.opacity(0.8))
                                    .stroke(.red, lineWidth: 1)
                                    .frame(width: 15, height: 15)
                                    .onTapGesture {
                                        touchedCoordinate = point.coordinate
                                    }
                            }
                        }
                    }
                }
                
                if showCenterPannel {
                    ForEach(FireRiskCenter.kfsCenters) { loc in
                        Annotation("", coordinate: loc.coordinate) {
                            Image(systemName: "leaf.fill")
                                .font(.system(size: 28))
                                .symbolRenderingMode(.palette)
                                .foregroundStyle(.green, .white)
                                .shadow(radius: 2)
                                .onTapGesture { touchedCoordinate = loc.coordinate }
                        }
                    }
                    
                    ForEach(FireStation.fireStations) { loc in
                        Annotation("", coordinate: loc.coordinate) {
                            Image(systemName: "fire.extinguisher.fill")
                                .font(.system(size: 28))
                                .symbolRenderingMode(.palette)
                                .foregroundStyle(.orange, .white)
                                .shadow(radius: 2)
                                .onTapGesture { touchedCoordinate = loc.coordinate }
                        }
                    }
                }
            }
            .mapStyle(.hybrid(elevation: .realistic))
            
            VStack {
                HStack(alignment: .top) {
                    leadingContents
                    Spacer()
                    trailingContents
                }
                Spacer()
            }
            .padding(.horizontal, 40)
            .padding(.vertical, 40)
            
        }
    }
    
    private var leadingContents: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(.gray01.opacity(0.8))
                .frame(width: 268, height: 270)
            
            VStack(alignment: .leading, spacing: 20) {
                Text("Location")
                    .font(.pretend(type: .semiBold, size: 24))
                    .foregroundStyle(.white01)
                    .padding(.leading, 20)
                
                Rectangle()
                    .foregroundStyle(.gray00)
                    .frame(width: 268, height: 1)
                
                VStack(alignment: .leading, spacing: 18) {
                    addressView
                    coordinateView
                }
                .padding(.leading, 20)
            }
        }
    }
    
    private var addressView: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 12) {
                Image(systemName: "location.fill")
                    .font(.system(size: 20))
                    .frame(width: 24, height: 24)
                    .foregroundStyle(.white01)
                
                Text("Address")
                    .font(.pretend(type: .medium, size: 24))
                    .foregroundStyle(.white01)
            }
            
            Text("Gyeongsangbuk-do")
                .font(.pretend(type: .regular, size: 20))
                .foregroundStyle(.gray00)
        }
    }
    
    private var coordinateView: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 12) {
                Image(systemName: "scope")
                    .font(.system(size: 20))
                    .frame(width: 24, height: 24)
                    .foregroundStyle(.white01)
                
                Text("Coordinates")
                    .font(.pretend(type: .medium, size: 24))
                    .foregroundStyle(.white01)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text("latitude  \(touchedCoordinate.latitude)")
                    .font(.pretend(type: .regular, size: 20))
                    .foregroundStyle(.gray00)
                Text("longitude  \(touchedCoordinate.longitude)")
                    .font(.pretend(type: .regular, size: 20))
                    .foregroundStyle(.gray00)
            }
        }
    }
    
    private var trailingContents: some View {
        VStack(alignment: .trailing, spacing: 8) {
            VerticalDualButton(
                topSystemImage: "mountain.2.fill",
                bottomSystemImage: "house.and.flag.fill",
                onTopTap: { showAnnotationPanel.toggle() },
                onBottomTap: { showCenterPannel.toggle() }
            )
            
            sliderButton
                .shadow(radius: 6)
            
            if showSliderPanel {
                sliderPanel
            }
        }
    }
    
    private var sliderButton: some View {
        Button {
            withAnimation(.snappy) { showSliderPanel.toggle() }
        } label: {
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(showSliderPanel ? .gray00 : .gray01)
                .frame(width: 62, height: 62)
                .overlay(
                    Image(systemName: "slider.horizontal.3")
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundStyle(.white)
                )
        }
        .buttonStyle(.plain)
    }
    
    private var sliderPanel: some View {
        VStack(spacing: 12) {
            Text(String(format: "%.2f", heatOpacity))
                .font(.pretend(type: .semiBold, size: 16))
                .foregroundStyle(.white01)
                .monospacedDigit()
            
            Slider(value: $heatOpacity, in: 0...1, step: 0.01)
                .tint(.white.opacity(0.9))
        }
        .padding(16)
        .frame(width: 360)   // 필요시 300~420 사이로 조절
        .background(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(.gray01)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .stroke(.gray01)
        )
        .shadow(color: .black.opacity(0.35), radius: 10, x: 0, y: 6)
        .padding(.top, 4)    // 버튼과의 간격
    }
    
    func riskColor(for level: Double) -> Color {
        switch level {
        case 0.8...1.0: return .red
        case 0.6..<0.8: return .orange
        case 0.4..<0.6: return .yellow
        case 0.2..<0.4: return .green
        default: return .blue
        }
    }
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd HH:mm"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter
    }
}

#Preview {
    MapView()
}
