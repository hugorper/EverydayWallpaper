//
// Created by Hugo PEREIRA on 30.11.15.
// Copyright (c) 2015 Hugo PEREIRA. All rights reserved.
//

import Foundation

/*!
* @discussion Bing wallpaper class container
*/
class BingWallpaper {
    var Url: String = ""
    var UrlBase: String = ""
    var StartDate: NSDate = NSDate()
    var EndDate: NSDate = NSDate()

    /*!
    * @discussion Class constructor
    * @param param description
    * @param param description
    * @param param description
    * @param param description
    */
    init(url: String, urlBase: String, startDate: String, endDate: String) {
        Url = url
        UrlBase = urlBase
        StartDate = dateFromString(startDate)
        EndDate = dateFromString(endDate)
    }

    func dateFromString(dateString: String) -> NSDate {
        let dateFormatter = NSDateFormatter()

        dateFormatter.dateFormat = "yyyyMMdd"

        let date = dateFormatter.dateFromString(dateString)

        return date!
    }
}