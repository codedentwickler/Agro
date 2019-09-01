import UIKit

class TimerApplication: UIApplication {
    
    // the timeout in seconds, after which should perform custom actions
    // such as disconnecting the user
    private var timeoutInSeconds: TimeInterval {
        // 2 minutes
        return 5 * 60
    }
    
    private var idleTimer: Timer?
    private var isTimerPaused: Bool = false
    
    override init() {
        super.init()
        
        NotificationCenter.default.addObserver(self, selector: #selector(pauseTimer), name: .pauseAppTimer, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(resetIdleTimer), name: .resetAppTimer, object: nil)
    }
    
    // reset the timer because there was user interaction
    @objc private func resetIdleTimer() {
        idleTimer?.invalidate()
        AgroLogger.log("resetIdleTimer was called ")
        idleTimer = Timer.scheduledTimer (
            timeInterval: timeoutInSeconds,
            target: self,
            selector: #selector(TimerApplication.timeHasExceeded),
            userInfo: nil,
            repeats: false
        )
        
        isTimerPaused = false
    }
    
    @objc private func pauseTimer() {
        AgroLogger.log("pauseTimer was called ")
        isTimerPaused = true
        idleTimer?.invalidate()
    }
    
    // if the timer reaches the limit as defined in timeoutInSeconds, post this notification
    @objc private func timeHasExceeded() {
        AgroLogger.log("timeHasExceeded was called ")

        NotificationCenter.default.post(name: .appTimeout, object: nil)
    }
    
    override func sendEvent(_ event: UIEvent) {
        super.sendEvent(event)
        
        //If there is no user in session, return
        if !LoginSession.shared.isUserInSession || isTimerPaused {
            return
        }
        
        if idleTimer != nil {
            self.resetIdleTimer()
        }
        
        if let touches = event.allTouches {
            for touch in touches where touch.phase == UITouch.Phase.began {
                self.resetIdleTimer()
            }
        }
    }
}
