//
//  ContentView.swift
//  FamilyFinder
//
//  Created by Jai Sung NOH on 6/1/25.
//

import SwiftUI

struct GameView: View {
    @ObservedObject var viewModel: GameViewModel

    var body: some View {
        VStack {
            Text("사진을 보고 설명에 맞는 사진을 선택하세요!")
                .font(.headline)
                .padding()

            Button("설명 듣기") {
                viewModel.playDescription()
            }
            .padding()

            // 2x2 그리드로 사진 보여주기
            LazyVGrid(columns: [GridItem(), GridItem()]) {
                ForEach(viewModel.currentSet) { photo in
                    Button(action: {
                        viewModel.selectPhoto(photo)
                    }) {
                        Image(uiImage: photo.image)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 120)
                            .border(Color.blue, width: 2)
                    }
                }
            }
            .padding()

            if viewModel.showResult {
                if viewModel.isCorrect {
                    VStack {
                        Image(systemName: "hand.thumbsup.fill")
                            .resizable()
                            .frame(width: 60, height: 60)
                            .foregroundColor(.green)
                        Text("정답! 잘했어요!")
                            .font(.title)
                            .foregroundColor(.green)
                    }
                } else {
                    VStack {
                        Image(systemName: "xmark.octagon.fill")
                            .resizable()
                            .frame(width: 60, height: 60)
                            .foregroundColor(.red)
                        Text("틀렸어요. 다시 시도해보세요!")
                            .font(.title)
                            .foregroundColor(.red)
                    }
                }
                Button("다음 문제") {
                    viewModel.startGame()
                }
                .padding()
            }
        }
        .onAppear {
            if viewModel.photos.isEmpty {
                viewModel.loadSavedPhotos()
            }
            viewModel.startGame()
        }
    }
}



