//
//  ImageLoaderImpl.swift
//  YouTube-Client
//
//  Created by Малиль Дугулюбгов on 05.05.2023.
//

import UIKit
import Foundation

/// Image Loader implementation
///
/// Loads images to the specified address, caching the execution result.
actor ImageLoaderImpl: ImageLoader {
    
    //MARK: Properties
    
    private var cache = NSCache<NSURL, NSData>()
    
    //MARK: - Initialization
    
    init(cacheCountLimit: Int) {
        cache.countLimit = cacheCountLimit
    }
    
    //MARK: - Methods
    
    /// Downloads the image to the specified address from the network or from the cache
    ///
    /// Performs asynchronous image upload from the network at the specified URL,
    /// or takes the image from the cache if the image has already been uploaded
    /// to such an address before
    ///
    /// Throws a `URLError` if an error occurs during the image loading stages
    ///
    /// - Parameter url: The URL where the image is located
    /// - Returns: An instance of an image with the `UIImage` type
    func loadImage(from url: URL) async throws -> UIImage {
        if let data = lookupCache(for: url), let image = UIImage(data: data) {
            return image
        } else {
            let data = try await loadData(from: url)
            
            guard let image = UIImage(data: data) else {
                throw URLError(.cannotDecodeContentData)
            }
            
            updateCacheWithData(data, for: url)
            return image
        }
    }
}

//MARK: - Private methods

private extension ImageLoaderImpl {
    func loadData(from url: URL) async throws -> Data  {
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            try response.handle()
            return data
        } catch {
            throw error
        }
    }
    
    func lookupCache(for url: URL) -> Data? {
        cache.object(forKey: url as NSURL) as? Data
    }
    
    func updateCacheWithData(_ data: Data, for url: URL) {
        guard cache.object(forKey: url as NSURL) == nil else { return }
        cache.setObject(data as NSData, forKey: url as NSURL)
    }
}
