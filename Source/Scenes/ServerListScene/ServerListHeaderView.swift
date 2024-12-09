//
//  ServerListHeaderView.swift
//  Testio
//
//  Created by Mantas Svedas on 05/12/2024.
//  Copyright © 2024 Svedas. All rights reserved.
//

import SwiftUI

struct ServerListHeaderView: View {
    private enum Constant {
        static let leftText = "Server"
        static let rightText = "Distance"
    }
    
    var body: some View {
        HStack {
            Text(Constant.leftText.uppercased())
            Spacer()
            Text(Constant.rightText.uppercased())
        }
    }
}

#Preview {
    ServerListHeaderView()
}
