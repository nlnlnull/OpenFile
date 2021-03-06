//
//  HmPopoverItem.swift
//  OpenFile
//
//  Created by 侯猛 on 2019/12/23.
//  Copyright © 2019 侯猛. All rights reserved.
//

import Cocoa

class HmMainCollectionItem: NSCollectionViewItem {

    @IBOutlet weak var fileName: HmLabel!
    
    @IBOutlet weak var fileIcon: NSImageView!
    
    private let workspace = NSWorkspace.shared
    
    private var rightMenu: NSMenu!
    
    var clickButtonHandler: (() -> Void)?
    
    var removeItemHandler: (() -> Void)?
    
    var editItemHandler: (() -> Void)?
    
    private var itemModel: HmMainFileModel!
    
    var indexPathIndex: Int!
    
    let regex = try! Regex(#"^.*?\.(gif|png|jpg|jpeg|webp|svg|psd|bmp|tif|pdf)$"#)
    
    // 已经点击下去 未抬起来
    private var isClicking: Bool = false
    // 已经和鼠标重合
    private var isAlreadyCoincide: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fileName.textColor = .labelColor
        
        rightMenu = NSMenu()
        let menuEditItem = NSMenuItem(title: "详情", action: #selector(editItem), keyEquivalent: "")
        let menuopenFolder = NSMenuItem(title: "在 Finder 中打开", action: #selector(openFolder), keyEquivalent: "")
        let menuCopyPath = NSMenuItem(title: "复制路径", action: #selector(copyItemPath), keyEquivalent: "")
        let menuRemoveItem = NSMenuItem(title: "删除", action: #selector(removeItem), keyEquivalent: "")
        rightMenu.addItem(menuEditItem)
        rightMenu.addItem(menuopenFolder)
        rightMenu.addItem(menuCopyPath)
        rightMenu.addItem(menuRemoveItem)
        
        view.menu = rightMenu
    }
    
    @objc
    func editItem() {
        editItemHandler?()
        let wc: HmFileItemDetailWindowController = ContentStoryboard(Identifier: HmFileItemDetailWindowController.self)
        wc.setItemDataDetail(model: self.itemModel, index: indexPathIndex)
        wc.window?.center()
        wc.showWindow(self)
    }
    
    @objc
    func openFolder() {
        NSWorkspace.shared.selectFile(itemModel.path, inFileViewerRootedAtPath: "")
    }
    
    @objc
    func copyItemPath() {
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.writeObjects([itemModel.path as NSString])
    }
    
    @objc
    func removeItem() {
        removeItemHandler?()
    }
    
    func setFilePath(model: HmMainFileModel) {
        self.itemModel = model
        fileName.stringValue = model.showName
        fileIcon.alphaValue = 1
        
        if regex.matches(model.path) {
            fileIcon.image = NSImage(contentsOfFile: model.path)
        }else{
            fileIcon.image = NSWorkspace.shared.icon(forFile: model.path)
        }
        
    }
    
    override func mouseDown(with event: NSEvent) {
        super.mouseDown(with: event)
        self.fileIcon.alphaValue = 0.8
    }
    
    override func mouseUp(with event: NSEvent) {
        super.mouseUp(with: event)
        self.fileIcon.alphaValue = 1
        self.clickButtonHandler?()
    }
}
