import Foundation
import CoreData
import CoreLocation
import SwiftyJSON

class Stop: Codable, Identifiable {
    var id: Int
    var name: String
    var longitude: Double
    var latitude: Double
    var connectionIds: [Int] = []
    
    init(json: JSON) {
        self.id = json["id"].intValue
        self.name = json["nombre"].stringValue
        self.longitude = json["posx"].doubleValue
        self.latitude = json["posy"].doubleValue
        self.connectionIds = json["enlaces"].arrayValue.map { $0.intValue }
    }
    
    func setFromJSON(json: JSON) {
        self.name = json["nombre"].stringValue
        self.longitude = json["posx"].doubleValue
        self.latitude = json["posy"].doubleValue
    }

    func getLinesETAs(completionHandler: @escaping ([Int: [String]]) -> Void) {
        let url = "https://itranvias.com/queryitr_v3.php?dato=\(self.id)&func=0"
        NetworkBroker.get(url) { json in
            let etas: [Int: [String]] = json["buses"]["lineas"].arrayValue.reduce(into: [:]) { acc, lineData in
                let lineId = lineData["linea"].intValue
                let etas = lineData["buses"].arrayValue.map { $0["tiempo"].stringValue }
                acc[lineId] = etas
            }

            completionHandler(etas)
        }
    }

    func pollLinesETAs(completionHandler: @escaping ([Int: [String]]) -> Void) -> Timer {
        let timer = Timer.scheduledTimer(withTimeInterval: 30, repeats: true) { timer in
            self.getLinesETAs(completionHandler: completionHandler)
        }
        timer.fire()
        return timer
    }

    static func getClosestStops(_ stops: [Int: Stop], _ location: CLLocation?) -> ArraySlice<Stop> {
        if let location = location {
            return stops.values.sorted(by: {
                calculateDistance(coords: location.coordinate, stop: $0) <
                calculateDistance(coords: location.coordinate, stop: $1)
            })
            .prefix(4)
        }
        return []
    }

    static func searchStops(_ text: String, _ stops: [Int: Stop]) -> [Stop] {
        let normalizedSearch = text
            .folding(options: .diacriticInsensitive, locale: .current)
            .replacingOccurrences(of: "[^\\w\\s]", with: "", options: [.regularExpression])
            .lowercased()

        return stops.values.filter { stop in
            if String(stop.id).contains(normalizedSearch) {
                return true
            }

            let normalizedStopName = stop.name
                .folding(options: .diacriticInsensitive, locale: .current)
                .replacingOccurrences(of: "[^\\w\\s]", with: "", options: [.regularExpression])
                .lowercased()

            return normalizedStopName.contains(normalizedSearch)
        }
    }

    static func calculateDistance(coords: CLLocationCoordinate2D, stop: Stop) -> Double {
        let a = coords.longitude - stop.longitude
        let b = coords.latitude - stop.latitude
        return (a * a + b * b).squareRoot()
    }
}
