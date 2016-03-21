//
//  FindFile.swift
//  EverydayWallpaperUtils
//
//  Created by Hugo PEREIRA on 28.01.16.
//  Copyright © 2016 Hugo PEREIRA. All rights reserved.
//

import Foundation

public class SearchFile
{

    public static func existFromDirectory(path: String, withPrefix: String) -> Bool
    {
        let fileManager = NSFileManager.defaultManager()

        do
        {
            let items = try fileManager.contentsOfDirectoryAtPath(path)

            for item in items
            {
                if item.hasPrefix(withPrefix)
                {
                    return true
                }
            }
        }
        catch
        {
            return false
        }

        return false
    }

    public static func listOfFileToDelete(path: String, keepFileCount: Int) -> [String]
    {
        let keys = [NSURLIsDirectoryKey, NSURLLocalizedNameKey]
        let validateWallpaper = "\(Constants.Naming.FileNameSeparator)\(Constants.Naming.Bing)\(Constants.Naming.FileNameSeparator)"
        var filesToDelete: [String] = []
        var urlToDelete: [NSURL] = []
        var lastFileDatePart: String = ""
        var tmpKeepCount: Int = 0


        do
        {
            let directoryUrls = try NSFileManager.defaultManager().contentsOfDirectoryAtURL(NSURL(fileURLWithPath: path), includingPropertiesForKeys: keys, options: .SkipsHiddenFiles)

            let urls = directoryUrls.filter
            {
                $0.pathExtension == "jpg"
            }.map
            {
                $0
            }.sort({ $0.lastPathComponent > $1.lastPathComponent })


            for url in urls
            {
                do
                {
                    let resourceValues = try url.resourceValuesForKeys(keys)

                    if let isDirectory = resourceValues[NSURLIsDirectoryKey] as? NSNumber
                    {
                        if !isDirectory.boolValue
                        {
                            if url.lastPathComponent!.rangeOfString(validateWallpaper) != nil
                            {
                                if url.lastPathComponent![0 ... 7].isValidShortDateString()
                                {
                                    urlToDelete.append(url)
                                }
                            }
                        }
                    }
                }
                catch
                {
                }
            }
        }
        catch
        {
            filesToDelete = []
        }

        for url in urlToDelete
        {
            if tmpKeepCount < keepFileCount
            {
                if lastFileDatePart != url.lastPathComponent![0 ... 7]
                {
                    tmpKeepCount++
                    lastFileDatePart = url.lastPathComponent![0 ... 7]
                }
            }
            else if lastFileDatePart != url.lastPathComponent![0 ... 7]
            {
                filesToDelete.append(url.description)
            }
        }

        return filesToDelete
    }
}