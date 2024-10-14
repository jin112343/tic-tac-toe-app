//
//  OMarkView.swift
//  tic-tac-toe-app
//
//  Created by mizoi.jin on 2024/10/14.
//

import SwiftUI

struct OMarkView: View {
    let color: Color
    
    var body: some View {
        GeometryReader { geometry in
            let size = geometry.size.width * 0.7
            Path { path in
                path.addEllipse(in: CGRect(x: (geometry.size.width - size) / 2, y: (geometry.size.height - size) / 2, width: size, height: size))
            }
            .stroke(color, lineWidth: 8)
        }
    }
}
