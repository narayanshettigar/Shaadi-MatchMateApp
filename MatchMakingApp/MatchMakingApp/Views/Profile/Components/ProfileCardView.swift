//
//  ProfileCardView.swift
//  MatchMakingApp
//
//  Created by Narayan Shettigar on 28/02/25.
//

import SwiftData
import SwiftUI

struct ProfileCardView: View {
    let profile: UserProfile
    @ObservedObject var viewModel: ProfileViewModel
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Profile Status Banner
            if profile.status != .new {
                HStack {
                    Text(profile.status == .accepted ? "Member Accepted" : "Member Declined")
                        .font(.subheadline.bold())
                        .foregroundColor(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(profile.status == .accepted ? Color.green : Color.red)
                        .cornerRadius(4)
                    
                    Spacer()
                    
                    if !profile.syncedWithServer {
                        HStack(spacing: 4) {
                            Image(systemName: "clock.arrow.circlepath")
                                .font(.caption)
                            Text("Not synced")
                                .font(.caption)
                        }
                        .foregroundColor(.secondary)
                    }
                }
            }
            
            // Profile Picture and Basic Info
            HStack(alignment: .top, spacing: 16) {
                if let imageData = profile.picture, let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 100, height: 100)
                        .background(Color.gray.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                } else {
                    Image(systemName: "person.fill")
                        .resizable()
                        .padding()
                        .foregroundColor(.gray)
                        .frame(width: 100, height: 100)
                        .background(Color.gray.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }
                
                VStack(alignment: .leading, spacing: 6) {
                    Text(profile.name)
                        .font(.title3)
                        .fontWeight(.bold)
                    
                    HStack(spacing: 6) {
                        Text("\(profile.age) years")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        Text("•")
                            .foregroundColor(.secondary)
                        
                        Text(profile.gender)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        if !profile.nationality.isEmpty {
                            Text("•")
                                .foregroundColor(.secondary)
                            
                            Text(profile.nationality)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    Text(profile.location)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    HStack {
                        Image(systemName: "envelope")
                            .foregroundColor(.blue)
                            .font(.caption)
                        
                        Text(profile.email)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    HStack {
                        Image(systemName: "phone")
                            .foregroundColor(.blue)
                            .font(.caption)
                        
                        Text(profile.phone)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
            
            // Action Buttons
            if profile.status == .new {
                HStack(spacing: 10) {
                    Button(action: {
                        viewModel.updateProfileStatus(profile: profile, status: .declined, modelContext: modelContext)
                    }) {
                        HStack {
                            Image(systemName: "xmark")
                            Text("Decline")
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(Color.red.opacity(0.1))
                        .foregroundColor(.red)
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.red, lineWidth: 1)
                        )
                    }
                    
                    Button(action: {
                        viewModel.updateProfileStatus(profile: profile, status: .accepted, modelContext: modelContext)
                    }) {
                        HStack {
                            Image(systemName: "checkmark")
                            Text("Accept")
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(Color.green.opacity(0.1))
                        .foregroundColor(.green)
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.green, lineWidth: 1)
                        )
                    }
                }
            } else {
                // Reset status button
                Button(action: {
                    viewModel.updateProfileStatus(profile: profile, status: .new, modelContext: modelContext)
                }) {
                    HStack {
                        Image(systemName: "arrow.uturn.backward")
                        Text("Reset Status")
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(Color.blue.opacity(0.1))
                    .foregroundColor(.blue)
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.blue, lineWidth: 1)
                    )
                }
            }
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.pink.opacity(0.2), radius: 5, x: 0, y: 2)
    }
}
