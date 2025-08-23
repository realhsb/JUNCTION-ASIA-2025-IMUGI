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
            span: MKCoordinateSpan(latitudeDelta: 2.0, longitudeDelta: 2.0)
        )
    )
    
    // 산불 위험 지점 데이터
    let fireRiskPoints = FireRiskDataGenerator.generateFireRiskPoints()
    
    var body: some View {
        ZStack {
            mapView
            buttonStack
        }
        
    }
    
    var mapView: some View {
        Map(position: $cameraPosition) {
            // 산불 위험 지점 표시
            ForEach(fireRiskPoints) { point in
                MapCircle(
                    center: point.coordinate,
                    radius: CLLocationDistance(point.riskLevel * 1000) // 위험도에 따라 크기 조절
                )
                .foregroundStyle(riskColor(for: point.riskLevel).opacity(0.5))
                .stroke(riskColor(for: point.riskLevel), lineWidth: 1)
            }
        }
        .mapStyle(.hybrid(elevation: .realistic))
    }
    
    var buttonStack: some View {
        HStack {
            Spacer()
            VStack {
                Button {
                    
                } label: {
                    Text("위험도")
                }
                
                Spacer()
            }
        }
    }
    
    func riskColor(for level: Double) -> Color {
        switch level {
        case 0.8...1.0:
            return .red        // 매우 높음
        case 0.6..<0.8:
            return .orange     // 높음
        case 0.4..<0.6:
            return .yellow     // 보통
        case 0.2..<0.4:
            return .green      // 낮음
        default:
            return .blue       // 매우 낮음
        }
    }
}

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.isRotateEnabled = false
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .none

        let gesture = UILongPressGestureRecognizer(target: context.coordinator, action: #selector(context.coordinator.handleLongPress(_:)))
        mapView.addGestureRecognizer(gesture)

        return mapView
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {
        if let coordinate = selectedCoordinate {
            uiView.removeAnnotations(uiView.annotations)
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "선택한 위치"
            uiView.addAnnotation(annotation)
        }

        cameraCenter = uiView.centerCoordinate
    }

    // MARK: - Coordinator
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapView

        init(_ parent: MapView) {
            self.parent = parent
        }

        @objc func handleLongPress(_ gestureRecognizer: UILongPressGestureRecognizer) {
            guard gestureRecognizer.state == .began,
                  let mapView = gestureRecognizer.view as? MKMapView else { return }

            let point = gestureRecognizer.location(in: mapView)
            let coordinate = mapView.convert(point, toCoordinateFrom: mapView)
            parent.selectedCoordinate = coordinate
        }

        func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
            parent.cameraCenter = mapView.centerCoordinate
        }
    }
}
