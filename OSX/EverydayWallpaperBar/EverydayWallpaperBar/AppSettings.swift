//
//  AppSettings.swift
//  EverydayWallpaperBar
//
//  Created by Hugo PEREIRA on 23.12.15.
//  Copyright © 2015 Hugo Pereira. All rights reserved.
//

import Foundation

/*!
* Provide access to application settings, setings are saved auto
*
* Usage:
* Read setting print(AppSettings.sharedInstance.IsWallpaperSaved)
* Save settings AppSettings.sharedInstance.AlternateCodePage = "my value"
*/
class AppSettings {
    static let sharedInstance = AppSettings()
    var userDefaults = NSUserDefaults.standardUserDefaults()
    var prefKey = NSBundle.mainBundle().infoDictionary!["CFBundleIdentifier"] as! String
    var savedWallpaperConst = "SaveWallpapers"
    var isActivateConst = "Activate"
    var mainCodePageConst = "MainCodePage"
    var alternateCodePageConst = "AlternateCodePage"
    var isAlternateIsDifferentConst = "AlternateIsDifferent"
    var isAlternateUseYesterdayWallpaperConst = "AlternateUseYesterdayWallpaper"
    var userDefaultDictionary: [String : AnyObject]?
    
    // Prevents others from using the default '()' initializer for this class.
    private init() {
        
        if self.isFirstUse() {
            self.loadDefaultPreference()
        }
        
        userDefaultDictionary = userDefaults.dictionaryForKey(prefKey)
    }
    
    private func isFirstUse() -> Bool {
        return (userDefaults.objectForKey(prefKey) == nil)
    }

    private func loadDefaultPreference() {
        let prefs = NSBundle.mainBundle().pathForResource("defaultPreference", ofType: "plist")
        let dict = NSDictionary(contentsOfFile: prefs!)
        
        userDefaults.setObject(dict, forKey: prefKey)
        userDefaults.synchronize()
        
    }
    
    private func save() {
        userDefaults.setObject(userDefaultDictionary, forKey: prefKey)
        userDefaults.synchronize()
    }
    
    internal func reloadDefaultPreference() {
        if self.isFirstUse() {
            self.loadDefaultPreference()
        }
        else {
            userDefaults.removeObjectForKey(prefKey)
            userDefaults.synchronize()
            
            self.loadDefaultPreference()
        }
    }

    var IsWallpaperSaved: Bool {
        get {
            return (userDefaultDictionary![savedWallpaperConst]?.boolValue)!
        }
        set {
            userDefaultDictionary![savedWallpaperConst] = newValue
            self.save()
        }
    }
    
    var IsActivate: Bool {
        get {
            return (userDefaultDictionary![isActivateConst]?.boolValue)!
        }
        set {
            userDefaultDictionary![isActivateConst] = newValue
            self.save()
        }
    }
    var MainCodePage: String {
        get {
            return (userDefaultDictionary![mainCodePageConst])! as! String
        }
        set {
            userDefaultDictionary![mainCodePageConst] = newValue
            self.save()
        }
    }
    var AlternateCodePage: String {
        get {
            return (userDefaultDictionary![alternateCodePageConst])! as! String
        }
        set {
            userDefaultDictionary![alternateCodePageConst] = newValue
            self.save()
        }
    }
    var IsAlternateIsDifferent: Bool {
        get {
            return (userDefaultDictionary![isAlternateIsDifferentConst]?.boolValue)!
        }
        set {
            userDefaultDictionary![isAlternateIsDifferentConst] = newValue
            self.save()
        }
    }
    var IsAlternateUseYesterdayWallpaper: Bool {
        get {
            return (userDefaultDictionary![isAlternateUseYesterdayWallpaperConst]?.boolValue)!
        }
        set {
            userDefaultDictionary![isAlternateUseYesterdayWallpaperConst] = newValue
            self.save()
        }
    }

}

