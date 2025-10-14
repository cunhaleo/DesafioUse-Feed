//
//  ProfileViewModel.swift
//  Feed
//
//  Created by Leonardo Cunha on 14/10/25.
//

import Foundation

protocol ProfileViewModeling {
    func logout()
    func getSubjectList() async throws
    func getNumberOfSubjects() -> Int
    func getUsername() -> String
    func getSubjectName(at indexPath: Int) -> String
}

final class ProfileViewModel: ProfileViewModeling {
    
    let service: ProfileServicing
    let userSession: UserSessionProtocol
    let authManager: AuthManaging
    
    var followedSubjects: [FolllowedSubject]?
    
    init(userSession:UserSessionProtocol = UserSession.shared, authManager: AuthManaging = FirebaseAuthManager.shared, service: ProfileServicing = ProfileService()) {
        self.userSession = userSession
        self.authManager = authManager
        self.service = service
    }
    
    func getSubjectList() async throws {
        guard let userId = userSession.userId else { return }
        self.followedSubjects = try await service.getSubjects(userId: userId)
    }
    
    func logout() {
        authManager.logout()
    }
    
    func getNumberOfSubjects() -> Int {
        followedSubjects?.count ?? 0
    }
    
    func getUsername() -> String {
        userSession.name ?? "Usuário Desconhecido"
    }
    
    func getSubjectName(at indexPath: Int) -> String {
        followedSubjects?[indexPath].subjectName ?? "Desconhecido"
    }
}
