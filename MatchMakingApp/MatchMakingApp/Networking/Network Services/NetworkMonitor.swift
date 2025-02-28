//
//  NetworkMonitor.swift
//  MatchMakingApp
//
//  Created by Narayan Shettigar on 28/02/25.
//

import Network

class NetworkMonitor {
    private var monitor: NWPathMonitor?
    private var isConnectedValue = true
    
    var isConnected: Bool {
        return isConnectedValue
    }
    
    func startMonitoring(completion: @escaping (Bool) -> Void) {
        monitor = NWPathMonitor()
        let queue = DispatchQueue(label: "NetworkMonitor")
        monitor?.start(queue: queue)
        
        monitor?.pathUpdateHandler = { [weak self] path in
            let isConnected = path.status == .satisfied
            self?.isConnectedValue = isConnected
            completion(isConnected)
        }
    }
    
    func stopMonitoring() {
        monitor?.cancel()
        monitor = nil
    }
}
