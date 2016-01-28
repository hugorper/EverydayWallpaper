//
//  FindFile.swift
//  EverydayWallpaperUtils
//
//  Created by Hugo PEREIRA on 28.01.16.
//  Copyright © 2016 Hugo PEREIRA. All rights reserved.
//

import Foundation

public class SearchFile {
    
    static func existFromDirectory (path: String, withPrefix: String) -> Bool {
        let fm = NSFileManager.defaultManager()
        let path = NSBundle.mainBundle().resourcePath!
        
        do {
            let items = try fm.contentsOfDirectoryAtPath(path)
            
            for item in items {
                if item.hasPrefix(withPrefix) {
                    return true
                }
            }
        } catch {
            return false
        }
        
        return false
    }
    
}