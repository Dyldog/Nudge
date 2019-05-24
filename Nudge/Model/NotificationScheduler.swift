import Foundation
import UserNotifications
class NotificationScheduler: NSObject, MessageStorageDelegate, UNUserNotificationCenterDelegate {
    
    private let storage: MessageStorage
    private let notificationCenter: UNUserNotificationCenter
    
    init(storage: MessageStorage) {
        self.storage = storage
        self.notificationCenter = UNUserNotificationCenter.current()
        
        super.init()
        
        self.storage.delegate = self
        self.notificationCenter.delegate = self
        requestNotificationPermission()
        scheduleNewMessageNotifications()
        
        NotificationCenter.default.addObserver(self, selector: #selector(scheduleNewMessageNotifications), name: .SettingsDidUpdate, object: Settings.shared)
    }
    
    func requestNotificationPermission() {
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        notificationCenter.requestAuthorization(options: options) { (didAllow, error) in
            if didAllow {
                self.scheduleNewMessageNotifications()
            } else {
                print("User has declined notifications")
            }
        }
    }
    
    func scheduleNotification(body: String, date: Date) {
        // Content
        let content = UNMutableNotificationContent()
        content.body = body
        content.sound = UNNotificationSound.default
        
        // Trigger        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: date.timeIntervalSinceNow, repeats: false)
        
        // Request
        let request = UNNotificationRequest(identifier:UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request){ error in
            if let error = error {
                print("ERROR ADDING NOTIFICATION: \(error.localizedDescription)")
            } else {
                print("ADDED NOTIFICATION: \"\(body)\" at \(date)")
            }
        }
    }
    
    func removeNotifications() {
        notificationCenter.removeAllPendingNotificationRequests()
    }
    
    func addRandomMessageNotification(minTime: TimeInterval, maxTime: TimeInterval) {
        guard let randomMessage = storage.messages.randomElement() else { return }
        
        scheduleNotification(
            body: randomMessage.content,
            date: Date().randomlyOffset(betweenMinInterval: minTime, maxInterval: maxTime)
        )
    }
    
    @objc func scheduleNewMessageNotifications() {
        removeNotifications()
        
        if Settings.shared.notificationsEnabled {
            let interval: TimeInterval = Settings.shared.notificationInterval
            
            50.times { (i: Int) in
                addRandomMessageNotification(
                    minTime: TimeInterval(i) * interval,
                    maxTime: TimeInterval(i + 1) * interval
                )
            }
        }
    }
    
    // MARK: - MessageStorageDelegate
    func messagesDidUpdate() {
        scheduleNewMessageNotifications()
    }
    
    // MARK: - UNUserNotificationCenterDelegate
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .badge, .sound])
    }
}

extension Date {
    func randomlyOffset(betweenMinInterval minInterval: TimeInterval, maxInterval: TimeInterval) -> Date {
        return self.addingTimeInterval(TimeInterval.random(in: minInterval ..< maxInterval))
    }
}
