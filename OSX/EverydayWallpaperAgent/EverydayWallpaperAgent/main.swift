//
//  main.swift
//  EverydayWallpaperAgent
//
//  Created by Hugo PEREIRA on 23.11.15.
//  Copyright © 2015 Hugo PEREIRA. All rights reserved.
//

import Foundation

let baseUrl = "http://www.bing.com/"
let relativeUrl = "HPImageArchive.aspx?format=js&mbl=1&idx=0&n=1&mkt=zh-CN"

var endpoint = NSURL(string: baseUrl.stringByAppendingString(relativeUrl))
var data = NSData(contentsOfURL: endpoint!)

do {
    let jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as! NSDictionary

    let imgUrl = jsonDictionary.valueForKeyPath("images.url") as! [String]
    let imgUrlBase = jsonDictionary.valueForKeyPath("images.urlbase") as! [String]
    let startDate = jsonDictionary.valueForKeyPath("images.startdate") as! [String]
    let endDate = jsonDictionary.valueForKeyPath("images.enddate") as! [String]

    let bing = BingWallpaper(url: baseUrl.stringByAppendingString(imgUrl[0]),
            urlBase: baseUrl.stringByAppendingString(imgUrlBase[0]),
            startDate: startDate[0],
            endDate: endDate[0])

    print(bing.Url)
    print(bing.StartDate)
    print(bing.EndDate)

} catch let error {
    print("JSON Serialization failed. Error: \(error)")
}

