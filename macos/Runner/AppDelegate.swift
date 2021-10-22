import Cocoa
import FlutterMacOS

@NSApplicationMain
class AppDelegate: FlutterAppDelegate {
    override func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
    
    override func applicationDidFinishLaunching(_ aNotification: Notification) {
        let controller : FlutterViewController = mainFlutterWindow?.contentViewController as! FlutterViewController
        let channel = FlutterMethodChannel.init(name: "samples.flutter.dev/windowController", binaryMessenger: controller.engine.binaryMessenger)
        channel.setMethodCallHandler({
            (_ call: FlutterMethodCall, _ result: FlutterResult) -> Void in
            let args = call.arguments as! Dictionary<String, Any>
            switch (call.method) {
            case "transparent":
                let isClear = args["isClear"] as! Bool
                self.mainFlutterWindow?.setClear(isClear: isClear)
                break;

            case "hasShadow":
                let hasShadow = args["hasShadow"] as! Bool
                self.mainFlutterWindow?.setShadow(hasShadow: hasShadow)
                break;

            case "blur":
                let blur = args["blur"] as! Bool
                self.mainFlutterWindow?.setBlur(blur: blur)
                break;

            case "background":
                let red = args["red"] as! CGFloat
                let blue = args["blue"] as! CGFloat
                let green = args["green"] as! CGFloat
                let alpha = args["alpha"] as! CGFloat
                let color = NSColor.init(red: red, green: green, blue: blue, alpha: alpha)
                self.mainFlutterWindow?.setBackground(color: color)
                break;

            case "reset":
                self.mainFlutterWindow?.resetWindowStyle()
                break;
                
            default:
                break;
            }
        });
    }
}
