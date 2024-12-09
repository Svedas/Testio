//
//  RoundedModifier.swift
//  Testio
//
//  Created by Mantas Svedas on 06/12/2024.
//  Copyright © 2024 Svedas. All rights reserved.
//

import SwiftUI

struct RoundedModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .clipShape(.rect(cornerRadius: 10))
    }
}

extension View {
    func rounded() -> some View {
        modifier(RoundedModifier())
    }
}
