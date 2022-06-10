//
//  UserStore.swift
//  MissedMatch
//
//  Created by Shamith Pasula on 6/7/22.
//

import Foundation
import CoreLocation

class UserStore: ObservableObject {
    @Published var user = User()
    
    private static func fileURL() throws -> URL {
        try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("user.data")
    }
    static func load() async throws -> User {
        try await withCheckedThrowingContinuation { continuation in
            load { result in
                switch result {
                case .success(let scrums):
                    continuation.resume(returning: scrums)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    static func load(completion: @escaping (Result<User, Error>)->Void) {
        DispatchQueue.global(qos: .background).async {
            do {
                let fileURL = try fileURL()
                guard let file = try? FileHandle(forReadingFrom: fileURL) else {
                    DispatchQueue.main.async {
                        completion(.success(User()))
                    }
                    return
                }
                let dailyScrums = try JSONDecoder().decode(User.self, from: file.availableData)
                DispatchQueue.main.async {
                    completion(.success(dailyScrums))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    @discardableResult
    static func save(user: User) async throws -> Bool {
        try await withCheckedThrowingContinuation { continuation in
            save(user: user) { result in
                switch result {
                case .failure(let error):
                    continuation.resume(throwing: error)
                case .success(let scrumsSaved):
                    continuation.resume(returning: scrumsSaved)
                }
            }
        }
    }
    static func save(user: User, completion: @escaping (Result<Bool, Error>)->Void) {
        DispatchQueue.global(qos: .background).async {
            do {
                let data = try JSONEncoder().encode(user)
                let outfile = try fileURL()
                try data.write(to: outfile)
                DispatchQueue.main.async {
                    completion(.success(true))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
}
