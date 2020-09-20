import Foundation
import CoreData
import MapKit
import SwiftyJSON

class Line: Codable, Identifiable, Equatable, ObservableObject {
    var id: Int
    var code: String
    var color: String
    var lineStart: String
    var lineEnd: String
    var outwardsJourneyStopIds: [Int] = []
    var returnJourneyStopIds: [Int] = []
    
    init(json: JSON) {
        self.id = json["id"].intValue
        self.code = json["lin_comer"].stringValue
        self.color = json["color"].stringValue
        self.lineStart = json["nombre_orig"].stringValue
        self.lineEnd = json["nombre_dest"].stringValue
        self.outwardsJourneyStopIds = json["rutas"][0]["paradas"].arrayValue.map { $0.intValue }
        self.returnJourneyStopIds = json["rutas"][1]["paradas"].arrayValue.map { $0.intValue }
    }
    
    static func == (lhs: Line, rhs: Line) -> Bool {
        return lhs.id == rhs.id
    }

    static func transformTimes(_ rawTimes: [Int]) -> [String: [String]] {
        var times = [String: [String]]()

        for rawTime in rawTimes {
            var hour = String(rawTime)
            let minutes = hour.suffix(2)
            hour.removeLast(2)

            if hour == "" {
                hour = "0"
            }

            if times[hour] == nil {
                times[hour] = []
            }

            times[hour]?.append("\(hour):\(minutes)")
        }

        return times
    }
    
    static private func transformCoords(_ coordsString: String) -> MKPolyline {
        let coordsPath = coordsString.split(separator: " ").map { pointString -> CLLocationCoordinate2D in
            let point = pointString.split(separator: ",")
            return CLLocationCoordinate2D(latitude: Double(point[1])!, longitude: Double(point[0])!)
        }
        return MKPolyline(coordinates: coordsPath, count: coordsPath.count)
    }

    func getTimetable(completionHandler: @escaping ([[String: [String]]]) -> Void) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        let date = formatter.string(from: Date())
        let url = "https://itranvias.com/queryitr_v3.php?&dato=\(self.id)&fecha=\(date)&func=8"

        NetworkBroker.get(url) { json in
            let rawOutwards = json["servicios"][0]["ida"].arrayValue.map { $0.intValue }
            let rawReturn = json["servicios"][0]["vuelta"].arrayValue.map { $0.intValue }

            completionHandler([
                Line.transformTimes(rawOutwards),
                Line.transformTimes(rawReturn)
            ])
        }
    }

    func getBuses(completionHandler: @escaping ([Set<Int>]) -> Void) {
        let url = "https://itranvias.com/queryitr_v3.php?dato=\(self.id)&func=2"
        NetworkBroker.get(url) { json in
            let buses = [
                Set(json["paradas"][0]["paradas"].arrayValue.map { $0["parada"].intValue }),
                Set(json["paradas"][1]["paradas"].arrayValue.map { $0["parada"].intValue })
            ]

            completionHandler(buses)
        }
    }

    func pollBuses(completionHandler: @escaping ([Set<Int>]) -> Void) -> Timer {
        let timer = Timer.scheduledTimer(withTimeInterval: 30, repeats: true) { timer in
            self.getBuses(completionHandler: completionHandler)
        }
        timer.fire()
        return timer
    }
    
    func getPath(completionHandler: @escaping ([MKPolyline]) -> Void) {
        let url = "https://itranvias.com/queryitr_v3.php?&dato=\(self.id)&mostrar=R&func=99"
        NetworkBroker.get(url) { json in
            completionHandler([
                Line.transformCoords(json["mapas"][0]["recorridos"][0]["recorrido"].stringValue),
                Line.transformCoords(json["mapas"][0]["recorridos"][1]["recorrido"].stringValue)
            ])
        }
    }
}
