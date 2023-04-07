//
//  SearchResponse.swift
//  YouTube Data API
//
//  Created by Alice on 2023/3/29.
//

import Foundation

//透過Codable將影片清單的JSON資料轉成自訂型別
struct SearchResponse: Codable {
    let nextPageToken: String
    let items: [Item]
    
    struct Item: Codable {
        let snippet: Snippet
        
        struct Snippet: Codable {
            let title: String
            let description: String
            let thumbnails: Thumbnail
            let resourceId: ResourceID
            
            struct Thumbnail: Codable {
                let medium: ThumbnailImage
                let standard: ThumbnailImage
                let maxres: ThumbnailImage
                
                struct ThumbnailImage: Codable {
                    let url: URL
                }
            }
            
            struct ResourceID: Codable {
                let videoId: String
            }
        }
    }
}
