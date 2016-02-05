//
//  Constants.swift
//  EverydayWallpaperUtils
//
//  Created by Hugo PEREIRA on 30.01.16.
//  Copyright © 2016 Hugo PEREIRA. All rights reserved.
//

import Foundation

public struct Constants {
    public struct Naming {
        public static let ResolutionSeparator = "x"
        public static let FileNameSeparator = "-"
        public static let Bing = "Bing"
        public static let NationalGeographic = "NationalGeographic"
    }
    
    public struct Default {
        public static let None = "none"
    }
}

public enum DownloadStatus: ErrorType {
    case NetworkNotReachable
    case UndefinedError
    case Success
}