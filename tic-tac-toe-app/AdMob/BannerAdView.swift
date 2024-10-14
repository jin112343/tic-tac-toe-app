//
//  BannerAdView.swift
//  tic-tac-toe-app
//
//  Created by mizoi.jin on 2024/10/14.
//

import SwiftUI
import GoogleMobileAds
import UIKit

struct BannerAdView: UIViewRepresentable {
    @Binding var adsRemoved: Bool  // 広告削除のフラグ
    
    class Coordinator: NSObject, GADBannerViewDelegate {
        var parent: BannerAdView

        init(parent: BannerAdView) {
            self.parent = parent
        }

        func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
            print("Banner ad loaded successfully.")
        }

        func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
            print("Failed to load banner ad: \(error.localizedDescription)")
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }

    func makeUIView(context: Context) -> GADBannerView {
        let bannerView = GADBannerView(adSize: GADAdSizeBanner)
        bannerView.adUnitID = getAdUnitID()  // デバイスごとに異なる広告ユニットIDを使用
        bannerView.rootViewController = UIApplication.shared.windows.first?.rootViewController
        bannerView.delegate = context.coordinator
        if !adsRemoved {
            let request = GADRequest()
            bannerView.load(request)
        }
        return bannerView
    }

    func updateUIView(_ uiView: GADBannerView, context: Context) {
        // 広告削除されている場合は広告を非表示に
        if adsRemoved {
            uiView.isHidden = true
        } else {
            uiView.isHidden = false
        }
    }

    private func getAdUnitID() -> String {
        #if targetEnvironment(simulator)
        return "ca-app-pub-3940256099942544/2934735716"  // テスト用の広告ユニットID
        #else
        if UIDevice.current.userInterfaceIdiom == .phone {
            return "ca-app-pub-1187210314934709/7887834192"  // 実機用のiOS広告ユニットID
        }
        #endif
    }
}

