//
//  AppSettings.swift
//  EverydayWallpaperBar
//
//  Created by Hugo PEREIRA on 23.12.15.
//  Copyright © 2015 Hugo Pereira. All rights reserved.
//

import Foundation
import XCGLogger

/*!
* Provide access to application settings, setings are saved auto
*
* Usage:
* Read setting print(AppSettings.sharedInstance.IsWallpaperSaved)
* Save settings AppSettings.sharedInstance.IsWallpaperSaved = true
*/

class AppSettings
{
    static let sharedInstance = AppSettings()
    var userDefaults = NSUserDefaults.standardUserDefaults()
    var prefKey = NSBundle.mainBundle().infoDictionary!["CFBundleIdentifier"] as! String
    var pictureSavePath: String = ""
    private let imageFolderConst = "EverydayWallpaper"
    private let savedWallpaperConst = "SaveWallpapers"
    private let isActivateConst = "Activate"
    private let mainCodePageConst = "MainCodePage"
    private let logLevelConst = "LogLevel"

    var userDefaultDictionary: [String:AnyObject]?

    // Prevents others from using the default '()' initializer for this class.
    private init()
    {
        if self.isFirstUse()
        {
            self.loadDefaultPreference()
        }
        else
        {
            userDefaultDictionary = userDefaults.dictionaryForKey(prefKey)
        }
    }

    internal func isFirstUse() -> Bool
    {
        return (userDefaults.objectForKey(prefKey) == nil)
    }

    private func loadDefaultPreference()
    {
        let prefs = NSBundle.mainBundle().pathForResource("defaultPreference", ofType: "plist")
        let dict = NSDictionary(contentsOfFile: prefs!)

        userDefaults.setObject(dict, forKey: prefKey)
        userDefaults.synchronize()

        userDefaultDictionary = userDefaults.dictionaryForKey(prefKey)
    }

    private func save()
    {
        userDefaults.setObject(userDefaultDictionary, forKey: prefKey)
        userDefaults.synchronize()
    }

    internal func reloadDefaultPreference()
    {
        if self.isFirstUse()
        {
            self.loadDefaultPreference()
        }
        else
        {
            userDefaults.removeObjectForKey(prefKey)
            userDefaults.synchronize()

            self.loadDefaultPreference()
        }
    }

    internal func deleteAllPreference()
    {
        if !self.isFirstUse()
        {
            userDefaults.removeObjectForKey(prefKey)
            userDefaults.synchronize()
        }
    }

    var IsWallpaperSaved: Bool
    {
        get
        {
            return (userDefaultDictionary![savedWallpaperConst]?.boolValue)!
        }
        set
        {
            userDefaultDictionary![savedWallpaperConst] = newValue
            self.save()
        }
    }

    var IsActivate: Bool
    {
        get
        {
            return (userDefaultDictionary![isActivateConst]?.boolValue)!
        }
        set
        {
            userDefaultDictionary![isActivateConst] = newValue
            self.save()
        }
    }

    var MainCodePage: String
    {
        get
        {
            return (userDefaultDictionary![mainCodePageConst])! as! String
        }
        set
        {
            userDefaultDictionary![mainCodePageConst] = newValue
            self.save()
        }
    }

    var LogLevel: XCGLogger.LogLevel
    {
        get
        {
            if NSBundle.mainBundle().infoDictionary![logLevelConst] != nil
            {
                let level: String = NSBundle.mainBundle().infoDictionary![logLevelConst] as! String
                
                if level.lowercaseString.compare("none") == NSComparisonResult.OrderedSame
                {
                    return XCGLogger.LogLevel.None
                }
                else if level.lowercaseString.compare("debug") == NSComparisonResult.OrderedSame
                {
                    return XCGLogger.LogLevel.Debug
                }
                else if level.lowercaseString.compare("severe") == NSComparisonResult.OrderedSame
                {
                    return XCGLogger.LogLevel.Severe
                }
                else
                {
                    return XCGLogger.LogLevel.Severe
                }
            }
            else
            {
                return XCGLogger.LogLevel.Severe
            }
        }
    }

    func setBingUpdateHoursWithMarket(market: String, withTimeString: String)
    {
        userDefaultDictionary![bingSettingNameFromMarket(market)] = withTimeString
        self.save()
    }

    func getBingUpdateHoursWithMarket(market: String) -> String
    {
        return userDefaultDictionary![bingSettingNameFromMarket(market)] as! String
    }

    private func bingSettingNameFromMarket(market: String) -> String
    {
        return "BingTime\(market[0].uppercaseString)\(market[1].lowercaseString)\(market[3 ... 4].uppercaseString)"
    }
}


