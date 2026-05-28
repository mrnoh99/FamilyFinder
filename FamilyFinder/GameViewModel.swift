//
//  Untitled.swift
//  FamilyFinder
//
//  Created by Jai Sung NOH on 6/1/25.
//

import AVFoundation
import Foundation
import SwiftUI

struct GamePhoto: Identifiable, Equatable {
    let id = UUID()
    var image: UIImage
    var audioURL: URL
}

class GameViewModel: ObservableObject {
    @Published var photos: [GamePhoto] = []
    @Published var currentSet: [GamePhoto] = []
    @Published var showResult = false
    @Published var isCorrect = false

    private var correctPhoto: GamePhoto?
    private var audioPlayer: AVAudioPlayer?

    func addPhoto(_ photo: GamePhoto) {
        photos.append(photo)
    }

    func startGame() {
        showResult = false
        isCorrect = false
        guard photos.count >= 4 else {
            currentSet = photos
            correctPhoto = photos.first
            return
        }
        currentSet = Array(photos.shuffled().prefix(4))
        correctPhoto = currentSet.randomElement()
    }

    func playDescription() {
        guard let url = correctPhoto?.audioURL else { return }
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.play()
        } catch {
            print("오디오 재생 실패: \(error)")
        }
    }

    func selectPhoto(_ photo: GamePhoto) {
        guard !showResult else { return }
        isCorrect = photo.id == correctPhoto?.id
        showResult = true
    }
    
    func saveImageToFile(_ image: UIImage) -> URL? {
        guard let data = image.jpegData(compressionQuality: 0.8) else { return nil }
        let filename = UUID().uuidString + ".jpg"
        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent(filename)
        
        do {
            try data.write(to: url)
            return url
        } catch {
            print("이미지 저장 실패: \(error)")
            return nil
        }
    }
}



extension GameViewModel {
    func loadSavedPhotos() {
        let documentURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        do {
            let files = try FileManager.default.contentsOfDirectory(at: documentURL,
                                                                   includingPropertiesForKeys: nil)
            for file in files {
                if file.pathExtension == "m4a" {
                    let imageName = file.deletingPathExtension().lastPathComponent
                    let imagePath = documentURL.appendingPathComponent("\(imageName).jpg")
                    
                    // 옵셔널 바인딩 수정
                    if FileManager.default.fileExists(atPath: imagePath.path),
                       let image = UIImage(contentsOfFile: imagePath.path) {
                        photos.append(GamePhoto(image: image, audioURL: file))
                    }
                }
            }
        } catch {
            print("파일 불러오기 오류: \(error)")
        }
    }
}
