//
//  NetworkService.swift
//  MatchMakingApp
//
//  Created by Narayan Shettigar on 28/02/25.
//

import Foundation

// MARK: - Network Services
enum NetworkError: Error, LocalizedError {
    case invalidURL
    case invalidResponse
    case statusCode(Int)
    case noData
    case decodingError(Error)
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .noData:
            return "No data received from server"
        case .decodingError:
            return "Failed to decode response"
        case .unknown:
            return "An unknown error occurred"
        case .invalidResponse:
            return "Invaild Response"
        case .statusCode(let code):
            return "Server error with code: \(code)"
        }
    }
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

enum EntityType: String {
    case album
    case song
    case movie
}

struct Endpoint {
    let path: String
    let method: HTTPMethod
    let headers: [String: String]?
    let body: Encodable?
    let timeoutInterval: TimeInterval?
    let queryParameters: [String: String]?

    var url: URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "randomuser.me"
        components.path = path
        components.queryItems = queryParameters?.map { URLQueryItem(name: $0.key, value: $0.value) }
        return components.url
    }
}

protocol NetworkServiceProtocol {
    func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T
}

struct CachedData {
    let data: Data
    let timestamp: Date
}

final class NetworkService: NetworkServiceProtocol {
    static let shared = NetworkService()
    private let session: URLSession
    private let maxRetryCount: Int
    private var cache: [URL: CachedData] = [:]
    private let cacheExpiryInterval: TimeInterval = 0 // 0 minutes

    init(session: URLSession = .shared, maxRetryCount: Int = 3) {
        self.session = session
        self.maxRetryCount = maxRetryCount
    }

    func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T {
        return try await request(endpoint, retryCount: 0)
    }

    private func request<T: Decodable>(_ endpoint: Endpoint, retryCount: Int) async throws -> T {
        do {
            return try await performRequest(endpoint)
        } catch {
            if retryCount < maxRetryCount {
                return try await request(endpoint, retryCount: retryCount + 1)
            } else {
                throw error
            }
        }
    }

    private func performRequest<T: Decodable>(_ endpoint: Endpoint) async throws -> T {
        guard let url = endpoint.url else {
            throw NetworkError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.allHTTPHeaderFields = endpoint.headers
        
        if let timeoutInterval = endpoint.timeoutInterval {
            request.timeoutInterval = timeoutInterval
        }

        if let body = endpoint.body {
            request.httpBody = try JSONEncoder().encode(body)
        }

        // Check cache
        if let cachedData = cache[url], Date().timeIntervalSince(cachedData.timestamp) < cacheExpiryInterval {
            return try JSONDecoder().decode(T.self, from: cachedData.data)
        }

        // If not cached or cache expired, fetch from network
        let (data, response) = try await session.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }

        guard (200..<300).contains(httpResponse.statusCode) else {
            throw NetworkError.statusCode(httpResponse.statusCode)
        }

        // Update cache
        cache[url] = CachedData(data: data, timestamp: Date())

        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw NetworkError.decodingError(error)
        }
    }
}

class APIService {
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol = NetworkService.shared) {
        self.networkService = networkService
    }
    
    func fetchUsers() async throws -> [User] {
        let endpoint = createEndpoint(limit: 10, path: "/api", method: .get)
        do {
            let userResponse: UserResponse = try await networkService.request(endpoint)
            return userResponse.results
        } catch {
            throw error
        }
    }
    
    private func createEndpoint(limit: Int, path: String, method: HTTPMethod) -> Endpoint {
        let queryParameters = [
            "results": String(limit),
        ]
        
        return Endpoint(
            path: path,
            method: method,
            headers: ["Content-Type": "application/json"],
            body: nil,
            timeoutInterval: 60,
            queryParameters: queryParameters
        )
    }
}
