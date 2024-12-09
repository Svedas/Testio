//
//  RestClientError.swift
//  UITests
//
//  Created by Mantas Svedas on 06/12/2024.
//  Copyright © 2024 Svedas. All rights reserved.
//

enum RestClientError: Error {
    case couldNotEncodeJSON(error: Error)
    case incorrectURL(url: String)
    case badRequest(error: Error)
}
