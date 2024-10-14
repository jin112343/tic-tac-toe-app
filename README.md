# Tic-Tac-Toe App　(SwiftUI)


## ファイル構成
tic-tac-toe-app/ <br>
├── Models<br>
│   └── GameBoard.swift               // ゲームロジック（ゲームボードの状態、プレイヤーの動き、勝敗判定など）<br>
├── Views<br>
│   ├── OneVsOneGameView.swift        // 1対1のゲーム画面<br>
│   ├── AIGameView.swift              // AI対戦モードのゲーム画面<br>
│   ├── MenuView.swift                // メインメニュー画面<br>
├── Widgets<br>
│   ├── GameBoardView.swift           // ゲームボード全体のUI（マス目のグリッド）<br>
│   ├── XMarkView.swift               // Xマークの描画<br>
│   └── OMarkView.swift               // Oマークの描画<br>
├── AdMob<br>
│   ├── BannerAdView.swift            // バナー広告表示用のウィジェット<br>
│   └── AdRemovalView.swift           // 広告削除に関するロジック<br>
├── Main.swift<br>
└── Assets<br>
    ├── Images.xcassets               // 画像ファイルやアイコンを格納<br>
    └── Sounds                        // ゲーム内で使用されるサウンドファイル<br>




## 機能
- **シンプルで奥深いルール**: 新しい「3つ前が消える」ルールにより、プレイヤーは常に戦略を考える必要があります。
- **全ての年齢層で楽しめる**: 直感的な操作で、子どもから大人まで誰でも楽しめるデザインです。
- **シングルプレイ＆マルチプレイ**: AIとの対戦や、友達・家族との2人プレイモードを搭載。オンライン対戦機能も今後追加予定です。
- **強力なAIとの対戦**: AIの難易度は調整可能で、初心者から上級者まで幅広く楽しめます。
- **洗練されたデザイン**: シンプルかつ美しいUIで快適なゲーム体験を提供します。
- **戦略の幅**: 3つ前のマークが消えることで、何度も戦局が変化し、逆転劇が楽しめます。

## 開発背景

このアプリは、Flutterでの開発経験を活かし、1日でSwiftUIにリライトに挑戦しました。<br>
SwiftUIの特徴を利用して、アプリのUIを直感的に設計し、<br>
iOSアプリケーションの開発における新たな技術の習得を目指しました。<br>
Flutterレスポンス(https://github.com/rai03k/tic-tac-toe-app)<br>

- Flutter版は、Apple Storeにてリリース済みです（[App Store Link](https://apps.apple.com/jp/app/tictactoe/id6723864513)）。
- Android版は今週末にリリース予定です。

## 注意事項

現時点でSwiftUIへのリライトは途中であり、一部にバグや未実装の機能があります。<br>
引き続き改善と機能追加を行っていく予定です。

## 使用技術

- Swift
- SwiftUI
- AVFoundation (音声再生)
- Google AdMob(こちらでは未実装)

## インストール方法

1. このリポジトリをクローンします。
   ```bash
   git clone https://github.com/rai03k/tic-tac-toe-app.git

