import UIKit
import Foundation
import CoreLocation

class FourSquareAPI {
    
    // Siu's
    // static let client_id = "FXPLHIF0E053NMZ0F2SLUPBKBHL15WHJQ2HGKBZPEVGXFFRR"
    // static let client_secret = "J0A0KQAMFSGR4MM0GKXX04MQH312SSGFY2JVV35KQBHN3THH"
    
    // Ka's
//    static let client_id = "1BRWPWKY4PIUBE2H4XO5X11QKA3L1E0VKCREOXA02O1YUJ0E"
//    static let client_secret = "RHQCWX0B52W411WRHTWZOOYXGUKW3FRYMQWCMFNABTIAB4Y4"

    static let client_id = "FXPLHIF0E053NMZ0F2SLUPBKBHL15WHJQ2HGKBZPEVGXFFRR"
    static let client_secret = "J0A0KQAMFSGR4MM0GKXX04MQH312SSGFY2JVV35KQBHN3THH"
    
    static var currentLocation = ""
    static var errorMessage = ""
    
    var session: URLSession
    
    init() {
        session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
    }
    
    func getVenue(completion: @escaping ([Spot]?, Error?) -> ()) {
        // get current date
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyymmdd"
        let currentDate = formatter.string(from: date)

        let url = URL(string: "https://api.foursquare.com/v2/venues/explore?near=\(FourSquareAPI.currentLocation)&client_id=\(FourSquareAPI.client_id)&client_secret=\(FourSquareAPI.client_secret)&v=\(currentDate)")!
        
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)

        let task = session.dataTask(with: request) { (data, response, error) in
            // This will run when the network request returns
            if let data = data {
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                //let movieDictionaries = dataDictionary["results"] as! [[String: Any]]
                let response = dataDictionary["response"] as! [String: Any]
                let groups = response["groups"] as! [[String: Any]]
                let items = groups[0]["items"] as! [[String: Any]]
                
                let spots = Spot.spots(dictionaries: items)
                
                completion(spots, nil)
            } else {
                completion(nil, error)
            }
        }
        task.resume()
    }
    
    func getNewVenue(completion: @escaping ([Spot]?, Error?) -> ()) {
        // get current date
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyymmdd"
        let currentDate = formatter.string(from: date)
        
        
        let url = URL(string: "https://api.foursquare.com/v2/venues/explore?near=\(FourSquareAPI.currentLocation)&client_id=\(FourSquareAPI.client_id)&client_secret=\(FourSquareAPI.client_secret)&v=\(currentDate)")!
        
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        
        let task = session.dataTask(with: request) { (data, response, error) in
            // This will run when the network request returns
            if let data = data {
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                let meta = dataDictionary["meta"] as! [String: Any]
                let code = meta["code"] as! Int
                
                if(code == 200) {
                    let response = dataDictionary["response"] as! [String: Any]
                    let groups = response["groups"] as! [[String: Any]]
                    let items = groups[0]["items"] as! [[String: Any]]
                    
                    let spots = Spot.spots(dictionaries: items)
                    
                    completion(spots, nil)
                } else if (code == 400) {
                    let errorDetail = meta["errorDetail"] as! String
                    FourSquareAPI.errorMessage = errorDetail
                    print(errorDetail)
                    completion(nil, error)
                } else {
                    print("Other Error")
                    completion(nil, error)
                }
            } else {
                completion(nil, error)
            }
        }
        task.resume()
    }
}
