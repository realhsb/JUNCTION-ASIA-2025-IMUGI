//
//  MapView.swift
//  FireBug
//
//  Created by Subeen on 8/23/25.
//

import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    @Binding var selectedCoordinate: CLLocationCoordinate2D?
    @Binding var cameraCenter: CLLocationCoordinate2D?

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
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
