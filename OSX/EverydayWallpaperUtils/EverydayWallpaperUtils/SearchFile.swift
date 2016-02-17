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

}