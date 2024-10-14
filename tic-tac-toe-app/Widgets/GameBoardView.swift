//
//  GameBoardView.swift
//  tic-tac-toe-app
//
//  Created by mizoi.jin on 2024/10/14.
//

import SwiftUI

struct GameBoardView: View {
    let board: [String]
    let winningBlocks: [Int]
    let fadedIndex: Int?
    let winner: String
    let onTap: (Int) -> Void
    @Environment(\.colorScheme) var colorScheme  // ダークモード対応

    var body: some View {
        let boardSize = UIScreen.main.bounds.width * 0.9

        ZStack {
            Color.gray
                .ignoresSafeArea()

            // ゲームボード（マス目は白、角は丸める）
            VStack {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 5) {
                    ForEach(0..<board.count, id: \.self) { index in
                        let blockColor = determineBlockColor(for: index)
                        let markColor = determineMarkColor(for: index)

                        ZStack {
                            // ブロックの色、角を丸める
                            RoundedRectangle(cornerRadius: 8)
                                .fill(blockColor)
                                .frame(width: boardSize / 3 - 10, height: boardSize / 3 - 10)

                            buildMark(board[index], color: markColor)
                        }
                        .onTapGesture {
                            if winner.isEmpty && board[index] == " " {
                                onTap(index)
                            }
                        }
                    }
                }
                .padding(5)
                .frame(width: boardSize, height: boardSize)
            }
        }
    }

    // ブロックの背景色を決定するメソッド
    private func determineBlockColor(for index: Int) -> Color {
        if !winner.isEmpty && winningBlocks.contains(index) {
            // 勝利した部分を反転させる　TODO一色にならないバグ修正
            return board[index] == "X" ? Color.red : Color.blue
        } else {
            return Color.white  // ブロックの背景色は白
        }
    }

    // マークの色を決定するメソッド
    private func determineMarkColor(for index: Int) -> Color {
        if !winner.isEmpty && winningBlocks.contains(index) {
            return Color.white  // 勝利した部分は白
        } else if let fadedIndex = fadedIndex, index == fadedIndex {
            return board[index] == "X" ? Color.red.opacity(0.3) : Color.blue.opacity(0.3)
        } else {
            return board[index] == "X" ? Color.red : board[index] == "O" ? Color.blue : Color.clear
        }
    }

    // マークを描画するメソッド
    private func buildMark(_ mark: String, color: Color) -> some View {
        switch mark {
        case "X":
            return AnyView(XMarkView(color: color))
        case "O":
            return AnyView(OMarkView(color: color))
        default:
            return AnyView(EmptyView())
        }
    }
}
