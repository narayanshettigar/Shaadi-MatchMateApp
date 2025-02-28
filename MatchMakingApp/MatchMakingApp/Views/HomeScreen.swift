//
//  ContentView.swift
//  MatchMakingApp
//
//  Created by Narayan Shettigar on 28/02/25.
//

import SwiftUI

// MARK: - Views
struct HomeScreen: View {
    @StateObject private var viewModel = ProfileViewModel()
    @Environment(\.modelContext) private var modelContext
    @State var disableRefresh: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack(spacing: 0) {
                    // Filter tabs
                    FilterTabView(viewModel: viewModel, modelContext: modelContext, disableRefresh: $disableRefresh)
                    
                    // Main content
                    if viewModel.isLoading {
                        ProgressView("Loading profiles...")
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(.pink.opacity(0.02))
                    } else if viewModel.profiles.isEmpty {
                        EmptyStateView(viewModel: viewModel, modelContext: modelContext)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(.pink.opacity(0.02))
                    } else {
                        ProfileListView(viewModel: viewModel)
                            .background(.pink.opacity(0.02))
                    }
                }
                
                // Offline banner
                if !viewModel.isConnected {
                    VStack {
                        Spacer()
                        OfflineBanner()
                    }
                    .padding()
                }
            }
            .navigationTitle("MatchMate")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        Task {
                            await viewModel.fetchProfiles(modelContext: modelContext)
                        }
                    }) {
                        Image(systemName: "arrow.clockwise")
                    }
                    .disabled(disableRefresh)
                }
            }
            .task {
                await viewModel.fetchProfiles(modelContext: modelContext)
            }
            .alert(isPresented: Binding<Bool>(
                get: { viewModel.error != nil },
                set: { if !$0 { viewModel.error = nil } }
            )) {
                Alert(
                    title: Text("Error"),
                    message: Text(viewModel.error?.localizedDescription ?? "Unknown error"),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
}
