//
//  ErorrResponse.swift
//  Virtual_Tourist_Rema
//
//  Created by Rema alsuwailm on 26/05/1442 AH.
//

import Foundation

struct ErorrResponse: Codable {
    let status: String
    let error: String
}

extension ErorrResponse: LocalizedError {
    var errorDescription: String? {
        return error
    }
}

