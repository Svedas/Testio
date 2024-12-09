//
//  OAuthRequestBuilder.swift
//  Testio
//
//  Created by Mantas Svedas on 05/12/2024.
//  Copyright © 2024 Svedas. All rights reserved.
//

import Alamofire

struct OAuthRequestBuilder: OAuthRequestBuilderProtocol {
    func buildRequest(grantType: OAuthGrantTypeProtocol, configuration: OAuthConfiguration) -> DataRequest {
        configuration.authSession.request(
            configuration.authUrl,
            method: .post,
            parameters: buildDefaultRequestParameters(grantType: grantType),
            encoder: JSONParameterEncoder.default,
            headers: HTTPHeaders(arrayLiteral: HTTPHeader(name: "Accept", value: "application/json"))
        )
    }
}
