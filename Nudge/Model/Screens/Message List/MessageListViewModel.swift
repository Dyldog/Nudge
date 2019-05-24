class MessageListViewModel {
    var storage: MessageStorage
    
    init(storage: MessageStorage) {
        self.storage = storage
    }
    
    var messages: [String] { return storage.messages.map { $0.content } }
    
    func addMessage(_ message: String) -> Int {
        let newIndex = storage.addMessage(Message(id: .init(), content: message))
        return newIndex
    }
    
    func deleteMessage(at index: Int) {
        storage.deleteMessage(storage.messages[index])
    }
}
