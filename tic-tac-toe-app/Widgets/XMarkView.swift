//
//  XMarkView.swift
//  tic-tac-toe-app
//
//  Created by mizoi.jin on 2024/10/14.
//

import SwiftUI

struct XMarkView: View {
    let color: Color
    
    var body: some View {
        GeometryReader { geometry in
            let size = geometry.size.width * 0.65
            let offset = (geometry.size.width - size) / 2  // Xを中央に配置するためのオフセットを計算

            Path { path in
                // 左上から右下へ
                path.move(to: CGPoint(x: offset, y: offset))
                path.addLine(to: CGPoint(x: offset + size, y: offset + size))
                // 右上から左下へ
                path.move(to: CGPoint(x: offset + size, y: offset))
                path.addLine(to: CGPoint(x: offset, y: offset + size))
            }
            .stroke(color, lineWidth: 8)
        }
    }
}


