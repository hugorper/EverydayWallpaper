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
    
    var actionHide: Selector = ""
    
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
        let myPopup: NSAlert = NSAlert()

        //self.menuActionHide(sender)
        
        myPopup.messageText = "Everyday Wallpaper help"
        myPopup.informativeText = "eee\nfjdskjkjhfdsks fdlj fdlf jdskjf lds sd\n fhdjskfjsahf dhfkj safj hdksja\nfkjjfhcrwuecghjklfdsjklgfhgfg ghfjslkg ghfj"

        myPopup.alertStyle = NSAlertStyle.InformationalAlertStyle
        myPopup.addButtonWithTitle("close")
        myPopup.beginSheetModalForWindow(self.view.window!, completionHandler: nil )
    }
    
    @IBAction func menuActionUninstall(sender: AnyObject) {
    }
    
    @IBAction func menuActionHide(sender: AnyObject) {
        (NSApplication.sharedApplication().delegate as! AppDelegate).closePopover(sender)
    }

    @IBAction func menuActionQuit(sender: AnyObject) {
        NSApplication.sharedApplication().terminate(sender)

    }

}
