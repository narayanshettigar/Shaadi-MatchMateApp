//
//  OfflineBanner.swift
//  MatchMakingApp
//
//  Created by Narayan Shettigar on 28/02/25.
//

import SwiftUI

struct OfflineBanner: View {
    var body: some View {
        HStack {
            Image(systemName: "wifi.slash")
            Text("You're offline. Showing cached profiles.")
        }
        .padding(12)
        .background(Color.orange.opacity(0.8))
        .foregroundColor(.white)
        .cornerRadius(8)
    }
}
