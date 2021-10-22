import Cocoa
import FlutterMacOS

extension NSWindow {
    func resetWindowStyle() {
        let nsWindow = NSWindow.init()
        self.isOpaque = nsWindow.isOpaque
        self.hasShadow = nsWindow.hasShadow
        self.backgroundColor = nsWindow.backgroundColor
        
        // background
        self.titleVisibility = nsWindow.titleVisibility
        self.titlebarAppearsTransparent = nsWindow.titlebarAppearsTransparent
        self.isMovableByWindowBackground = nsWindow.isMovableByWindowBackground
        self.standardWindowButton(NSWindow.ButtonType.miniaturizeButton)?.isEnabled = ((nsWindow.standardWindowButton(NSWindow.ButtonType.miniaturizeButton)?.isEnabled) != nil)
        
        // blur
        let contentView = contentViewController!.view
        let subView = contentView.subviews.first!
        let subsubView = subView.subviews.first
        if subsubView != nil {
            subView.removeFromSuperview()
            subsubView!.removeFromSuperview()
            contentView.addSubview(subsubView!)
        }
    }
    
    func setClear(isClear: Bool) {
        self.isOpaque = !isClear
        self.backgroundColor = isClear ? .clear : nil
    }
    
    func setShadow(hasShadow: Bool) {
        self.hasShadow = hasShadow
    }
    
    func setBlur(blur: Bool) {
        if (blur) {
            self.isOpaque = false
            self.backgroundColor = .clear
            
            let contentView = contentViewController!.view
            let superView = contentView.superview!
            let blurView = NSVisualEffectView()
            blurView.frame = superView.bounds
            blurView.autoresizingMask = [.width, .height]
            blurView.blendingMode = NSVisualEffectView.BlendingMode.behindWindow
            blurView.material = NSVisualEffectView.Material.underWindowBackground
            
            let views = contentView.subviews
            contentView.subviews = [blurView]
            blurView.addSubview(views.first!)
            
        } else {
            self.isOpaque = true
            self.backgroundColor = nil
            let contentView = contentViewController!.view
            let subView = contentView.subviews.first!
            let subsubView = subView.subviews.first
            if subsubView != nil {
                subView.removeFromSuperview()
                subsubView!.removeFromSuperview()
                contentView.addSubview(subsubView!)
            }
        }
    }
    
    func setBackground(color: NSColor) {
        self.titleVisibility = NSWindow.TitleVisibility.hidden
        self.titlebarAppearsTransparent = true
        self.isMovableByWindowBackground = true
        self.standardWindowButton(NSWindow.ButtonType.miniaturizeButton)?.isEnabled = false
        
        self.isOpaque = false
        self.backgroundColor = color
    }
    
}
