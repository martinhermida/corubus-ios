import Foundation
import CoreData
import SwiftyJSON

class Stop: Codable {
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
    }
    
    func setFromJSON(json: JSON) {
        self.name = json["nombre"].string!
        self.longitude = json["posx"].float!
        self.latitude = json["posy"].float!
    }
}
