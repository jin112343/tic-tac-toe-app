//
//  AIGameView.swift .swift
//  tic-tac-toe-app
//
//  Created by mizoi.jin on 2024/10/14.
//

import SwiftUI

struct AIGameView: View {
    @StateObject private var viewModel = GameBoardViewModel()  // GameBoardViewModelのインスタンス
    @Environment(\.presentationMode) var presentationMode  // 画面を閉じるための環境変数
    @Environment(\.colorScheme) var colorScheme  // ダークモード対応

    // 基準となるデバイスサイズを設定（iPhone 15のサイズに基づいて）
    let baseWidth: CGFloat = 393  // iPhone 15の幅
    let baseHeight: CGFloat = 852 // iPhone 15の高さ

    var body: some View {
        GeometryReader { geometry in
            let widthRatio = geometry.size.width / baseWidth
            let heightRatio = geometry.size.height / baseHeight
            let scaleFactor = min(widthRatio, heightRatio)  // 縦横比に応じてスケールを調整

            VStack {
                // ヘッダー部分
                ZStack {
                    Rectangle()
                        .fill(viewModel.isX ? Color.red : Color.blue)
                        .frame(height: 120 * scaleFactor)  // 基準高さを元にスケール
                        .cornerRadius(40, corners: [.bottomLeft, .bottomRight])

                    Text(viewModel.winner.isEmpty ? (viewModel.isX ? "Player 1's Turn" : "AI's Turn") : (viewModel.winner == "AI" ? "AI Wins!" : "Player 1 Wins!"))
                        .font(.system(size: 35 * scaleFactor, weight: .bold))  // フォントサイズもスケールに合わせる
                        .foregroundColor(.white)
                        .padding(.top, 50 * scaleFactor)  // テキストの位置を調整
                }
                .padding(.bottom, 10 * scaleFactor)

                // 戻るボタン
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 25 * scaleFactor))  // アイコンのサイズを調整
                            .foregroundColor(colorScheme == .dark ? .white : .black)
                            .padding()
                    }
                    Spacer()
                }
                .padding(.leading, 20 * scaleFactor)
                .padding(.top, -100 * scaleFactor)  // 戻るボタンの位置を調整

                // プレイヤーとAIのアイコン表示
                HStack(spacing: 40 * scaleFactor) {
                    VStack {
                        Circle()
                            .fill(Color.red)
                            .frame(width: 80 * scaleFactor, height: 80 * scaleFactor)
                            .overlay(
                                Image(systemName: "person.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 50 * scaleFactor, height: 50 * scaleFactor)
                                    .foregroundColor(.white)
                            )
                        Text("Player 1")
                            .font(.system(size: 20 * scaleFactor))  // フォントサイズを調整
                    }

                    Text("VS")
                        .font(.system(size: 35 * scaleFactor, weight: .bold))

                    VStack {
                        Circle()
                            .fill(Color.blue)
                            .frame(width: 80 * scaleFactor, height: 80 * scaleFactor)
                            .overlay(
                                Image(systemName: "brain.head.profile")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 50 * scaleFactor, height: 50 * scaleFactor)
                                    .foregroundColor(.white)
                            )
                        Text("AI")
                            .font(.system(size: 20 * scaleFactor))
                    }
                }
                .padding(.vertical, 10 * scaleFactor)

                Spacer()

                // GameBoardViewに必要な引数を渡す
                GameBoardView(
                    board: viewModel.board,
                    winningBlocks: viewModel.winningBlocks,
                    fadedIndex: viewModel.fadedIndex,
                    winner: viewModel.winner,
                    onTap: { index in
                        viewModel.handleTap(at: index) // ViewModelのhandleTapメソッドを呼び出す
                    }
                )
                .frame(height: 500 * scaleFactor)

                Spacer()

                // リセットボタン
                Button(action: {
                    viewModel.resetBoard() // ViewModelのresetBoardメソッドを呼び出す
                }) {
                    Text("RESET")
                        .font(.system(size: 20 * scaleFactor, weight: .bold))
                        .padding()
                        .frame(width: 200 * scaleFactor)
                        .background(Color.yellow)
                        .cornerRadius(30)
                        .foregroundColor(.black)
                }
                .padding(.bottom, 40 * scaleFactor)
            }
            .background(colorScheme == .dark ? Color.black : Color.white)
            .ignoresSafeArea(.all, edges: .top)
            .navigationBarHidden(true)
        }
        .onAppear {
            // AIモードを有効にする
            viewModel.isAiMode = true // AIモードを有効にします
        }
    }
}

struct AIGameView_Previews: PreviewProvider {
    static var previews: some View {
        AIGameView()
            .previewDevice("iPhone 15")
    }
}
