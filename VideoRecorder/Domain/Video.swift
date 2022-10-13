//
//  Video.swift
//  VideoRecorder
//
//  Created by channy on 2022/10/12.
//

import Foundation

struct Video: Codable {
    let title: String
    let releaseDate: Date
    let duration: String
    let thumbnailPath: String
}
