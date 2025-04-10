//
//  LoginManager.swift
//  RailSync
//
//  Created by Conner Haar on 2/17/25.
//
import SwiftUI
import Combine

@MainActor
class LoginViewModel: ObservableObject{
    @Published var currentUser: User? = nil
    
    @Published var invalidEmail: Bool = false
    @Published var emailAlreadyExists: Bool = false
    @Published var invalidPassword: Bool = false
    
    func createAccount(email: String, password: String, completion: @escaping (Bool, Int) -> Void) async -> Bool {
            do {
                let createUserRequest = UserRequestDTO(Email: email, Password: password)
                let dto: UserDTO = try await NetworkManager.shared.request(endpoint: "/CreateUser", requestType: RequestType.POST, body: createUserRequest)
                currentUser = User(dto: dto)
                completion(true, 200)
                return true
            } catch {
                if case NetworkError.requestFailed(let statusCode, _) = error {
                    completion(false, statusCode)
                } else {
                    completion(false, 200)
                }
                handleError(error)
                return false
            }
    
    }
    
    func login(email: String, password: String, completion: @escaping (Bool, Int) -> Void) async -> Bool {
            do {
                let loginRequest = LoginRequestDTO(Email: email, Password: password)
                let dto: UserDTO = try await NetworkManager.shared.request(endpoint: "/LoginUser", requestType: RequestType.POST, body: loginRequest)
                currentUser = User(dto: dto)
                completion(true, 200)
                return true
            } catch {
                if case NetworkError.requestFailed(let statusCode, _) = error {
                    completion(false, statusCode)
                } else {
                    completion(false, 200)
                }
                handleError(error)
                return false
            }
    }
    
}
