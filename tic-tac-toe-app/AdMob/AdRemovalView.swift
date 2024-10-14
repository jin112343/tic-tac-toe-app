//
//  AdRemovalView.swift
//  tic-tac-toe-app
//
//  Created by mizoi.jin on 2024/10/14.
//

import SwiftUI

struct AdRemovalView: View {
    @State private var progress: Int = 1  // 進捗状況
    @State private var hasReviewed: Bool = false  // レビューが完了したかどうか
    @State private var adsRemoved: Bool = false  // 広告が削除されたかどうか
    @State private var selectedLanguage: String = "en"  // 言語選択
    let languages = ["en", "ja", "es", "zh_CN", "fr", "de", "pt", "ko"]  // 言語オプション

    var body: some View {
        NavigationView {  // NavigationViewで全体をラップ
            VStack {
                Spacer()

                // 進捗状況
                Text(translate("progressDescription"))
                    .font(.title2)
                    .padding()

                // 進捗バー
                ProgressView(value: Double(progress), total: 3)
                    .progressViewStyle(LinearProgressViewStyle(tint: progress == 3 ? Color.orange : Color.blue))
                    .frame(height: 20)
                    .padding([.leading, .trailing])

                Text("\(progress) / 3 \(translate("stepsCompleted"))")
                    .font(.headline)
                    .padding(.top, 10)

                Spacer().frame(height: 40)

                // レビューボタンまたは動画視聴ボタン
                if progress < 3 {
                    if !hasReviewed {
                        // レビューボタン
                        Button(action: {
                            writeReview()
                        }) {
                            HStack {
                                Image(systemName: "pencil")
                                Text(translate("reviewButton"))
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                        }
                        .padding(.horizontal)

                        // または、動画視聴
                        Text(translate("orText"))
                            .font(.subheadline)
                            .padding(.top, 20)

                        Button(action: {
                            watchVideo()
                        }) {
                            HStack {
                                Image(systemName: "play.circle")
                                Text(translate("watchVideoButton"))
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                        }
                        .padding(.horizontal)
                    } else {
                        // 動画視聴ボタン
                        Button(action: {
                            watchVideo()
                        }) {
                            HStack {
                                Image(systemName: "play.circle")
                                Text(translate("watchVideoButton"))
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                        }
                        .padding(.horizontal)
                    }
                }

                // 広告削除完了メッセージ
                if progress == 3 {
                    Text(translate("adsRemovedMessage"))
                        .font(.headline)
                        .foregroundColor(.orange)
                        .padding(.top, 40)
                }

                Spacer()
            }
            .padding()
            .navigationTitle("Remove Ads")
            .navigationBarTitleDisplayMode(.inline)  // タイトルをインラインで表示
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    // 言語選択のPicker
                    Picker(selection: $selectedLanguage, label: Text(languageLabel(selectedLanguage))) {
                        ForEach(languages, id: \.self) { lang in
                            Text(languageLabel(lang)).tag(lang)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle()) // スタック型のナビゲーションビューを使用
    }

    // 言語オプションのラベルを表示
    private func languageLabel(_ code: String) -> String {
        switch code {
        case "en": return "English"
        case "ja": return "日本語"
        case "es": return "Español"
        case "zh_CN": return "简体中文"
        case "fr": return "Français"
        case "de": return "Deutsch"
        case "pt": return "Português"
        case "ko": return "한국어"
        default: return "English"
        }
    }

    // 言語ごとの翻訳を取得
    private func translate(_ key: String) -> String {
        let translations = [
            "en": ["progressDescription": "Progress to Remove Ads", "reviewButton": "Write a Review", "watchVideoButton": "Watch Video to Remove Ads", "stepsCompleted": "steps completed", "orText": "or", "adsRemovedMessage": "Ads have been removed!"],
            "ja": ["progressDescription": "広告を削除するための進捗", "reviewButton": "レビューを書く", "watchVideoButton": "動画を見て広告を削除", "stepsCompleted": "ステップが完了しました", "orText": "または", "adsRemovedMessage": "広告が削除されました！"]
            // #TODO　他の言語も入れる。(今後言語管理のファイル作成する。)
            
            
        ]
        return translations[selectedLanguage]?[key] ?? translations["en"]![key]!
    }

    // レビューを書くアクション
    private func writeReview() {
        hasReviewed = true
        progress = 2
    }

    // 動画視聴アクション
    private func watchVideo() {
        if progress < 3 {
            progress += 1
        }
    }
}

struct AdRemovalView_Previews: PreviewProvider {
    static var previews: some View {
        AdRemovalView()
    }
}
