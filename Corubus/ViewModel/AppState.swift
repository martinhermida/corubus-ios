import Foundation
import CoreData
import SwiftUI
import SwiftyJSON

struct AppStateCore: Codable {
    var linesLoading: Bool
    var stops: [Int: Stop]
    var lines: [Int: Line]
    var orderedLines: [Line]
}

class AppState: ObservableObject {
    @Published var linesLoading = false
    @Published var stops: [Int: Stop] = [:]
    @Published var lines: [Int: Line] = [:]
    @Published var orderedLines: [Line] = []
    
    init() {
        self.load()
        self.fetchData()
    }
    
    static private func getSaveDir() -> URL {
        let appName = Bundle.main.infoDictionary!["CFBundleName"] as! String
        let directory = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
        return directory.appendingPathComponent(appName, isDirectory: true)
    }
    
    public func load() {
        guard let encoded = try? Data(contentsOf: AppState.getSaveDir().appendingPathComponent("appState.json")) else { return }
        guard let appState = try? JSONDecoder().decode(AppStateCore.self, from: encoded) else { return }

        self.stops = appState.stops
        self.lines = appState.lines
        self.orderedLines = appState.orderedLines
        self.linesLoading = false
    }
    
    public func save() {
        let core = AppStateCore(linesLoading: self.linesLoading, stops: self.stops, lines: self.lines, orderedLines: self.orderedLines)
        guard let encoded = try? JSONEncoder().encode(core) else { return }
        
        let saveDir = AppState.getSaveDir()
        if !FileManager.default.fileExists(atPath: saveDir.path) {
            do { try FileManager.default.createDirectory(at: saveDir, withIntermediateDirectories: true, attributes: nil) }
            catch { return }
        }
        
        try? encoded.write(to: saveDir.appendingPathComponent("appState.json"))
    }
    
    public func fetchData() {
        self.linesLoading = true
        var stops: [Int: Stop] = [:]
        var lines: [Int: Line] = [:]
        var orderedLines: [Line] = []

        let url = URL(string: "https://itranvias.com/queryitr_v3.php?dato=20160101T000000_gl_0_20160101T000000&func=7")!
        URLSession.shared.dataTask(with: url) { (data, res, error) in
            guard let json = try? JSON(data: data!) else { return }
            
            let linesData = json["iTranvias"]["actualizacion"]["lineas"].arrayValue
            for lineData in linesData {
                let line = Line(json: lineData)
                lines[line.id] = line
                orderedLines.append(line)
            }
            
            let stopsData = json["iTranvias"]["actualizacion"]["paradas"].arrayValue
            for stopData in stopsData {
                let stop = Stop(json: stopData)
                stops[stop.id] = stop
            }
            
            DispatchQueue.main.async {
                self.stops = stops
                self.lines = lines
                self.orderedLines = orderedLines
                self.linesLoading = false
                self.save()
            }
        }.resume()
    }
}
