//
//  ImageDownloader.swift
//  EverydayWallpaperUtils
//
//  Created by Hugo PEREIRA on 06.12.15.
//  Copyright © 2015 Hugo PEREIRA. All rights reserved.
//


import Foundation



class ImageDownloader {
    let ImageFolder = "EverydayWallpaper"
    
    let cache = NSCache()
    
    class var sharedLoader : ImageDownloader {
        struct Static {
            static let instance : ImageDownloader = ImageDownloader()
        }
        return Static.instance
    }
    
    
    func downloadImageFromUrl(url: String, fileName: String) -> String {
        if let url = NSURL(string: url) {
            if let data = NSData(contentsOfURL: url){
                let pictureURLPath = NSURL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.PicturesDirectory, .UserDomainMask, true)[0] as String)
                
                do {
                    let fullImagePath: String = pictureURLPath.URLByAppendingPathComponent(ImageFolder, isDirectory: true).path!
                    
                    // Check if EverydayWallpaper image folder exist
                    if !NSFileManager.defaultManager().fileExistsAtPath(fullImagePath)  {
                        try NSFileManager.defaultManager().createDirectoryAtPath(
                            fullImagePath,
                            withIntermediateDirectories: false, attributes: nil)
                    }
                    
                    let destinationPath = pictureURLPath.URLByAppendingPathComponent("\(ImageFolder)/\(fileName)")
                    
                    do {
                        //try data.writeToFile("\(destinationPath)",  options: .AtomicWrite)
                        try data.writeToFile(destinationPath.path!,  options: .AtomicWrite)
                    } catch {
                        print(error)
                    }

                    return destinationPath.path!
                    
                } catch let error as NSError {
                    print(error.localizedDescription);
                }
            }
        }

        return ""
    }
    
}

