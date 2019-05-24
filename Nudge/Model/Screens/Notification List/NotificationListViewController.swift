import UIKit
import UserNotifications

class NotificationListViewController: UITableViewController {
    let notificationCentre = UNUserNotificationCenter.current()
    
    var requests: [UNNotificationRequest] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reload()
    }
    
    private func reload() {
        notificationCentre.getPendingNotificationRequests { requests in
            DispatchQueue.main.async {
                self.requests = requests.sorted(by: { lhs, rhs in
                    guard let lhsTrigger = lhs.trigger as? UNTimeIntervalNotificationTrigger,
                          let rhsTrigger = rhs.trigger as? UNTimeIntervalNotificationTrigger
                    else { return false}
                    
                    return lhsTrigger.timeInterval < rhsTrigger.timeInterval
                })
                
                self.tableView.reloadData()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return requests.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") ?? UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
        cell.selectionStyle = .none
        
        let request = requests[indexPath.row]
        
        cell.textLabel?.text = request.content.body
        
        if let trigger = request.trigger as? UNTimeIntervalNotificationTrigger {
            // BUG: nextTriggerDate seems to be calculated incorrectly. The notification fires are the
            //      correct time, but the retrieved value is incorrect.
            cell.detailTextLabel?.text = "\(trigger.timeInterval.humanReadable) \(trigger.nextTriggerDate()!.description)"
        } else {
            cell.detailTextLabel?.text = nil
        }
        
        return cell
    }
    
}

extension TimeInterval {
    var humanReadable: String {
        let seconds: Int = Int(self) % 60
        let minutes: Int = ((Int(self) - seconds) % (60 * 60)) / 60
        let hours: Int = (Int(self) - minutes * 60 - seconds) / (60  * 60)
        
        return [
            (hours, "hour"),
            (minutes, "minute"),
            (seconds, "second")
        ].filter { $0.0 > 0 }
         .map { "\($0) \($1)\($0 == 1 ? "" : "s")" }
         .joined(separator: ", ")
    }
}
