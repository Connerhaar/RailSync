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
            let jsonString = String(data: data, encoding: .utf8)
            print(response, jsonString ?? "failed")
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
    
    
//    func request<T: Decodable>(
//        url: String,
//        type: String,
//        body: Encodable? = nil,
//        returnType: T.Type,
//        completion: @escaping (Result<T, Error>) -> Void
//    ) {
//        guard let requestUrl = URL(string: url) else {
//            completion(.failure(NSError(domain: "Invalid URL", code: 400)))
//            return
//        }
//
//        var request = URLRequest(url: requestUrl)
//        request.httpMethod = type
//
//        if let body = body {
//            do {
//                request.httpBody = try JSONEncoder().encode(body)
//                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//            } catch {
//                completion(.failure(error))
//                return
//            }
//        }
//
//        URLSession.shared.dataTask(with: request) { data, response, error in
//            if let error = error {
//                completion(.failure(error))
//                return
//            }
//
//            guard let data = data else {
//                completion(.failure(NSError(domain: "No data received", code: 500)))
//                return
//            }
//
//            do {
//                let decodedResponse = try JSONDecoder().decode(T.self, from: data)
//                completion(.success(decodedResponse))
//            } catch {
//                completion(.failure(error))
//            }
//        }.resume()
//    }
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
