//
//  NetworkManager.swift
//  RailSync
//
//  Created by Conner Haar on 2/12/25.
//
import Foundation

actor NetworkManager {
    static let shared = NetworkManager()
    private let baseURL = "https://ryzue2aool.execute-api.us-east-1.amazonaws.com/default"
    
    private init() {}
    
    func request<T: Decodable>(endpoint: String, requestType: RequestType, body: Encodable? = nil) async throws -> T {
        
        do {
            // Check for valid URL
            guard let url = URL(string: baseURL + endpoint) else {
                throw NetworkError.invalidURL
            }
            
            // Create HTTP Request iwth URL
            var request = URLRequest(url: url)
            request.httpMethod = requestType.rawValue
            request.timeoutInterval = 60
            
            // Setup Body
            if let body = body {
                request.httpBody = try JSONEncoder().encode(body)
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                
            }
            
            // Grab, Decode, then Return Data
            
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.noData
            }
            
            if !(200...299).contains(httpResponse.statusCode) {
                let message = httpResponse.description
                throw NetworkError.requestFailed(statusCode: httpResponse.statusCode, message: message)
            }
            
            let returnable = try JSONDecoder().decode(T.self, from: data)
            return returnable
            
        } catch { throw NetworkError.unknown(error) }
    }
    
    func request(endpoint: String, requestType: RequestType, body: Encodable? = nil) async throws {
        
        do {
            // Check for valid URL
            guard let url = URL(string: baseURL + endpoint) else {
                throw NetworkError.invalidURL
            }
            
            // Create HTTP Request iwth URL
            var request = URLRequest(url: url)
            request.httpMethod = requestType.rawValue
            request.timeoutInterval = 60
            
            // Setup Body
            if let body = body {
                request.httpBody = try JSONEncoder().encode(body)
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                
            }
            
            // Grab, Decode, then Return Data
            let (data, response) = try await URLSession.shared.data(for: request)
            let jsonString = String(data: data, encoding: .utf8)
            print(response, jsonString ?? "failed")
            
        } catch { throw NetworkError.unknown(error) }
    }
}

enum NetworkError: Error {
    case invalidURL
    case requestFailed(statusCode: Int, message: String)
    case decodingFailed
    case noData
    case unknown(Error)
}

enum RequestType: String {
    case GET = "GET"
    case POST = "POST"
    case DELETE = "DELETE"
}

func handleError(_ error: Error) {
    switch error {
    case NetworkError.invalidURL:
        print("🚨 Invalid URL")
    case NetworkError.requestFailed(let statusCode, let message):
        print("🚨 Request failed: \(statusCode) - \(message)")
    case NetworkError.decodingFailed:
        print("🚨 Failed to decode response")
    default:
        print("🚨 Unknown error: \(error.localizedDescription)")
    }
}
