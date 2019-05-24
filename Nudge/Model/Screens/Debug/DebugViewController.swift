//
//  ViewController.swift
//  Nudge
//
//  Created by Dylan Elliott on 23/5/19.
//  Copyright © 2019 Dylan Elliott. All rights reserved.
//

import UIKit

import UserNotifications

class DebugViewController: UIViewController, UITextFieldDelegate {    

    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var delaySwitch: UISwitch!
    @IBOutlet weak var delayPicker: UIDatePicker!
    
    private let notificationCenter = UNUserNotificationCenter.current()
    
    private var delayDuration: TimeInterval {
        return delaySwitch.isOn ? delayPicker.countDownDuration : 0
    }
    
    private var messageContent: String? {
        return messageTextField.text
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        delaySwitch.isOn = false
        delayPicker.isEnabled = delaySwitch.isOn
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        notificationCenter.requestAuthorization(options: options) { (didAllow, error) in
            if !didAllow {
                print("User has declined notifications")
            }
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    @IBAction func delaySwitchValueDidChange() {
        delayPicker.isEnabled = delaySwitch.isOn
    }
    
    @IBAction func sendButtonTapped() {
        guard let messageContent = messageContent else { return }
        
        // Content
        let content = UNMutableNotificationContent()
        content.body = messageContent
        content.sound = UNNotificationSound.default
        
        // Trigger
        let date = Date().addingTimeInterval(delayDuration)
        let calendarComponents = NSCalendar.current.dateComponents(
            [.day, .month, .year, .hour, .minute], from: date
        )
        let trigger = UNCalendarNotificationTrigger(dateMatching: calendarComponents, repeats: false)
        
        // Request
        let request = UNNotificationRequest(identifier:UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request){ error in
            if let error = error { print("ERROR ADDING NOTIFICATION: \(error.localizedDescription)") }
        }
    }
}

