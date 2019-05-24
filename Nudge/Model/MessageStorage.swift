import Disk

protocol MessageStorageDelegate {
    func messagesDidUpdate()
}

class MessageStorage {
    private var messagesFileName = "messages.json"
    
    var delegate: MessageStorageDelegate?
    
    init() {
        let storedMessages = try? Disk.retrieve(messagesFileName, from: .applicationSupport, as: [Message].self)
        messages = storedMessages ?? []
    }
    
    var messages: [Message] {
        didSet {
            try? Disk.save(messages, to: .applicationSupport, as: messagesFileName)
        }
    }
    
    func addMessage(_ message: Message) -> Int {
        messages.append(message)
        delegate?.messagesDidUpdate()
        return messages.count - 1
    }
    
    func deleteMessage(_ message: Message) {
        messages.removeAll { $0.id == message.id }
        delegate?.messagesDidUpdate() // BUG: If `message` isn't in our array, we'll still call delegate
    }
}
