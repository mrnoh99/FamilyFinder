//
//  Untitled.swift
//  FamilyFinder
//
//  Created by Jai Sung NOH on 6/1/25.
//

import PhotosUI
import SwiftUI

import SwiftUI
import PhotosUI

struct PhotoAddView: View {
    @ObservedObject var viewModel: GameViewModel
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImage: UIImage? = nil

    var body: some View {
        VStack {
            PhotosPicker(
                selection: $selectedItem,
                matching: .images,
                photoLibrary: .shared()
            ) {
                Label("사진 선택", systemImage: "photo")
            }
            .onChange(of: selectedItem) { newItem in
                if let newItem {
                    Task {
                        if let data = try? await newItem.loadTransferable(type: Data.self),
                           let uiImage = UIImage(data: data) {
                            selectedImage = uiImage
                        }
                    }
                }
            }

            if let image = selectedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
            }
        }
    }
}
