//
//  UserSearchQuery.swift
//  Foodit
//
//  Created by Woody on 6/23/24.
//

import Foundation

struct ConnectWithPython{
    func userAddPlace(url: URL) async throws -> [Python]{
        print("data")
        let (data, _) = try await URLSession.shared.data(from: url)
        print(data)
        return try JSONDecoder().decode([Python].self, from: data)
    }
}
