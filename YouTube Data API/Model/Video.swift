//
//  Video.swift
//  YouTube Data API
//
//  Created by Alice on 2023/3/29.
//

import Foundation

//建立表格要呈現的影片資料，包含：影片縮圖、標題、影片ID與isFavorite四個變數。
struct Video {
    var thumbnailUrl: URL
    var title: String
    var videoID: String
    var isFavorite: Bool = false    //預設為false
}
