import Foundation
import Alamofire

class WeatherService {
    func getCity(forLat lat: String, long: String, completionHandler: @escaping (City) -> Void) {
        let urlString = "https://fcc-weather-api.glitch.me/api/current?lat=\(lat)&lon=\(long)"
        Alamofire.request(urlString).responseJSON(completionHandler: { response in
            guard
                let jsonDictionary = response.result.value as? [String: Any],
                let cityName = jsonDictionary["name"] as? String,
                let mainDictionary = jsonDictionary["main"] as? [String: Double],
                let temperature = mainDictionary["temp"]
                else {
                    return
            }
            let city = City(name: cityName, temperature: temperature)
            completionHandler(city)
        })
    }
}
