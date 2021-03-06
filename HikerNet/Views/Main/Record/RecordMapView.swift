
import SwiftUI
import Mapbox

struct RecordMapView: UIViewRepresentable {
    private let mapView = MGLMapView(frame: .zero, styleURL: MGLStyle.outdoorsStyleURL)
    @State var currentLocation = CLLocationCoordinate2D()
    @State var firstTimeGettingLocation = true
    @Binding var locationButtonTapped: Bool
    @Binding var locationAuthorized: Bool
    
    func makeUIView(context: UIViewRepresentableContext<RecordMapView>) -> MGLMapView {
        mapView.delegate = context.coordinator
        mapView.compassViewPosition = .bottomLeft
        mapView.compassViewMargins = CGPoint(x: UIScreen.main.bounds.width / 2 - 120, y: 50)
        mapView.showsUserLocation = true
        return mapView
    }

    func updateUIView(_ uiView: MGLMapView, context: UIViewRepresentableContext<RecordMapView>) {
        if (locationButtonTapped) {
            uiView.setCenter(currentLocation, zoomLevel: 16, direction: .zero, animated: true)
            uiView.showsUserLocation = true
            locationButtonTapped = false
        }
    }
    
    func makeCoordinator() -> RecordMapView.Coordinator {
        Coordinator(self)
    }
    
    final class Coordinator: NSObject, MGLMapViewDelegate {
        var control: RecordMapView

        init(_ control: RecordMapView) {
            self.control = control
        }
        
        func mapView(_ mapView: MGLMapView, didChangeLocationManagerAuthorization manager: MGLLocationManager) {
            switch (manager.authorizationStatus) {
            case .authorizedAlways:
                control.locationAuthorized = true
            default:
                control.locationAuthorized = false
            }
        }
        
        func mapView(_ mapView: MGLMapView, didUpdate userLocation: MGLUserLocation?) {
            control.currentLocation = CLLocationCoordinate2D(
                latitude: userLocation!.coordinate.latitude,
                longitude: userLocation!.coordinate.longitude
            )
            if (control.firstTimeGettingLocation) {
                mapView.setCenter(control.currentLocation, zoomLevel: 16, animated: true)
                control.firstTimeGettingLocation = false
            }
        }
    }
}
