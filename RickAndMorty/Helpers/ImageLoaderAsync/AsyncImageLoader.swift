//
//  AsyncImageLoader.swift
//  RickAndMorty
//
//  Created by Josep Cerdá Penadés on 11/6/24.
//

import SwiftUI

struct AsyncImageLoader: View {

    @State private var loader: ImageLoader
    private var fileId: String?
    private var url: URL?

    init(loader: ImageLoader = ImageLoader(),
         url: URL?,
         fileId: String? = nil) {
        self.loader = loader
        self.loader.fileId = fileId
        self.url = url
        if let url {
            loader.loadImage(with: url)
        }
    }

    var body: some View {
        if let image = loader.image {
            Image(uiImage: image)
                .resizable()
                .scaledToFit()
                .transition(.opacity.animation(.default))
        } else {
            ZStack {
                // Here can load a placeholder image
            }
            .scaledToFit()
            .background(.black.opacity(0.2))
            .onAppear {
                guard let url = loader.imageURL else { return }
                loader.loadImage(with: url)
            }
        }
    }

    var imageLoaded: UIImage {
        loader.image ?? UIImage()
    }
}
