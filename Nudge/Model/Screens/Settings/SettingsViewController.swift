import UIKit

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
