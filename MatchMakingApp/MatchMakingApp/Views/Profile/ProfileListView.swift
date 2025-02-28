//
//  ProfileListView.swift
//  MatchMakingApp
//
//  Created by Narayan Shettigar on 28/02/25.
//

import SwiftUI

struct ProfileListView: View {
    @ObservedObject var viewModel: ProfileViewModel
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(viewModel.profiles) { profile in
                    ProfileCardView(profile: profile, viewModel: viewModel)
                }
            }
            .padding(16)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.pink.opacity(0.05))
    }
}
