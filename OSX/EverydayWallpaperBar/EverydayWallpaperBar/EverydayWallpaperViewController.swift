/*
* Created by Hugo PEREIRA
* Copyright © 2015 Hugo PEREIRA. All rights reserved.
*/


import Cocoa
import EverydayWallpaperUtils

class EverydayWallpaperViewController: NSViewController
{
    @IBOutlet weak var allScreenActivationCheckbox: NSButton!
    @IBOutlet weak var allScreenMarketsCombo: NSPopUpButton!

    @IBOutlet weak var saveLastButton: NSButton!

    @IBOutlet weak var imagePathControl: NSPathControl!

    @IBOutlet weak var popupMenu: NSPopUpButton!
    @IBOutlet weak var spinner: CircularSnail!

    private var isUpdating: Bool = false; private var isVisible: Bool = false;

    override func viewDidLoad()
    {
        self.spinner.hidden = true

        // load markets com strings
        for market in BingWallperMarkets.allValues
        {
            allScreenMarketsCombo.addItemWithTitle(market.rawValue)
        }

        // load apps settings
        allScreenActivationCheckbox.state = AppSettings.sharedInstance.IsActivate ? NSOnState : NSOffState
        saveLastButton.state = AppSettings.sharedInstance.IsWallpaperSaved ? NSOnState : NSOffState
        allScreenMarketsCombo.selectItemWithTitle(AppSettings.sharedInstance.MainCodePage)
        imagePathControl.stringValue = ImageDownloader.sharedLoader.WallpaperSavePath

        self.updateControlsFromState()

        self.view.layer!.contents = NSImage(named: "back")!

    }

    override func viewWillAppear()
    {
        super.viewWillAppear()
    }

    func shouldShowSpinner()
    {
        isUpdating = true
        
        if self.isVisible
        {
            (spinner as IndeterminateAnimation).animate = true
            spinner.hidden = false
            self.updateControlState(false, enableMenu: false)
        }
    }

    func shouldHideSpinner()
    {
        isUpdating = false

        if spinner != nil
        {
            spinner.hidden = true
            (spinner as IndeterminateAnimation).animate = false
            self.updateControlState(true, enableMenu: true)
        }
    }

    override func viewDidAppear()
    {
        isVisible = true
    }

    override func viewDidDisappear()
    {
        isVisible = false
    }
}

// MARK: Actions
extension EverydayWallpaperViewController
{
    @IBAction func menuActionAbout(sender: AnyObject)
    {
        openWeb(true)
    }
    
    @IBAction func menuActionHelp(sender: AnyObject)
    {
       openWeb(false)
    }
    
    private func openWeb(isAbout: Bool)
    {
        var url: String = "http://www.hugorper.com"
        
        if !isAbout
        {
            url = "http://www.hugorper.com"
        }
        
        NSWorkspace.sharedWorkspace().openURL(NSURL(string: url)!)
    }
    
    @IBAction func menuActionUninstall(sender: AnyObject)
    {


    }

    @IBAction func menuActionHide(sender: AnyObject)
    {
        (NSApplication.sharedApplication().delegate as! AppDelegate).closePopover(sender)
    }

    @IBAction func menuActionQuit(sender: AnyObject)
    {
        NSApplication.sharedApplication().terminate(sender)
    }

    @IBAction func choosePathAction(sender: NSPathControl)
    {
        // dont use sender.stringValue because it fail if the folder is deleted
        NSWorkspace.sharedWorkspace().selectFile(ImageDownloader.sharedLoader.WallpaperSavePath, inFileViewerRootedAtPath: "")
    }

    @IBAction func allScreenActivationChange(sender: NSButton)
    {
        AppSettings.sharedInstance.IsActivate = sender.state == NSOnState ? true : false

        self.updateControlsFromState()
    }

    @IBAction func allScreenMarketsChange(sender: NSPopUpButton)
    {
        AppSettings.sharedInstance.MainCodePage = sender.titleOfSelectedItem!
        (NSApplication.sharedApplication().delegate as! AppDelegate).initWallpaperUpdate()
    }

    @IBAction func saveLastChange(sender: NSButton)
    {
        AppSettings.sharedInstance.IsWallpaperSaved = sender.state == NSOnState ? true : false
    }

    func updateControlsFromState()
    {
        let wallpaperActivateState: Bool = AppSettings.sharedInstance.IsActivate

        (NSApplication.sharedApplication().delegate as! AppDelegate).updateImageNameFromState(true)

        self.updateControlState(wallpaperActivateState, enableMenu: true)
    }

    private func updateControlState(enabled: Bool, enableMenu: Bool)
    {
        allScreenMarketsCombo.enabled = enabled
        saveLastButton.enabled = enabled

        self.popupMenu.enabled = enableMenu
    }
}
