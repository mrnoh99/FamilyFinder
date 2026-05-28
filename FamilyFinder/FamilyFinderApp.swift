//
//  FamilyFinderApp.swift
//  FamilyFinder
//
//  Created by Jai Sung NOH on 6/1/25.
//

import SwiftUI

@main
struct PhotoGameApp: App {
    @StateObject var viewModel = GameViewModel()

    var body: some Scene {
        WindowGroup {
            TabView {
                GameView(viewModel: viewModel)
                    .tabItem { Label("게임", systemImage: "gamecontroller") }
                // 아래처럼 viewModel 파라미터를 받도록 선언되어 있어야 함
                PhotoAddView(viewModel: viewModel)
                    .tabItem { Label("사진/설명 추가", systemImage: "plus") }
            }
        }
    }
}
