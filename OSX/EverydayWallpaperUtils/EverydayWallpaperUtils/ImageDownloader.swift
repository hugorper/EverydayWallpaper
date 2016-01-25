    
    //
    //  ImageDownloader.swift
    //  EverydayWallpaperUtils
    //
    //  Created by Hugo PEREIRA on 06.12.15.
    //  Copyright © 2015 Hugo PEREIRA. All rights reserved.
    //
    
    import Foundation
    
    public class ImageDownloader {
        let imageFolderConst = "EverydayWallpaper"
        
        let cache = NSCache()
        var fullImagePath: String = ""
        
        public class var sharedLoader: ImageDownloader {
            
            struct Static {
                static let instance: ImageDownloader = ImageDownloader()
            }
            
            return Static.instance
        }
        
        public func downloadImageFromUrl(url: String, fileName: String) -> String {
            if let url = NSURL(string: url) {
                if let data = NSData(contentsOfURL: url) {
                    
                    let destinationPath = NSURL.init(fileURLWithPath: self.WallpaperSavePath).URLByAppendingPathComponent("\(fileName)")
                    
                    do {
                        try data.writeToFile(destinationPath.path!, options: .AtomicWrite)
                    } catch {
                        print(error)
                    }
                    
                    return destinationPath.path!
                    
                }
            }
            
            return ""
        }
        
        public var WallpaperSavePath: String {
            get {
                if fullImagePath.isEmpty {
                    let pictureURLPath = NSURL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.PicturesDirectory, .UserDomainMask, true)[0] as String)
                    
                    fullImagePath = pictureURLPath.URLByAppendingPathComponent(imageFolderConst, isDirectory: true).path!
                }
                
                // Check if EverydayWallpaper image folder exist
                if !NSFileManager.defaultManager().fileExistsAtPath(fullImagePath) {
                    do {
                        try NSFileManager.defaultManager().createDirectoryAtPath(
                            fullImagePath,
                            withIntermediateDirectories: false, attributes: nil)
                    } catch let error as NSError {
                        print(error.localizedDescription);
                    }
                }
                
                return fullImagePath
            }
        }
    }
            