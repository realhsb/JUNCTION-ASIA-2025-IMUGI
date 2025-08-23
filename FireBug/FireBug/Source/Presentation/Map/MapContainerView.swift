//
//  MapContainerView.swift
//  FireBug
//
//  Created by 이승진 on 8/24/25.
//

import SwiftUI
import MapKit

struct MapContainerView: View {
    @State private var selectedCoordinate: CLLocationCoordinate2D? = nil
    @State private var cameraCenter: CLLocationCoordinate2D? = nil
    
    @State private var showSliderPanel = false
    @State private var heatOpacity: Double = 0.26
    
    var body: some View {
        ZStack(alignment: .top) {
            MapView(selectedCoordinate: $selectedCoordinate, cameraCenter: $cameraCenter)
                .mapStyle(.hybrid(elevation: .realistic))
                .ignoresSafeArea()
            
            HStack(alignment: .top) {
                leadingContents
                Spacer()
                trailingContents
            }
            .padding(.horizontal, 40)
            .padding(.vertical, 40)
        }
    }
    
    private var leadingContents: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(.gray01)
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
            
            Text("Pohang-si")
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
                Text("latitude  123")
                    .font(.pretend(type: .regular, size: 20))
                    .foregroundStyle(.gray00)
                Text("longitude  123")
                    .font(.pretend(type: .regular, size: 20))
                    .foregroundStyle(.gray00)
            }
        }
    }
    
    private var trailingContents: some View {
        VStack(alignment: .trailing, spacing: 4) {
            VerticalDualButton(
                topSystemImage: "mountain.2.fill",
                bottomSystemImage: "house.and.flag.fill",
                onTopTap:  { /* TODO: 상단 액션 */ },
                onBottomTap:{ /* TODO: 하단 액션 */ }
            )
            
            sliderButton
            
            if showSliderPanel {
                sliderPanel
            }
        }
    }
    
    private var sliderButton: some View {
        Button {
            withAnimation(.snappy) { showSliderPanel.toggle() }
        } label: {
            RoundedRectangle(cornerRadius: 20, style: .continuous)
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
}

#Preview {
    MapContainerView()
}
