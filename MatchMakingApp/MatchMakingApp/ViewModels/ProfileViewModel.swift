//
//  ProfileViewModel.swift
//  MatchMakingApp
//
//  Created by Narayan Shettigar on 28/02/25.
//

import SwiftData
import SwiftUI

// MARK: - View Model
@MainActor
class ProfileViewModel: ObservableObject {
    @Published var profiles: [UserProfile] = []
    @Published var isLoading = false
    @Published var error: Error?
    @Published var isConnected = true
    @Published var filterStatus: ProfileStatus?
    
    private let networkMonitor = NetworkMonitor()
    private let apiService = APIService()
    
    init() {
        setupNetworkMonitoring()
    }
    
    private func setupNetworkMonitoring() {
        networkMonitor.startMonitoring { [weak self] isConnected in
            Task { @MainActor in
                self?.isConnected = isConnected
                if isConnected {
                    await self?.syncWithServer()
                }
            }
        }
    }
    
    func fetchProfiles(modelContext: ModelContext) async {
        guard isConnected else {
            loadProfilesFromDatabase(modelContext: modelContext)
            return
        }
        
        isLoading = true
        
        do {
            let users = try await apiService.fetchUsers()
            
            // Convert API users to UserProfiles asynchronously
            var newProfiles: [UserProfile] = []
            for user in users {
                let profile = await UserProfile.fromUser(user)
                newProfiles.append(profile)
            }
            
            profiles = []
            // Save to database
            for profile in newProfiles {
                if let existingProfile = getExistingProfile(uuid: profile.uuid, modelContext: modelContext) {
                    // Keep the status if profile exists
                    profile.status = existingProfile.status
                }
                modelContext.insert(profile)
                profiles.append(profile)
            }
            
            try modelContext.save()
            
        } catch {
            self.error = error
            loadProfilesFromDatabase(modelContext: modelContext)
        }
        
        isLoading = false
    }
    
    private func getExistingProfile(uuid: String, modelContext: ModelContext) -> UserProfile? {
        let descriptor = FetchDescriptor<UserProfile>(predicate: #Predicate { $0.uuid == uuid })
        do {
            let existingProfiles = try modelContext.fetch(descriptor)
            return existingProfiles.first
        } catch {
            print("Error fetching existing profile: \(error)")
            return nil
        }
    }
    
    func loadProfilesFromDatabase(modelContext: ModelContext) {
        let descriptor = FetchDescriptor<UserProfile>()
        do {
            let dbProfiles = try modelContext.fetch(descriptor)
            if let filterStatus = filterStatus {
                profiles = dbProfiles.filter { $0.status == filterStatus }
            } else {
                profiles = dbProfiles.filter { $0.status == .new }
            }
        } catch {
            self.error = error
        }
    }
    
    func updateProfileStatus(profile: UserProfile, status: ProfileStatus, modelContext: ModelContext) {
        profiles = profiles.filter { user in
            user.email != profile.email
        }
        profile.status = status
        profile.syncedWithServer = false
        
        do {
            try modelContext.save()
            
            // Refresh the profile list if filtering is applied
            if filterStatus != nil {
                loadProfilesFromDatabase(modelContext: modelContext)
            }
        } catch {
            self.error = error
        }
    }
    
    func syncWithServer() async {
        // In a real app, this would send local changes to the server
        print("Network connection restored. Syncing with server...")
    }
    
    func setFilter(status: ProfileStatus?) {
        self.filterStatus = status
    }
    
    deinit {
        networkMonitor.stopMonitoring()
    }
}
