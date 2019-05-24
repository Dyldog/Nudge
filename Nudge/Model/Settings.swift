import Disk

extension NSNotification.Name {
    static var SettingsDidUpdate: NSNotification.Name = NSNotification.Name(rawValue: "SETTINGS_DID_UPDATE")
}

class Settings: Codable {
    
    private static var settingsFile = "settings.json"
    static var shared = (try? Disk.retrieve(settingsFile, from: .applicationSupport, as: Settings.self)) ?? Settings()
    
    private enum CodingKeys: String, CodingKey {
        case notificationsEnabled
        case notificationInterval
    }
    
    var notificationsEnabled: Bool
    var notificationInterval: TimeInterval
    
    init() {
        notificationsEnabled = true
        notificationInterval = 60 * 60
    }
    
    func update(notificationsEnabled: Bool, notificationInterval: TimeInterval) {
        self.notificationsEnabled = notificationsEnabled
        self.notificationInterval = notificationInterval
        
        do {
            try Disk.save(self, to: .applicationSupport, as: Settings.settingsFile)
            NotificationCenter.default.post(name: .SettingsDidUpdate, object: self)
        } catch {
            print("ERROR SAVING SETTINGS: \(error.localizedDescription)")
        }
    }
}
