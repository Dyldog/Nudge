import UIKit

class MessageListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let storage: MessageStorage
    let scheduler: NotificationScheduler
    let viewModel: MessageListViewModel

    required init?(coder aDecoder: NSCoder) {
        storage = MessageStorage()
        scheduler = NotificationScheduler(storage: storage)
        viewModel = MessageListViewModel(storage: storage)
        
        super.init(coder: aDecoder)
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func addButtonTapped() {
        let alert = UIAlertController(title: "Add Message", message: nil, preferredStyle: .alert)
        alert.addTextField(placeholder: "Message text")
        alert.addCancelAction()
        alert.addOKAction { action in
            if let textField = alert.textFields?[0], let messageText = textField.text {
                let newIndex = self.viewModel.addMessage(messageText)
                self.tableView.insertRows(at: [IndexPath(row: newIndex, section: 0)], with: .automatic)
            }
        }
        present(alert, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") ?? UITableViewCell(style: .default, reuseIdentifier: "Cell")
        cell.selectionStyle = .none
        
        let message = viewModel.messages[indexPath.row]
        cell.textLabel?.text = message
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel.deleteMessage(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}
