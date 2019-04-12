#if TAKING_SCREENSHOTS
import SimulatorStatusMagic
#endif

class ScreenshotAssistant {

    static func prepare() {
#if TAKING_SCREENSHOTS
        SDStatusBarManager.sharedInstance().enableOverrides()
#endif
    }

}
