//
//  OAuthRequestBuilderProtocol.swift
//  Testio
//
//  Created by Mantas Svedas on 06/12/2024.
//  Copyright © 2024 Svedas. All rights reserved.
//

import Alamofire

protocol OAuthRequestBuilderProtocol {
    func buildRequest(grantType: OAuthGrantTypeProtocol, configuration: OAuthConfiguration) -> DataRequest
}

extension OAuthRequestBuilderProtocol {
    func buildDefaultRequestParameters(grantType: OAuthGrantTypeProtocol) -> [String: String] {
        var parameters = [String: String]()
        
        for (key, value) in grantType.fields {
            parameters[key] = value
        }
        
        return parameters
    }
}
