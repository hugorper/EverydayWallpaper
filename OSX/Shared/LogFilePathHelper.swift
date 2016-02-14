//
//  LogFilePathHelper.swift
//  EverydayWallpaperUtils
//
//  Created by Hugo PEREIRA on 11.02.16.
//  Copyright © 2016 Hugo PEREIRA. All rights reserved.
//

import Foundation

public class LogFilePathUtilHelper {
    static let bundleIdentifier = NSBundle.mainBundle().infoDictionary!["CFBundleIdentifier"] as! String
    
    public static func UserLibraryLogFilePathForApp(applicationName: String) -> String
    {
        let libPath = NSURL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.LibraryDirectory, .UserDomainMask, true)[0] as String)
        let logPath = libPath.URLByAppendingPathComponent("Logs/\(applicationName)/", isDirectory: true).path!
        let logFilePath = logPath.stringByAppendingString("\(self.bundleIdentifier).log")
        
        if !NSFileManager.defaultManager().fileExistsAtPath(logPath) {
            do {
                try NSFileManager.defaultManager().createDirectoryAtPath(
                    logPath,
                    withIntermediateDirectories: false, attributes: nil)
            } catch let error as NSError {
                print(error.localizedDescription);
            }
        }
        
        return logFilePath
    }
}