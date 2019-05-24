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
    }
    
    func requestNotificationPermission() {
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        notificationCenter.requestAuthorization(options: options) { (didAllow, error) in
            if !didAllow {
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
        let calendarComponents = NSCalendar.current.dateComponents(
            [.day, .month, .year, .hour, .minute], from: date
        )
        let trigger = UNCalendarNotificationTrigger(dateMatching: calendarComponents, repeats: false)
        
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
    
    func scheduleNewMessageNotifications() {
        removeNotifications()
        
        let interval: TimeInterval = 60
        
        50.times { (i: Int) in
            addRandomMessageNotification(
                minTime: TimeInterval(i) * interval,
                maxTime: TimeInterval(i + 1) * interval
            )
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
