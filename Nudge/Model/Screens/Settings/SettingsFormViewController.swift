import Eureka

class SettingsFormViewController: FormViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorStyle = .none
        
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
        let hourSeconds = (dateComponents.hour ?? 0) * 60 * 60
        let minuteSeconds = (dateComponents.minute ?? 0) * 60
        let interval = TimeInterval(hourSeconds + minuteSeconds)
        
        Settings.shared.update(
            notificationsEnabled: enabledSwitch.value!,
            notificationInterval: TimeInterval(interval)
        )
    }
}

extension UIViewController {
    @objc func dismissAnimated() {
        dismiss(animated: true, completion: nil)
    }
}

extension UITabBarController {
    private func showDebugViewController() {
        guard
            let initialViewController = UIStoryboard(name: "DebugForm", bundle: nil).instantiateInitialViewController(),
            let debugNavController = initialViewController as? UINavigationController else { return }
        
        let debugViewController = debugNavController.viewControllers[0]
        debugViewController.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Close", style: .plain, target: debugViewController, action: #selector(dismissAnimated))
        
        present(debugNavController, animated: true, completion: nil)
    }
    
    override open func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        guard let event = event else { return }
        
        if(event.subtype == UIEvent.EventSubtype.motionShake) {
            showDebugViewController()
        }
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

extension Date {
    var countdownComponents: DateComponents {
        return Calendar.autoupdatingCurrent.dateComponents([.hour, .minute], from: self)
    }
}
