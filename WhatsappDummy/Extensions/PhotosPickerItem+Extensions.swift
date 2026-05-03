//
//  PhotosPickerItem+Extensions.swift
//  WhatsappDummy
//
//  Created by abhay mundhara on 13/06/2024.
//

import Foundation
import PhotosUI
import SwiftUI

extension PhotosPickerItem {
    var isVideo: Bool {
        // Fix: removed UTType.avi which doesn't exist in UniformTypeIdentifiers
        let videoUTTypes: [UTType] = [
            .video,
            .mpeg2Video,
            .mpeg4Movie,
            .movie,
            .quickTimeMovie,
            .audiovisualContent,
            .mpeg,
            .appleProtectedMPEG4Video
        ]
        return videoUTTypes.contains(where: supportedContentTypes.contains)
    }
}
