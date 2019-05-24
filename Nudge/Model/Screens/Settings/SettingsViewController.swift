import UIKit
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

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var notificationsEnabledSwitch: UISwitch!
    @IBOutlet weak var notificationIntervalPicker: UIDatePicker!
    @IBOutlet weak var saveButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        notificationsEnabledSwitch.isOn = Settings.shared.notificationsEnabled
        notificationIntervalPicker.countDownDuration = Settings.shared.notificationInterval
        
        notificationIntervalPicker.isEnabled = notificationsEnabledSwitch.isOn
        saveButton.isHidden = true
    }
    
    @IBAction func switchDidChange() {
        notificationIntervalPicker.isEnabled = notificationsEnabledSwitch.isOn
    }
    
    @IBAction func intervalPickerDidChange() {
        saveButton.isHidden = false
    }
    
    @IBAction func saveButtonTapped() {
        Settings.shared.update(
            notificationsEnabled: notificationsEnabledSwitch.isOn,
            
            notificationInterval: notificationIntervalPicker.countDownDuration
        )
        
        saveButton.isHidden = true
    }
}
