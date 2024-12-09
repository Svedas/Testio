//
//  ServerListItem.swift
//  Testio
//
//  Created by Mantas Svedas on 05/12/2024.
//  Copyright © 2024 Svedas. All rights reserved.
//

import SwiftUI

struct ServerListItem: View {
    private enum Constant {
        static let distanceSuffix = "km"
    }
    
    let server: ServerDTO
    
    var body: some View {
        HStack {
            Text(server.name)
            Spacer()
            Text(String(server.distance) + .spaceSymbol + Constant.distanceSuffix)
        }
    }
}

#Preview {
    ServerListItem(
        server: ServerDTO(name: "Canada #10", distance: 4073)
    )
}
