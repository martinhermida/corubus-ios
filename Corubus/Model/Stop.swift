import Foundation
import CoreData
import SwiftyJSON

class Stop: Codable, Identifiable {
    var id: Int
    var name: String
    var longitude: Float
    var latitude: Float
    var connectionIds: [Int] = []
    
    init(json: JSON) {
        self.id = json["id"].int!
        self.name = json["nombre"].string!
        self.longitude = json["posx"].float!
        self.latitude = json["posy"].float!
        self.connectionIds = json["enlaces"].arrayValue.map { $0.intValue }
    }
    
    func setFromJSON(json: JSON) {
        self.name = json["nombre"].string!
        self.longitude = json["posx"].float!
        self.latitude = json["posy"].float!
    }
}
