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

    func getBuses(completionHandler: @escaping ([Set<Int>]) -> Void) {
        let url = "https://itranvias.com/queryitr_v3.php?dato=\(self.id)&func=2&_=1590192263580"
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
