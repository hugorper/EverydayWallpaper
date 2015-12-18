/*
* Created by Hugo PEREIRA
* Copyright © 2015 Hugo PEREIRA. All rights reserved.
*/


import Cocoa
import EverydayWallpaperUtils

class EverydayWallpaperViewController: NSViewController {
    
    
    @IBOutlet weak var allScreenActivationCheckbox: NSButton!
    @IBOutlet weak var alternateScreenActivationCheckbox: NSButton!
    @IBOutlet weak var allScreenMarketsCombo: NSPopUpButton!
    @IBOutlet weak var alternateScreenMarketsCombo: NSPopUpButton!
    @IBOutlet weak var useYesterdayOnAlternateScreenCheckbox: NSButton!
    
    @IBOutlet weak var saveLastButton: NSButton!
    
    @IBOutlet weak var imagePathControl: NSPathControl!
    
    @IBOutlet weak var wallpaperImageView: NSImageView!

    @IBOutlet weak var wallpaperPreviousButton: NSButton!
    
    @IBOutlet weak var wallpaperScreenTodayButton: NSButton!
    
    @IBOutlet weak var wallpaperScreenNextButton: NSButton!

    @IBOutlet weak var infoTooltipImage: NSImageView!
    
    @IBOutlet weak var infoImageLabel: NSTextField!
    
    override func viewWillAppear() {
        super.viewWillAppear()
        
        infoTooltipImage.toolTip = "ddddddddd"
        
        for market in BingWallperMarkets.allValues {
            allScreenMarketsCombo.addItemWithTitle(market.rawValue)
            alternateScreenMarketsCombo.addItemWithTitle(market.rawValue)
        }
    }
}

// MARK: Actions

extension EverydayWallpaperViewController {
    
    @IBAction func menuActionHelp(sender: AnyObject) {
    }
    
    @IBAction func menuActionUninstall(sender: AnyObject) {
    }
    
    @IBAction func menuActionHide(sender: AnyObject) {
    }

    @IBAction func menuActionQuit(sender: AnyObject) {
        NSApplication.sharedApplication().terminate(sender)

    }

}
