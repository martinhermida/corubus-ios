import Foundation
import CoreData
import SwiftyJSON

class Line: Codable, Identifiable {
    var id: Int
    var code: String
    var color: String
    var lineStart: String
    var lineEnd: String
    var outwardsJourneyStopIds: [Int] = []
    var returnJourneyStopIds: [Int] = []
    
    init(json: JSON) {
        self.id = json["id"].int!
        self.code = json["lin_comer"].string!
        self.color = json["color"].string!
        self.lineStart = json["nombre_orig"].string!
        self.lineEnd = json["nombre_dest"].string!
        self.outwardsJourneyStopIds = json["rutas"][0]["paradas"].arrayValue.map { $0.intValue }
        self.returnJourneyStopIds = json["rutas"][1]["paradas"].arrayValue.map { $0.intValue }
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
}
