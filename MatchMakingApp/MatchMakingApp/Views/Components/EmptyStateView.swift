//
//  EmptyStateView.swift
//  MatchMakingApp
//
//  Created by Narayan Shettigar on 28/02/25.
//

import SwiftData
import SwiftUI

struct EmptyStateView: View {
    @ObservedObject var viewModel: ProfileViewModel
    let modelContext: ModelContext
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "person.2.slash")
                .font(.system(size: 70))
                .foregroundColor(.gray)
            
            Text(emptyStateMessage)
                .font(.headline)
                .multilineTextAlignment(.center)
            
            Button(action: {
                Task {
                    await viewModel.fetchProfiles(modelContext: modelContext)
                }
            }) {
                Text("Refresh")
                    .fontWeight(.semibold)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
        .padding()
    }
    
    var emptyStateMessage: String {
        if let status = viewModel.filterStatus {
            switch status {
            case .new:
                return "No new profiles available"
            case .accepted:
                return "You haven't accepted any profiles yet"
            case .declined:
                return "You haven't declined any profiles yet"
            }
        } else {
            return "No profiles available"
        }
    }
}
