import Foundation
import SwiftyJSON

class NetworkBroker {
    typealias CompletionHandlerType = (_ result: JSON) -> Void
    static private let CACHE_TTL = 29.0
    static private let REQUEST_DELAY = 1.0

    static private var cache = [String: CachedResponse]()
    static private var queue = [String]()
    static private var groupedQueuedRequests = [String: [QueuedRequest]]()
    static private var areRequestsBlocked = false

    private struct QueuedRequest {
        var url: String
        var completionHandler: CompletionHandlerType
    }

    private struct CachedResponse {
        var tiemstamp: Date
        var data: JSON

        func isWithinTTL() -> Bool{
            return -self.tiemstamp.timeIntervalSinceNow < NetworkBroker.CACHE_TTL
        }
    }

    static func get(_ url: String, _ completionHandler: @escaping CompletionHandlerType) {
        let cachedResponse = NetworkBroker.getFromCache(url)
        if let cachedResponse = cachedResponse {
            completionHandler(cachedResponse)
        } else {
            NetworkBroker.addToQueue(url, completionHandler)
        }
    }

    private static func addToQueue(_ url: String, _ completionHandler: @escaping CompletionHandlerType) {
        let request = QueuedRequest(url: url, completionHandler: completionHandler)
        if NetworkBroker.groupedQueuedRequests[url] != nil {
            NetworkBroker.groupedQueuedRequests[url]!.append(request)
        } else {
            NetworkBroker.groupedQueuedRequests[url] = [request]
            NetworkBroker.queue.append(url)
        }

        if !NetworkBroker.areRequestsBlocked {
            NetworkBroker.performRequest();
        }
    }

    private static func getFromCache(_ url: String) -> JSON? {
        let cachedResponse = NetworkBroker.cache[url]
        if let cachedResponse = cachedResponse {
            if cachedResponse.isWithinTTL() {
                return cachedResponse.data
            }
        }
        return nil
    }

    private static func performRequest() {
        if NetworkBroker.queue.count == 0 {
            NetworkBroker.areRequestsBlocked = false
            return
        }

        NetworkBroker.areRequestsBlocked = true

        let requestUrl = NetworkBroker.queue.removeFirst()
        let date = Date()

        URLSession.shared.dataTask(with: URL(string: requestUrl)!) { (data, res, error) in
            if data == nil {
                NetworkBroker.queue.append(requestUrl)
            }

            let json = try? JSON(data: data!)
            if json == nil {
                NetworkBroker.queue.append(requestUrl)
            }

            if json != nil {
                let response = CachedResponse(tiemstamp: date, data: json!)
                NetworkBroker.cache[requestUrl] = response
                NetworkBroker.resolveRequest(requestUrl, response)
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + NetworkBroker.REQUEST_DELAY, execute: NetworkBroker.performRequest)
        }.resume()
    }

    private static func resolveRequest(_ requestUrl: String, _ response: CachedResponse) {
        let queuedRequests = NetworkBroker.groupedQueuedRequests.removeValue(forKey: requestUrl)
        if let queuedRequests = queuedRequests {
            for request in queuedRequests {
                request.completionHandler(response.data)
            }
        }
    }
}
