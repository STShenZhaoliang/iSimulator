//
//  PreferencesViewController.swift
//  iSimulator
//
//  Created by 沈兆良 on 2018/3/2.
//  Copyright © 2018年 stszl.cn. All rights reserved.
//

import Cocoa

class PreferencesViewController: NSViewController {

    @IBOutlet weak var tabView: NSTabView!
    @IBOutlet weak var pathTextField: NSTextField!
    
    @IBOutlet weak var aboutName: NSTextField!
    @IBOutlet weak var aboutVersion: NSTextField!
    @IBOutlet weak var aboutCopyright: NSTextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.pathTextField.stringValue = Device.linkURL.path
        let infoDic = Bundle.main.infoDictionary!
        aboutName.stringValue = infoDic["CFBundleDisplayName"] as! String
        let shortVersion = infoDic["CFBundleShortVersionString"] as! String
        let version = infoDic["CFBundleVersion"] as! String
        aboutVersion.stringValue = "Version \(shortVersion) (\(version))"
        aboutCopyright.stringValue = infoDic["NSHumanReadableCopyright"] as! String
    }
    
}

// MARK: - Change iSimulator folder
extension PreferencesViewController {
    @IBAction func changePath(_ sender: Any) {
        let panel = NSOpenPanel()
        panel.canChooseFiles = false
        panel.canChooseDirectories = true
        panel.allowsMultipleSelection = false
        panel.begin { (resp) in
            if resp.rawValue == NSFileHandlingPanelCancelButton{
                return
            }
            if let url = panel.url {
                self.changePathAlert(path: url.path)
            }
        }
    }
    
    @IBAction func openPath(_ sender: Any) {
        NSWorkspace.shared.open(Device.linkURL)
    }
    
    func changePathAlert(path: String) {
        let alert: NSAlert = NSAlert()
        alert.messageText = String(format: "Are you sure you want to change data path?")
        alert.informativeText = "The iSimulator folder will be moved to the new location."
        alert.alertStyle = .critical
        alert.addButton(withTitle: "Done")
        alert.addButton(withTitle: "Cancel")
        NSApp.activate(ignoringOtherApps: true)
        alert.beginSheetModal(for: self.view.window!) { (response) in
            if response == NSApplication.ModalResponse.alertFirstButtonReturn {
                Device.updateDocumentURL(path: path, finish: { (errorStr) in
                    if let error = errorStr {
                        self.changePathErrorAlert(error: error)
                        return
                    }
                    self.pathTextField.stringValue = Device.linkURL.path
                })
            }
        }
    }
    
    func changePathErrorAlert(error: String) {
        let alert: NSAlert = NSAlert()
        alert.messageText = String(format: "Change data path failed!")
        alert.informativeText = error
        alert.alertStyle = .critical
        alert.addButton(withTitle: "Done")
        NSApp.activate(ignoringOtherApps: true)
        alert.beginSheetModal(for: self.view.window!, completionHandler: nil)
    }
}
