//
//  StatusMenuController.swift
//  SampleRateBar
//

import Cocoa
import CoreAudio

class StatusMenuController: NSObject {
    @IBOutlet weak var statusMenu: NSMenu!

    let audioManager = AudioManager()
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

    var menuItems: [NSMenuItem] = []

    override func awakeFromNib() {
        statusItem.menu = statusMenu

        load()
    }

    func load() {
        setTitle(audioManager.getSampleRate())
        setMenuItems()
    }

    func setMenuItems() {
        let rates = audioManager.getAvailableSampleRates()

        for (index, rate) in rates.enumerated() {
            let item = NSMenuItem()
            item.title = formatNumber(NSNumber(value: rate.mMinimum)) + "Hz"
            item.action = #selector(StatusMenuController.changeRate)
            item.keyEquivalent = ""
            item.representedObject = rate
            item.target = self

            statusMenu.insertItem(item, at: index)
            menuItems.append(item)
        }
    }

    func clearMenuItems() {
        for menuItem in menuItems {
            statusMenu.removeItem(menuItem)
        }

        menuItems = []
    }

    func setTitle(_ rate: Float64) {
        statusItem.title = formatNumber(NSNumber(value: rate / 1000)) + "kHz"
    }

    func formatNumber(_ num: NSNumber) -> String {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
        formatter.numberStyle = .decimal

        return formatter.string(from: num) ?? "n/a"
    }

    @objc func changeRate(_ sender: NSMenuItem) {
        let rate = sender.representedObject as! AudioValueRange

        audioManager.setSampleRate(rate: rate)

        setTitle(rate.mMinimum)
    }

    @IBAction func refreshClicked(_ sender: NSMenuItem) {
        clearMenuItems()
        load()
    }

    @IBAction func quitClicked(_ sender: NSMenuItem) {
        NSApplication.shared.terminate(self)
    }
}
