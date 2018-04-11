import Foundation
import SwiftCLI
import Rainbow
import Table
import DateToolsSwift

struct City {
    let name: String
    let timezone: TimeZone
}

struct Zulu {
    let current = TimeZone.current
    static let cities: [City] = [City(name: "Current", timezone: TimeZone.current),
                                 City(name: "Helsinki", timezone: TimeZone(identifier: "Europe/Helsinki")!),
                                 City(name: "Berlin", timezone: TimeZone(identifier: "Europe/Berlin")!),
                                 City(name: "Los Angeles", timezone: TimeZone(identifier: "America/Los_Angeles")!),
                                 City(name: "New York", timezone: TimeZone(identifier: "America/New_York")!)]
    
    static let allCities: [String] = {
        let cities = TimeZone.knownTimeZoneIdentifiers
        return cities
    }()
}

class ListCommand: Command {
    let name = "list"
    
    func execute() throws {
        
        let localOffset = TimeZone.current.secondsFromGMT()
        
        let rows = Zulu.cities.map { (city) -> [String] in
            var row = [city.name]
            let offset: Int = Int(TimeInterval(city.timezone.secondsFromGMT() - localOffset) / 60.0 / 60.0)
            for i in 0...23 {
                let date = (i + offset).hours.later
                row.append(date.format(with: "h"))
            }
            return row
        }
        
        let table = try Table(data: rows).table()
        print(table)
    }
}

let greeter = CLI(name: "Zulu")
greeter.commands = [ListCommand()]
_ = greeter.go()
