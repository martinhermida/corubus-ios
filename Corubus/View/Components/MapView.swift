import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    var line: Line?
    var route: MKPolyline?
    var stop: Stop?

    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView(frame: .zero)
        mapView.setVisibleMapRect(
            MKMapRect(x: 127924785.45538275, y: 98247460.70573261, width: 41772.35663744807, height: 38516.41478252411),
            animated: false
        )
        return mapView
    }

    func updateUIView(_ view: MKMapView, context: Context) {
        let mapViewDelegate = MapViewDelegate(line)
        view.delegate = mapViewDelegate                          // (1) This should be set in makeUIView, but it is getting reset to `nil`
        view.translatesAutoresizingMaskIntoConstraints = false   // (2) In the absence of this, we get constraints error on rotation; and again, it seems one should do this in makeUIView, but has to be here
        addRoute(to: view)
        addStop(to: view)
    }
}

private extension MapView {
    private static func getPointAnnotation(point: MKMapPoint, localizedKey: String) -> MKPointAnnotation {
        let pin = MKPointAnnotation()
        pin.coordinate = point.coordinate
        pin.title = NSLocalizedString(localizedKey, comment: "")
        return pin
    }
    
    private func getBoundingRect(_ mapView: MKMapView) -> MKMapRect {
        let minX : Double = mapView.annotations.map({MKMapPoint($0.coordinate).x}).min()! - 1500
        let minY : Double = mapView.annotations.map({MKMapPoint($0.coordinate).y}).min()! - 2100
        let maxX : Double = mapView.annotations.map({MKMapPoint($0.coordinate).x}).max()! + 1500
        let maxY : Double = mapView.annotations.map({MKMapPoint($0.coordinate).y}).max()! + 800
        
        let routeRect = self.route!.boundingMapRect
        
        return MKMapRect(
            x: min(minX, routeRect.minX),
            y: min(minY, routeRect.minY),
            width: max(maxX, routeRect.maxX) - min(minX, routeRect.minX),
            height: max(maxY, routeRect.maxY) - min(minY, routeRect.minY)
        )
    }
    
    func addRoute(to view: MKMapView) {
        if !view.overlays.isEmpty {
            view.removeOverlays(view.overlays)
        }
        if !view.annotations.isEmpty {
            view.removeAnnotations(view.annotations)
        }
        
        guard let route = route else { return }
        view.addOverlay(route)
        
        let points = route.points()
        view.addAnnotation(MapView.getPointAnnotation(point: points[0], localizedKey: "map.route.start"))
        view.addAnnotation(MapView.getPointAnnotation(point: points[route.pointCount - 1], localizedKey: "map.route.finish"))
        
        view.setVisibleMapRect(getBoundingRect(view), edgePadding: UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15), animated: true)
    }
    
    func addStop(to view: MKMapView) {
        guard let stop = stop else { return }
        
        let region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: stop.latitude, longitude: stop.longitude),
            span: MKCoordinateSpan(latitudeDelta: 0.0015, longitudeDelta: 0.0015)
        )
        
        let pin = MKPointAnnotation()
        pin.coordinate = region.center

        view.setRegion(region, animated: false)
        view.addAnnotation(pin)
        view.mapType = .hybrid
    }
}

class MapViewDelegate: NSObject, MKMapViewDelegate {
    var line: Line?

    init(_ line: Line?) {
        self.line = line
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        if self.line != nil {
            renderer.lineWidth = 8
            renderer.strokeColor = UIColor(hex: self.line!.color)!.withAlphaComponent(1)
        }
        return renderer
    }
}
