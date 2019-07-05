import Foundation

typealias Launches = [LaunchElement]

// MARK: - LaunchElement
struct LaunchElement: Codable {
    let flightNumber: Int
    let missionName: String
    let missionID: [String]
    let launchYear: String
    let launchDateUnix: Int

    let launchDateLocal: String
    let isTentative: Bool
    let tentativeMaxPrecision: String
    let tbd: Bool
    let rocket: Rocket
    let details: String?
    let upcoming: Bool
    let launchDateUTC: String
    
    var launchDate:Date!{
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let date = dateFormatter.date(from: launchDateUTC)
        return date
    }

    enum CodingKeys: String, CodingKey {
        case flightNumber = "flight_number"
        case missionName = "mission_name"
        case missionID = "mission_id"
        case launchYear = "launch_year"
        case launchDateUnix = "launch_date_unix"
        case launchDateUTC = "launch_date_utc"
        case launchDateLocal = "launch_date_local"
        case isTentative = "is_tentative"
        case tentativeMaxPrecision = "tentative_max_precision"
        case tbd
        case rocket
        case details, upcoming
    }
}

// MARK: - Rocket
struct Rocket: Codable {
    let rocketID: RocketID
    let rocketName: RocketName
    let rocketType: RocketType
    let firstStage: FirstStage
    let secondStage: SecondStage
    
    enum CodingKeys: String, CodingKey {
        case rocketID = "rocket_id"
        case rocketName = "rocket_name"
        case rocketType = "rocket_type"
        case firstStage = "first_stage"
        case secondStage = "second_stage"
    }
}


enum RocketID: String, Codable {
    case falcon9 = "falcon9"
}

enum RocketName: String, Codable {
    case falcon9 = "Falcon 9"
}

enum RocketType: String, Codable {
    case ft = "FT"
}

// MARK: - FirstStage
struct FirstStage: Codable {
    let cores: [Core]
}

// MARK: - Core
struct Core: Codable {
    let coreSerial: String?
    let flight, block: Int?
    let gridfins, legs, reused: Bool?
    let landingIntent: Bool?
    let landingType, landingVehicle: String?
    
    enum CodingKeys: String, CodingKey {
        case coreSerial = "core_serial"
        case flight, block, gridfins, legs, reused
        case landingIntent = "landing_intent"
        case landingType = "landing_type"
        case landingVehicle = "landing_vehicle"
    }
}

// MARK: - SecondStage
struct SecondStage: Codable {
    let block: Int?
    let payloads: [Payload]
}

// MARK: - Payload
struct Payload: Codable {
    let payloadID: String
    let reused: Bool
    let customers: [String]
    let nationality: String
    let manufacturer: String?
    let payloadMassKg: Int?
    let payloadMassLbs: Double?
    let orbit: String
    
    enum CodingKeys: String, CodingKey {
        case payloadID = "payload_id"
        case reused, customers, nationality, manufacturer
        case payloadMassKg = "payload_mass_kg"
        case payloadMassLbs = "payload_mass_lbs"
        case orbit
    }
}
