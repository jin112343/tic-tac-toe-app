//
//  GameBoard.swift
//  tic-tac-toe-app
//
//  Created by mizoi.jin on 2024/10/14.
//

import AVFoundation
import SwiftUI

@MainActor
class GameBoardViewModel: ObservableObject {
    // ボードの初期状態を保持する配列
    @Published var board: [String] = Array(repeating: " ", count: 9)
    // 現在のプレイヤーがXかどうかを判定
    @Published var isX: Bool = true
    // 勝者の名前を保持
    @Published var winner: String = ""
    // 勝利したラインのインデックスを保持
    @Published var winningBlocks: [Int] = []
    // 薄くするマークのインデックス
    @Published var fadedIndex: Int?
    // 1vsAIモードかどうかを示すフラグ
    @Published var isAiMode: Bool = false
    // リセット中かどうかを判定するフラグ
    @Published var isResetting: Bool = false

    private var xMoves: [Int] = []  // Xプレイヤーの動きを追跡
    private var oMoves: [Int] = []  // Oプレイヤーの動きを追跡
    private var audioPlayer: AVAudioPlayer?  // 音声プレイヤー
    private let soundFiles = ["audio/do", "audio/re", "audio/mi", "audio/fa", "audio/so", "audio/la", "audio/si"]  // 音階のリスト
    private var tapCount: Int = 0  // タップ回数を管理して音階を変更する
    private var maxDepth: Int = 4  // ミニマックスアルゴリズムの深さを設定

    init() {
        setupAudioPlayer()  // オーディオプレイヤーの初期設定
    }

    // オーディオプレイヤーの初期設定
    private func setupAudioPlayer() {
        // 初期音階のファイルパスを取得
        guard let sound = Bundle.main.path(forResource: "audio/do", ofType: "mp3") else { return }
        let url = URL(fileURLWithPath: sound)
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)  // オーディオプレイヤーを初期化
        } catch {
            print("Failed to load sound: \(error)")  // エラーメッセージ
        }
    }

    // ボードをリセットするメソッド
    func resetBoard() {
        isResetting = true  // リセット中フラグを立てる
        board = Array(repeating: " ", count: 9)  // ボードをリセット
        winner = ""  // 勝者をリセット
        winningBlocks = []  // 勝利ラインをリセット
        xMoves = []  // Xプレイヤーの動きをリセット
        oMoves = []  // Oプレイヤーの動きをリセット
        fadedIndex = nil  // 薄いマークのリセット
        tapCount = 0  // タップカウントもリセット
        isX = true  // 必ずXプレイヤーから開始

        Task {
            try await Task.sleep(nanoseconds: 500_000_000)  // 500msの遅延
            isResetting = false  // リセット完了
        }
    }

    // プレイヤーの動きを処理するメソッド
    func handleTap(at index: Int) {
        // 無効なタップの場合は終了
        guard board[index] == " ", winner.isEmpty else { return }

        let mark = isX ? "X" : "O"  // 現在のプレイヤーのマークを決定
        board[index] = mark  // ボードにマークを反映

        // マークを記録
        if isX {
            xMoves.append(index)
        } else {
            oMoves.append(index)
        }

        playTapSound()  // タップ音を再生
        _handleMove()  // マークの薄くする処理
        winner = checkWinner()  // 勝者を確認

        // 4つ目のマークを置いた場合、最古のマークを削除
        if (isX && xMoves.count > 3) || (!isX && oMoves.count > 3) {
            let indexToRemove = isX ? xMoves.removeFirst() : oMoves.removeFirst()
            board[indexToRemove] = " "  // ボード上のマークを削除
        }

        // 勝者が決定した場合
        if winner.isEmpty {
            isX.toggle()  // プレイヤーを交代

            // AIの動作を1vs1の時に無効にする
            if isAiMode && !isX {
                Task {
                    try await Task.sleep(nanoseconds: 500_000_000)  // 遅延を追加
                    aiMove()  // AIの手を実行
                }
            }
        } else {
            playWinSound()  // 勝利音を再生
        }
    }

    // 勝者を確認するメソッド
    private func checkWinner() -> String {
        let winPatterns = [
            [0, 1, 2], [3, 4, 5], [6, 7, 8],  // 行
            [0, 3, 6], [1, 4, 7], [2, 5, 8],  // 列
            [0, 4, 8], [2, 4, 6]               // 斜め
        ]

        // 勝利パターンをチェック
        for pattern in winPatterns {
            let first = board[pattern[0]]
            if first != " " && first == board[pattern[1]] && first == board[pattern[2]] {
                winningBlocks = pattern  // 勝利したマスのインデックスを保持
                return first  // 勝者を返す
            }
        }

        return board.contains(" ") ? "" : "Draw"  // 引き分け判定
    }

    // AIの手を実行するメソッド
    private func aiMove() {
        let bestMove = findBestMove()
        if bestMove != -1 {
            handleTap(at: bestMove)  // AIの最適な手を実行
        }
    }

    // AIの最適な手を探索するメソッド
    private func findBestMove() -> Int {
        var bestMove = -1
        var bestScore = -1000

        // ボードを探索して最適な手を見つける
        for i in 0..<board.count {
            if board[i] == " " {
                board[i] = "O"  // AIのマークは "O"
                let score = minimax(board, depth: 0, isMaximizing: false)
                board[i] = " "  // ボードを元に戻す

                if score > bestScore {
                    bestScore = score  // 最大スコアを更新
                    bestMove = i  // 最適な手を更新
                }
            }
        }
        return bestMove  // 最適な手を返す
    }

    // ミニマックスアルゴリズムの実装
    private func minimax(_ board: [String], depth: Int, isMaximizing: Bool) -> Int {
        let result = checkWinner()  // 勝者を確認
        if result == "O" {
            return 10 - depth  // AIが勝利
        } else if result == "X" {
            return depth - 10  // プレイヤーが勝利
        } else if result == "Draw" {
            return 0  // 引き分け
        }

        // 深さ制限に達した場合、評価を行わない
        if depth >= maxDepth {
            return 0
        }

        // AIの最適な手を探索
        if isMaximizing {
            var bestScore = -1000
            for i in 0..<board.count {
                if board[i] == " " {
                    var newBoard = board
                    newBoard[i] = "O"  // AIの手
                    let score = minimax(newBoard, depth: depth + 1, isMaximizing: false)
                    bestScore = max(bestScore, score)  // 最大スコアを更新
                }
            }
            return bestScore
        } else {
            // プレイヤーの最適な手を探索
            var bestScore = 1000
            for i in 0..<board.count {
                if board[i] == " " {
                    var newBoard = board
                    newBoard[i] = "X"  // プレイヤーの手
                    let score = minimax(newBoard, depth: depth + 1, isMaximizing: true)
                    bestScore = min(bestScore, score)  // 最小スコアを更新
                }
            }
            return bestScore
        }
    }

    // タップ音を再生するメソッド
    private func playTapSound() {
        tapCount += 1
        if let path = Bundle.main.path(forResource: soundFiles[tapCount % soundFiles.count], ofType: "mp3") {
            let url = URL(fileURLWithPath: path)
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: url)
                audioPlayer?.play()  // タップ音を再生
            } catch {
                print("Error playing sound: \(error)")  // エラーメッセージ
            }
        }
    }

    // 無効なタップ音を再生するメソッド
    private func playInvalidTapSound() {
        if let path = Bundle.main.path(forResource: "audio/not", ofType: "mp3") {
            let url = URL(fileURLWithPath: path)
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: url)
                audioPlayer?.play()  // 無効タップ音を再生
            } catch {
                print("Error playing sound: \(error)")  // エラーメッセージ
            }
        }
    }

    // 勝利音を再生するメソッド
    private func playWinSound() {
        if let path = Bundle.main.path(forResource: "audio/complete", ofType: "mp3") {
            let url = URL(fileURLWithPath: path)
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: url)
                audioPlayer?.play()  // 勝利音を再生
            } catch {
                print("Error playing sound: \(error)")  // エラーメッセージ
            }
        }
    }

    // 薄くする処理を行うメソッド
    private func _handleMove() {
        // Xのターンで、Oの最初のマークを薄くする
        if !isX && xMoves.count >= 3 {
            fadedIndex = xMoves[0]
        }
        // Oのターンで、Xの最初のマークを薄くする
        else if isX && oMoves.count >= 3 {
            fadedIndex = oMoves[0]
        } else {
            fadedIndex = nil  // フェードなし
        }
    }
}
