//
//  RoundedWithBackgroundHStack.swift
//  Testio
//
//  Created by Mantas Svedas on 06/12/2024.
//  Copyright © 2024 Svedas. All rights reserved.
//

import SwiftUI

struct RoundedWithBackgroundHStack<Content: View>: View {
    @ViewBuilder var content: Content
    
    var body: some View {
        HStack {
            content
        }
        .background(Color.gray.opacity(0.2))
        .rounded()
    }
}
