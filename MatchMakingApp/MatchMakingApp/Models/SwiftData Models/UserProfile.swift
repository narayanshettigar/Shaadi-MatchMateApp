//
//  ProfileStatus.swift
//  MatchMakingApp
//
//  Created by Narayan Shettigar on 28/02/25.
//

import Foundation
import SwiftData

// MARK: - Models

// SwiftData Model
enum ProfileStatus: String, Codable, Hashable {
    case new
    case accepted
    case declined
}

@Model
final class UserProfile {
    var uuid: String
    var name: String
    var age: Int
    var location: String
    var email: String
    var phone: String
    var picture: Data? // Store image as Data
    var status: ProfileStatus
    var gender: String
    var nationality: String
    var syncedWithServer: Bool
    var createdAt: Date
    
    init(
        uuid: String,
        name: String,
        age: Int,
        location: String,
        email: String,
        phone: String,
        picture: Data?, // Accept Data instead of String
        gender: String = "",
        nationality: String = "",
        status: ProfileStatus = .new,
        syncedWithServer: Bool = true,
        createdAt: Date = Date()
    ) {
        self.uuid = uuid
        self.name = name
        self.age = age
        self.location = location
        self.email = email
        self.phone = phone
        self.picture = picture
        self.gender = gender
        self.nationality = nationality
        self.status = status
        self.syncedWithServer = syncedWithServer
        self.createdAt = createdAt
    }
    
    static func fromUser(_ user: User) async -> UserProfile {
        // Asynchronously fetch the image data
        let imageData = await fetchImageData(from: user.picture.large)
        
        return UserProfile(
            uuid: user.login.uuid,
            name: user.fullName,
            age: user.dob.age,
            location: "\(user.location.city), \(user.location.country)",
            email: user.email,
            phone: user.phone,
            picture: imageData, // Store the image as Data
            gender: user.gender.capitalized,
            nationality: user.nat
        )
    }

    private static func fetchImageData(from urlString: String) async -> Data? {
        guard let url = URL(string: urlString) else { return nil }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            return data
        } catch {
            print("Error fetching image data: \(error)")
            return nil
        }
    }
}
