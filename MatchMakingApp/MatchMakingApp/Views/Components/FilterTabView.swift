//
//  FilterTabView.swift
//  MatchMakingApp
//
//  Created by Narayan Shettigar on 28/02/25.
//

import SwiftData
import SwiftUI

struct FilterTabView: View {
    @ObservedObject var viewModel: ProfileViewModel
    let modelContext: ModelContext
    @Binding var disableRefresh: Bool
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 15) {
                FilterTab(title: viewModel.isConnected ? "All" : "Offline", isSelected: viewModel.filterStatus == nil) {
                    disableRefresh = false
                    viewModel.setFilter(status: nil)
                    if viewModel.isConnected {
                        Task {
                            await viewModel.fetchProfiles(modelContext: modelContext)
                        }
                    } else {
                        viewModel.loadProfilesFromDatabase(modelContext: modelContext)
                    }
                }
                
                FilterTab(title: "Accepted", isSelected: viewModel.filterStatus == .accepted) {
                    disableRefresh = true
                    viewModel.setFilter(status: .accepted)
                    viewModel.loadProfilesFromDatabase(modelContext: modelContext)
                }
                
                FilterTab(title: "Declined", isSelected: viewModel.filterStatus == .declined) {
                    disableRefresh = true
                    viewModel.setFilter(status: .declined)
                    viewModel.loadProfilesFromDatabase(modelContext: modelContext)
                }
            }
            .padding(.horizontal)
        }
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.clear)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.black, lineWidth: 1)
                )
        )
        .padding()
        .background(.blue.opacity(0.1))
    }
}

struct FilterTab: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .fontWeight(isSelected ? .bold : .medium)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(isSelected ? Color.blue.opacity(0.1) : Color.clear)
                .foregroundColor(isSelected ? .blue : .primary)
                .cornerRadius(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(isSelected ? Color.blue : Color.gray.opacity(0.3), lineWidth: 1)
                )
                .padding(4)
        }
    }
}
