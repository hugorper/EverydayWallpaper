//
//  Wallpaper.swift
//  EverydayWallpaperUtils
//
//  Created by Hugo PEREIRA on 05.12.15.
//  Copyright © 2015 Hugo PEREIRA. All rights reserved.
//

import Foundation

/*!
* @discussion enum BingWallperResolutions
* @comment Warming the separator must be the same has Constants.Naming.ResolutionSeparator
*/

public enum BingWallperResolutions: String
{
    case Res176x220 = "176x220", Res220x176 = "220x176", Res240x240 = "240x240", Res240x320 = "240x320", Res240x400 = "240x400", Res320x240 = "320x240", Res320x320 = "320x320", Res360x480 = "360x480", Res400x240 = "400x240", Res480x360 = "480x360", Res480x640 = "480x640", Res480x800 = "480x800", Res640x480 = "640x480", Res768x1024 = "768x1024", Res800x480 = "800x480", Res800x600 = "800x600", Res1024x768 = "1024x768", Res1280x720 = "1280x720", Res1280x768 = "1280x768", Res1366x768 = "1366x768", Res1920x1080 = "1920x1080", Res1920x1200 = "1920x1200"

    public static let allValues = [Res176x220, Res220x176, Res240x240, Res240x320, Res240x400, Res320x240, Res320x320, Res360x480, Res400x240, Res480x360, Res480x640, Res480x800, Res640x480, Res768x1024, Res800x480, Res800x600, Res1024x768, Res1280x720, Res1280x768, Res1366x768, Res1920x1080, Res1920x1200]
}

public enum BingWallperMarkets: String
{
    case EnglishUnitedStates = "en-US", ChineseChina = "zh-CN", JapaneseJapan = "ja-JP", EnglishAustralia = "en-AU", EnglishUnitedKingdom = "en-UK", GermanGermany = "de-DE", EnglishNewZealand = "en-NZ", EnglishCanada = "en-CA"

    public static let allValues = [EnglishUnitedStates, ChineseChina, JapaneseJapan, EnglishAustralia, EnglishUnitedKingdom, GermanGermany, EnglishNewZealand, EnglishCanada]
}


public class BingWallpaperReference
{
    public var Url: String = ""
    public var UrlWithoutResolution: String = ""
    public var StartDate: NSDate = NSDate()
    public var EndDate: NSDate = NSDate()
    public var FullStartDate: NSDate = NSDate()
    public var FullStartTime: String = ""

    /*!
    * @discussion Class constructor
    * @param param description
    * @param param description
    * @param param description
    * @param param description
    */
    init(url: String, urlBase: String, startDate: String, endDate: String, fullStartDate: String)
    {
        Url = url
        UrlWithoutResolution = urlBase
        StartDate = dateFromString(startDate)
        EndDate = dateFromString(endDate)
        FullStartDate = dateFromString(fullStartDate, withTime: true)
        FullStartTime = dateFromString(fullStartDate, withTime: true).toShortTimeString()
    }

    public func dateFromString(dateString: String) -> NSDate
    {
        return dateFromString(dateString, withTime: false)
    }

    public func dateFromString(dateString: String, withTime: Bool) -> NSDate
    {
        let dateFormatter = NSDateFormatter()

        if withTime
        {
            dateFormatter.dateFormat = "yyyyMMddHHmm"
        }
        else
        {
            dateFormatter.dateFormat = "yyyyMMdd"
        }


        let date = dateFormatter.dateFromString(dateString)

        return date!
    }

    public func urlStringByAppendingResolution(resolution: BingWallperResolutions) -> String
    {
        return UrlWithoutResolution.stringByAppendingString("_").stringByAppendingString(resolution.rawValue).stringByAppendingString(".jpg")
    }

    public func urlStringByAppendingResolution(resolution: CGSize) -> String
    {

        return UrlWithoutResolution.stringByAppendingString("_").stringByAppendingString(self.resolutionFromSize(resolution).rawValue).stringByAppendingString(".jpg")
    }

    public func resolutionFromSize(size: CGSize) -> BingWallperResolutions
    {
        var found = false
        var mappedResolution: BingWallperResolutions = BingWallperResolutions.Res240x320

        for resolution in BingWallperResolutions.allValues
        {
            let width = Int(size.width)
            let height = Int(size.height)

            if resolution.rawValue == "\(width)\(Constants.Naming.ResolutionSeparator)\(height)"
            {
                found = true
                mappedResolution = resolution
                break
            }
        }

        if (!found)
        {
            for resolution in BingWallperResolutions.allValues.reverse()
            {
                let width = Int(size.width)
                let height = Int(size.height)

                let resString = resolution.rawValue
                let resArray = resString.characters.split
                {
                    $0 == Character(Constants.Naming.ResolutionSeparator)
                }.map(String.init)

                if (Int(resArray[0])! / Int(resArray[1])!) == (width / height)
                {
                    found = true
                    mappedResolution = resolution
                    break
                }
            }

        }

        return mappedResolution
    }
}

public class BingWallpaperService
{

    public static func GetTodayBingWallpaperReference(market: String) throws -> BingWallpaperReference?
    {
        return try GetBingWallpaperReference(0, market: market); }

    public static func GetYesterdayBingWallpaperReference(market: String) throws -> BingWallpaperReference?
    {
        return try GetBingWallpaperReference(1, market: market); }

    // The idx parameter is the start day index. 0 for current day, 1 for yesterday, etc..
    public static func GetBingWallpaperReference(idx: Int, market: String) throws -> BingWallpaperReference?
    {
        if NetworkStatus.isConnectedToNetwork() == false
        {
            throw DownloadStatus.NetworkNotReachable
        }

        let baseUrl = "http://www.bing.com/"
        let relativeUrl = "HPImageArchive.aspx?format=js&mbl=1&idx=\(idx)&n=1&mkt=\(market)"
        let endpoint = NSURL(string: baseUrl.stringByAppendingString(relativeUrl))
        let data = NSData(contentsOfURL: endpoint!)

        if data == nil
        {
            throw DownloadStatus.UndefinedError
        }

        do
        {
            let jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as! NSDictionary

            let imgUrl = jsonDictionary.valueForKeyPath("images.url") as! [String]
            let imgUrlBase = jsonDictionary.valueForKeyPath("images.urlbase") as! [String]
            let startDate = jsonDictionary.valueForKeyPath("images.startdate") as! [String]
            let endDate = jsonDictionary.valueForKeyPath("images.enddate") as! [String]
            let fullStartDate = jsonDictionary.valueForKeyPath("images.fullstartdate") as! [String]

            let bing = BingWallpaperReference(url: baseUrl.stringByAppendingString(imgUrl[0]), urlBase: baseUrl.stringByAppendingString(imgUrlBase[0]), startDate: startDate[0], endDate: endDate[0], fullStartDate: fullStartDate[0])

            print(bing.Url)
            print(bing.UrlWithoutResolution)
            print(bing.StartDate)
            print(bing.EndDate)
            print(bing.FullStartDate)

            return bing;

        }
        catch let error
        {
            print("JSON Serialization failed. Error: \(error)")
            throw DownloadStatus.UndefinedError
        }
    }
}


