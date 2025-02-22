//
//  LoginManager.swift
//  RailSync
//
//  Created by Conner Haar on 2/17/25.
//
import SwiftUI
import Combine

actor LoginViewModel: ObservableObject{
    @Published var currentUser: User? = nil
    
    func createAccount(email: String, password: String, completion: @escaping (Bool) -> Void){
        Task {
            do {
                let createUserRequest = CreateUserDTO(Email: email, Password: password)
                let dto: UserDTO = try await NetworkManager.shared.request(endpoint: "/CreateUser", requestType: RequestType.POST, body: createUserRequest)
                currentUser = User(dto: dto)
                completion(true)
            } catch {
                completion(false)
                handleError(error)} }
    
    }
    
    func login(email: String, password: String, completion: @escaping (Bool) -> Void){
        Task {
            do {
                let loginRequest = LoginRequestDTO(Email: email, Password: password)
                let dto: UserDTO = try await NetworkManager.shared.request(endpoint: "/LoginUser", requestType: RequestType.POST, body: loginRequest)
                currentUser = User(dto: dto)
                completion(true)
            } catch {
                completion(false)
                handleError(error)}
        }
    }
    
}
