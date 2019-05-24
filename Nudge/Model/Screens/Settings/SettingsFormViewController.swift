import Eureka

class SettingsFormViewController: FormViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        form +++ Section("Notifications")
            <<< SwitchRow("SwitchRow") { row in      // initializer
                row.title = "Enabled"
                row.value = Settings.shared.notificationsEnabled
            }.onChange { row in
                self.updateSettings()
            }
            <<< CountDownInlineRow("CountdownRow") { row in
                row.title = "Interval"
                row.value = Settings.shared.notificationInterval.asDateComponents.date
                row.hidden = Condition.function(["SwitchRow"], { form in
                    return !(form.rowBy(tag: "SwitchRow") as! SwitchRow).value!
                })
            }.onChange { row in
                let saveButton = self.form.rowBy(tag: "SaveButton") as! ButtonRow
                saveButton.hidden = Condition(booleanLiteral: false)
                saveButton.evaluateHidden()
            }
            <<< ButtonRow("SaveButton") { row in
                row.title = "Save Interval"
                row.hidden = Condition(booleanLiteral: true)
            }.onCellSelection({ cell, row in
                row.hidden = Condition(booleanLiteral: true)
                row.evaluateHidden()
                self.updateSettings()
            })
    }
    
    func updateSettings() {
        let enabledSwitch = form.rowBy(tag: "SwitchRow") as! SwitchRow
        let datePicker = form.rowBy(tag: "CountdownRow") as! CountDownInlineRow
        
        let dateComponents = Calendar.autoupdatingCurrent
            .dateComponents([.hour, .minute], from: datePicker.value!)
        let interval = dateComponents.hour! * 60 * 60 + dateComponents.minute! * 60
        
        Settings.shared.update(
            notificationsEnabled: enabledSwitch.value!,
            notificationInterval: TimeInterval(interval)
        )
    }
}

extension TimeInterval {
    var asDateComponents: DateComponents {
        let seconds: Int = Int(self) % 60
        let minutes: Int = ((Int(self) - seconds) % (60 * 60)) / 60
        let hours: Int = (Int(self) - minutes * 60 - seconds) / (60  * 60)
        
        return DateComponents(calendar: .current, timeZone: .autoupdatingCurrent,
                                        hour: hours,
                                        minute: minutes,
                                        second: seconds)
    }
}
