//
//  MenuView.swift .swift
//  tic-tac-toe-app
//
//  Created by mizoi.jin on 2024/10/14.
//

import SwiftUI

struct MenuView: View {
    @AppStorage("adsRemoved") var adsRemoved: Bool = false

    var body: some View {
        NavigationView {  // NavigationViewで全体をラップ
            VStack(spacing: 40) {  // ボタン間のスペースを設定
                Spacer()

                // 1 vs AI ボタン
                NavigationLink(destination: AIGameView()) {
                    MenuButtonView(
                        icon1: "person",
                        icon2: "brain.head.profile",
                        text: "1 vs AI",
                        colors: [Color.blue, Color.blue.opacity(0.7)]
                    )
                }

                // 1 vs 1 ボタン
                NavigationLink(destination: OneVsOneGameView()) {
                    MenuButtonView(
                        icon1: "person",
                        icon2: "person",
                        text: "1 vs 1",
                        colors: [Color.red, Color.blue]
                    )
                }

                // Coming Soon ボタン
                MenuButtonView(
                    icon1: "person",
                    icon2: "globe",
                    text: "coming soon",
                    colors: [Color.gray]
                )

                // 広告削除ボタン
                NavigationLink(destination: AdRemovalView()) {
                    MenuButtonView(
                        icon1: "iphone",
                        icon2: "nosign",
                        text: "-",
                        colors: [Color.orange, Color.orange.opacity(0.7)]
                    )
                }

                Spacer()

 
            }
            .padding()
        }
    }
}

// 再利用可能なメニューボタンビュー
struct MenuButtonView: View {
    let icon1: String
    let icon2: String
    let text: String
    let colors: [Color]
    
    var body: some View {
        HStack {
            Image(systemName: icon1)
                .font(.system(size: 60))
                .foregroundColor(.white)
            Spacer()
            Text(text)
                .font(.system(size: text == "coming soon" ? 15 : 35, weight: .bold))
                .foregroundColor(.white)
                .layoutPriority(1)
            Spacer()
            Image(systemName: icon2)
                .font(.system(size: 60))
                .foregroundColor(.white)
        }
        .padding()
        .frame(maxWidth: .infinity, minHeight: 80, maxHeight: 80)  // すべてのボタンの高さを80に固定
        .background(LinearGradient(gradient: Gradient(colors: colors), startPoint: .leading, endPoint: .trailing))
        .cornerRadius(30)
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
    }
}
