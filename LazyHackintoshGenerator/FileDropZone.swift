//
//  FileDropZone.swift
//  LazyHackintoshGenerator
//
//  Created by ئ‍ارسلان ئابلىكىم on 2/5/16.
//  Copyright © 2016 PCBETA. All rights reserved.
//

import Cocoa

class FileDropZone: NSImageView {
    
    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)
    }
    
    let fileTypes = ["dmg","app"]
    var fileTypeIsOk = false
    var droppedFilePath = ""
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        registerForDraggedTypes([NSFilenamesPboardType, NSURLPboardType, NSPasteboardTypeTIFF])
    }
    
    override func draggingEntered(sender: NSDraggingInfo) -> NSDragOperation {
        if checkExtension(sender) == true {
            self.fileTypeIsOk = true
            return .Copy
        } else {
            self.fileTypeIsOk = false
            return .None
        }
    }
    
    override func draggingUpdated(sender: NSDraggingInfo) -> NSDragOperation {
        if self.fileTypeIsOk {
            return .Copy
        } else {
            return .None
        }
    }
    
    override func performDragOperation(sender: NSDraggingInfo) -> Bool {
        if let board = sender.draggingPasteboard().propertyListForType("NSFilenamesPboardType") as? NSArray {
            if let imagePath = board[0] as? String {
                // THIS IS WERE YOU GET THE PATH FOR THE DROPPED FILE
                self.droppedFilePath = imagePath
                return true
            }
        }
        return false
    }
    override func draggingEnded(sender: NSDraggingInfo?) {
        let view = self.superview!.nextResponder! as! ViewController
        view.filePath.stringValue = self.droppedFilePath
        view.startGenerating()
    }
    
    func checkExtension(drag: NSDraggingInfo) -> Bool {
        if let board = drag.draggingPasteboard().propertyListForType("NSFilenamesPboardType") as? NSArray,
            let path = board[0] as? String {
                let url = NSURL(fileURLWithPath: path)
                if let suffix = url.pathExtension {
                    for ext in self.fileTypes {
                        if ext.lowercaseString == suffix {
                            return true
                        }
                    }
                }
        }
        return false
    }
    
}
class OtherFileDrop : FileDropZone{
    var path: String = ""
    override func draggingUpdated(sender: NSDraggingInfo) -> NSDragOperation {
            return .Copy
    }
    override func draggingEnded(sender: NSDraggingInfo?) {
        let layer = CALayer()
        layer.backgroundColor = CGColorCreateGenericRGB(0.0, 0.0, 0.0, 0.4)
        self.wantsLayer = true
        self.layer = layer
    }
}