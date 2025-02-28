//
//  UserResponse.swift
//  MatchMakingApp
//
//  Created by Narayan Shettigar on 28/02/25.
//

// MARK: - Models

// API Response Models
struct UserResponse: Codable {
    let results: [User]
    let info: Info
}

struct Info: Codable {
    let seed: String
    let results: Int
    let page: Int
    let version: String
}

struct User: Codable {
    let gender: String
    let name: Name
    let location: Location
    let email: String
    let login: Login
    let dob: Dob
    let registered: Registered
    let phone: String
    let cell: String
    let picture: Picture
    let nat: String
    
    var fullName: String {
        return "\(name.first) \(name.last)"
    }
}

struct Name: Codable {
    let title: String
    let first: String
    let last: String
}

struct Location: Codable {
    let street: Street
    let city: String
    let state: String
    let country: String
    let postcode: String
    let coordinates: Coordinates
    let timezone: Timezone
    
    enum CodingKeys: String, CodingKey {
        case street, city, state, country, coordinates, timezone
        case postcode
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        street = try container.decode(Street.self, forKey: .street)
        city = try container.decode(String.self, forKey: .city)
        state = try container.decode(String.self, forKey: .state)
        country = try container.decode(String.self, forKey: .country)
        coordinates = try container.decode(Coordinates.self, forKey: .coordinates)
        timezone = try container.decode(Timezone.self, forKey: .timezone)
        
        // Handle postcode which can be either String or Int
        if let postcodeString = try? container.decode(String.self, forKey: .postcode) {
            postcode = postcodeString
        } else if let postcodeInt = try? container.decode(Int.self, forKey: .postcode) {
            postcode = String(postcodeInt)
        } else {
            postcode = "Unknown"
        }
    }
}

struct Street: Codable {
    let number: Int
    let name: String
}

struct Coordinates: Codable {
    let latitude: String
    let longitude: String
}

struct Timezone: Codable {
    let offset: String
    let description: String
}

struct Login: Codable {
    let uuid: String
    let username: String
    let password: String
    let salt: String
    let md5: String
    let sha1: String
    let sha256: String
}

struct Dob: Codable {
    let date: String
    let age: Int
}

struct Registered: Codable {
    let date: String
    let age: Int
}

struct Picture: Codable {
    let large: String
    let medium: String
    let thumbnail: String
}
