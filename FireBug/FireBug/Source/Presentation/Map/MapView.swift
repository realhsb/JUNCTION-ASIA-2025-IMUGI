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
    
    // 전체 24시간 데이터셋 (한번에 생성되어 저장)
    let fireRiskDataset = FireRiskDataGenerator.generateFullDataset()
    
    // 테스트용: 현재 시간 데이터 표시 (실제로는 사용자가 조회)
    @State private var selectedHour = 23  // 가장 최근 시간
    
    var body: some View {
        VStack {
            Map(position: $cameraPosition) {
                // 선택된 시간대의 데이터 표시
                ForEach(fireRiskDataset.getData(forHour: selectedHour)) { point in
                    MapCircle(
                        center: point.coordinate,
                        radius: CLLocationDistance(300)
                    )
                    .foregroundStyle(.red)
                }
            }
            .mapStyle(.hybrid(elevation: .realistic))
        }
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
