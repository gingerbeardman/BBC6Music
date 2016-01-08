//
//  RadioViewController.swift
//  BB6Status
//
//  Created by Frederic Font Corbera on 23/07/15.
//  Copyright (c) 2015 Frederic Font Corbera. All rights reserved.
//

import Cocoa
import AVFoundation

class BBC6MusicViewController: NSViewController {
    
    var playerItem:AVPlayerItem!
    var player:AVPlayer!
    var metadata_parser:BBC6MetadataParser!
    @IBOutlet weak var slider: NSSlider!
    @IBOutlet weak var onOff: NSSegmentedControl!
    @IBOutlet weak var label: NSTextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        _ = NSTimer.scheduledTimerWithTimeInterval(5.0, target: self, selector: Selector("updateLabels"), userInfo: nil, repeats: true)
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        updateLabels()
    }
    
    func setUp(){
        // Metadata parser stuff
        self.metadata_parser = BBC6MetadataParser()
        updateMetadata()
        _ = NSTimer.scheduledTimerWithTimeInterval(5.0, target: self, selector: Selector("updateMetadata"), userInfo: nil, repeats: true)

        // Player stuff
        self.playerItem = AVPlayerItem(URL:NSURL(string: "http://www.listenlive.eu/bbc6music.m3u")!)
        self.player = AVPlayer(playerItem:self.playerItem)
        self.player.play()
    }

    
    // MARK: UI actions
    
    @IBAction func onSwitchChange(sender: AnyObject) {
        if sender.selectedSegment == 1 {
            self.player.play()
            self.slider.enabled = true
        } else {
            self.player.pause()
            self.slider.enabled = false
        }
    }
    
    @IBAction func onSliderChange(sender: AnyObject) {
        self.player.volume = self.slider.floatValue
    }
 
    // MARK: update metadata and labels handlers
    
    func updateMetadata(){
        self.metadata_parser.getHTMLData()
        self.metadata_parser.parseMetadata()
    }
    
    func updateLabels() {
        var label_contents = ""
        for element in self.metadata_parser.recent_metadata.reverse() {
            let artist:NSString = element["artist"]! as! NSString
            let track:NSString = element["track"]! as! NSString
            let now = NSDate()
            let started:NSDate = element["started"]! as! NSDate
            let seconds_ago = now.timeIntervalSinceDate(started)
            let mintues_ago:Int = Int(seconds_ago / 60.0)
            label_contents += "\(artist) - \(track) - \(mintues_ago) minutes ago\n"
        }
        self.label.stringValue = label_contents
    }
}
