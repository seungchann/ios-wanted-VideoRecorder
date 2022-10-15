//
//  ThumbnailMaker.swift
//  VideoRecorder
//
//  Created by 유영훈 on 2022/10/12.
//

import AVFoundation
import UIKit

class ThumbnailMaker {
    
    static let shared = ThumbnailMaker()
    private init() { }
    
    func imageGenerator(asset: AVAsset) -> AVAssetImageGenerator {
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        imageGenerator.appliesPreferredTrackTransform = true
        imageGenerator.maximumSize = CGSize(width: 600, height: 600)

        // 사진을 캡쳐하는 시간의 오차와 연관된 옵션입니다.
        // 별도로 설정하지 않을 경우 offset 값과 실제 사진 결과 시간에 차이가 있을 수 있습니다.
        imageGenerator.requestedTimeToleranceAfter = CMTimeMake(value: 1, timescale: 600)
        imageGenerator.requestedTimeToleranceBefore = CMTimeMake(value: 1, timescale: 600)
        return imageGenerator
    }
    
    func generateThumnailAsync(url: URL, startOffsets: [Double],
                               completion: @escaping (UIImage) -> Void) {
        let asset = AVAsset(url: url)
        let imageGenerator = self.imageGenerator(asset: asset)

        let time: [NSValue] = startOffsets.compactMap {
            return NSValue(time: CMTimeMakeWithSeconds(Float64($0), preferredTimescale: asset.duration.timescale))
        }

        imageGenerator.generateCGImagesAsynchronously(forTimes: time) { _, image, _, _, _ in
            // 4.
            if let image = image {
                completion(UIImage(cgImage: image))
            }
        }
    }
}
