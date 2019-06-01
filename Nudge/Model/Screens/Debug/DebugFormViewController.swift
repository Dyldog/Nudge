import Eureka
import UserNotifications

class DebugFormViewController: FormViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorStyle = .none
        
        form +++ Section()
            <<< TextRow("TextRow") { row in
                row.placeholder = "Notification text"
            }
        form +++ Section()
            <<< SwitchRow("DelaySwitchRow") { row in
                row.title = "Delay"
                row.value = false
            }
            <<< CountDownPickerRow("DelayPickerRow") { row in
                row.value = TimeInterval(60).asDateComponents.date!
                row.hidden = Condition.function(["DelaySwitchRow"], { form in
                    let delaySwitch = form.rowBy(tag: "DelaySwitchRow") as! SwitchRow
                    return !delaySwitch.value!
                })
            }
        form +++ Section()
            <<< ButtonRow() { row in
                    row.title = "Send"
                row.hidden = Condition.function(["TextRow"], { form in
                    (form.rowBy(tag: "TextRow") as! TextRow).value.isEmpty
                })
            }.onCellSelection({ _,_ in
                self.sendButtonTapped()
            })
        
    }
    
    func sendButtonTapped() {
        let messageRow = form.rowBy(tag: "TextRow") as! TextRow
        let messageContent = messageRow.value!
        
        var delayDuration: TimeInterval = 1
        let delaySwitch = form.rowBy(tag: "DelaySwitchRow") as! SwitchRow
        
        if delaySwitch.value! {
            let delayPicker = form.rowBy(tag: "DelayPickerRow") as! CountDownPickerRow
            var delayComponents = delayPicker.value!.countdownComponents
            let hourSeconds = (delayComponents.hour ?? 0) * 60 * 60
            let minuteSeconds = (delayComponents.minute ?? 0) * 60
            delayDuration = TimeInterval(hourSeconds + minuteSeconds)
        }
        
        // Content
        let content = UNMutableNotificationContent()
        content.body = messageContent
        content.sound = UNNotificationSound.default
        
        // Trigger
        let date = Date().addingTimeInterval(delayDuration)
        let calendarComponents = NSCalendar.current.dateComponents(
            [.day, .month, .year, .hour, .minute, .second], from: date
        )
        let trigger = UNCalendarNotificationTrigger(dateMatching: calendarComponents, repeats: false)
        
        // Request
        let request = UNNotificationRequest(identifier:UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request){ error in
            if let error = error { print("ERROR ADDING NOTIFICATION: \(error.localizedDescription)") }
        }
    }
}

extension String {
    var isEmpty: Bool { return count == 0 }
}

extension Optional where Wrapped == String {
    var isEmpty: Bool { return self == nil ? true : self!.isEmpty }
}
