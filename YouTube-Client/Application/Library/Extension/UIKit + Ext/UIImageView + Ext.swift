//
//  UIImageView + Ext.swift
//  YouTube-Client
//
//  Created by Малиль Дугулюбгов on 05.05.2023.
//

import UIKit

extension UIImageView {
    static let imageLoader: ImageLoader = ImageLoaderImpl(cacheCountLimit: 500)
    
    @MainActor
    func loadImage(from url: URL) async throws {
        self.image = try await Self.imageLoader.loadImage(from: url)
    }
}
