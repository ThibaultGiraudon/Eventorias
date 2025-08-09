//
//  GoogleMapView.swift
//  Eventorias
//
//  Created by Thibault Giraudon on 09/08/2025.
//

import SwiftUI
import GoogleMaps
import CoreLocation

struct GoogleMapView: UIViewRepresentable {
    var latitude: Double
    var longitude: Double
    
    func makeUIView(context: Context) -> GMSMapView {
        let mapView = GMSMapView()
        mapView.camera = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: 12)
        mapView.frame = .zero
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        marker.map = mapView
        mapView.selectedMarker = marker
        return mapView
    }

    func updateUIView(_ uiView: GMSMapView, context: Context) {

    }
}

struct TestView: View {
    var body: some View {
        GoogleMapView(latitude: 48.8566, longitude: 2.3522)
            .ignoresSafeArea()
    }
}

#Preview {
    TestView()
}
