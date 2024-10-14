//
//  main.swift
//  tic-tac-toe-app
//
//  Created by mizoi.jin on 2024/10/14.
//

import SwiftUI

@main
struct TicTacToeApp: App {
    var body: some Scene {
        WindowGroup {
            MenuView()  // 最初に表示するビューをMenuViewに変更
        }
    }
}

// プレビュー用のコードを追加
struct TicTacToeApp_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
    }
}


