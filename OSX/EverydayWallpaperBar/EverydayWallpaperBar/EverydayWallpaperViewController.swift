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
    
    override func viewDidLoad() {
        // load markets com strings
        for market in BingWallperMarkets.allValues {
            allScreenMarketsCombo.addItemWithTitle(market.rawValue)
            alternateScreenMarketsCombo.addItemWithTitle(market.rawValue)
        }
        
        // load apps settings
        allScreenActivationCheckbox.state = AppSettings.sharedInstance.IsActivate ? NSOnState : NSOffState
        saveLastButton.state = AppSettings.sharedInstance.IsWallpaperSaved ? NSOnState : NSOffState
        alternateScreenActivationCheckbox.state = AppSettings.sharedInstance.IsAlternateIsDifferent ? NSOnState : NSOffState
        useYesterdayOnAlternateScreenCheckbox.state = AppSettings.sharedInstance.IsAlternateUseYesterdayWallpaper ? NSOnState : NSOffState
        allScreenMarketsCombo.selectItemWithTitle(AppSettings.sharedInstance.MainCodePage)
        alternateScreenMarketsCombo.selectItemWithTitle(AppSettings.sharedInstance.AlternateCodePage)
        imagePathControl.stringValue = ImageDownloader.sharedLoader.WallpaperSavePath
        
        self.updateControlsFromState()
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
    }
    
}

// MARK: Actions
extension EverydayWallpaperViewController {
    
    @IBAction func menuActionHelp(sender: AnyObject) {
        let myPopup: NSAlert = NSAlert()

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

    @IBAction func choosePathAction(sender: NSPathControl) {
        // dont use sender.stringValue because it fail if the folder is deleted
        NSWorkspace.sharedWorkspace().selectFile(ImageDownloader.sharedLoader.WallpaperSavePath, inFileViewerRootedAtPath: "")
    }
    
    @IBAction func allScreenActivationChange (sender: NSButton) {
        AppSettings.sharedInstance.IsActivate = sender.state == NSOnState ? true : false
        
        self.updateControlsFromState()
    }
    
    @IBAction func alternateScreenActivationChange (sender: NSButton) {
        AppSettings.sharedInstance.IsAlternateIsDifferent = sender.state == NSOnState ? true : false
    }
    
    @IBAction func allScreenMarketsChange (sender: NSPopUpButton) {
        AppSettings.sharedInstance.MainCodePage = sender.titleOfSelectedItem!
    }
    
    @IBAction func alternateScreenMarketsChange (sender: NSPopUpButton) {
        AppSettings.sharedInstance.AlternateCodePage = sender.titleOfSelectedItem!
    }
    
    @IBAction func useYesterdayOnAlternateScreenChange (sender: NSButton) {
        AppSettings.sharedInstance.IsAlternateUseYesterdayWallpaper = sender.state == NSOnState ? true : false
    }
    
    @IBAction func saveLastChange (sender: NSButton) {
        AppSettings.sharedInstance.IsWallpaperSaved  = sender.state == NSOnState ? true : false
    }
    
    func updateControlsFromState() {
        let wallpaperActivateState: Bool = AppSettings.sharedInstance.IsActivate
        
        alternateScreenActivationCheckbox.enabled = wallpaperActivateState
        allScreenMarketsCombo.enabled = wallpaperActivateState
        alternateScreenMarketsCombo.enabled = wallpaperActivateState
        useYesterdayOnAlternateScreenCheckbox.enabled = wallpaperActivateState
        saveLastButton.enabled = wallpaperActivateState
        
        (NSApplication.sharedApplication().delegate as! AppDelegate).updateImageNameFromState(true)
    }
}
