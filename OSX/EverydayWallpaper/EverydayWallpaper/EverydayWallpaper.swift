//
//  EverydayWallpaper.swift
//  EverydayWallpaper
//
//  Created by Hugo PEREIRA on 16.11.15.
//  Copyright © 2015 Hugo PEREIRA. All rights reserved.
//

import Foundation
import PreferencePanes

class EverydayWallpaper: NSPreferencePane {
    
    @IBOutlet weak var view: NSView!
    
    override func mainViewDidLoad() {
        
    }
    
    @IBAction func testAction(sender: AnyObject) {
       // let defaults = NSUserDefaults.standardUserDefaults()
       // defaults.setObject("Coding Explorer", forKey: "userNameKey")
        
        let alert = NSAlert()
        alert.messageText = "Do you want to save the changes you made in the document?"
        alert.informativeText = "Your changes will be lost if you don't save them."
        alert.addButtonWithTitle("Save")
        alert.addButtonWithTitle("Cancel")
        alert.addButtonWithTitle("Don't Save")
        
        
        alert.runModal()
    }

}