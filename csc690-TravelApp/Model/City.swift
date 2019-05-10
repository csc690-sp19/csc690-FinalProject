import Foundation

class City: Codable {
    let name: String
    let temperature: Double

    init(name: String, temperature: Double) {
        self.name = name
        self.temperature = temperature
    }

    var displayText: String {
        return "City: \(name), temperature: \(temperature)"
    }
}

extension City: CustomStringConvertible {
    var description: String {
        return displayText
    }

}
