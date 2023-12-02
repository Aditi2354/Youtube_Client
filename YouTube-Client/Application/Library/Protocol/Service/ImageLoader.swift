//
//  ImageLoader.swift
//  YouTube-Client
//
//  Created by Малиль Дугулюбгов on 05.05.2023.
//

import UIKit

/// A protocol that provides an interface for the image upload service from the network
protocol ImageLoader {
    
    /// Downloads an image from the network at the specified URL
    ///
    /// Called in an asynchronous context, creating a task to load data at the specified URL.
    /// Throws an error if it occurs during the download process
    ///
    /// - Parameter url: The URL where the image is located
    /// - Returns: An instance of an image with the UIImage type
    func loadImage(from url: URL) async throws -> UIImage
}
