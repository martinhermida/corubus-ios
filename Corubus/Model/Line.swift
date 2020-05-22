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
}
