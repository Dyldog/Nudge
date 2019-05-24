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
            cell.detailTextLabel?.text = "\(trigger.timeInterval) \(trigger.nextTriggerDate()!.description)"
        } else {
            cell.detailTextLabel?.text = nil
        }
        
        return cell
    }
    
}
