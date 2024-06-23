//
//  LatLng.swift
//  Foodit
//
//  Created by Woody on 6/21/24.
//

import Foundation

// MARK: user search를 FastAPI로 연결하기 위한 URL access
struct SearchPlace{
    func loadData(url: URL) async throws -> LatLng{
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(LatLng.self, from: data)
    }
}
