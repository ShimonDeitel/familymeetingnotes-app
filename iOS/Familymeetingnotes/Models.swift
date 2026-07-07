import Foundation

struct Meeting: Identifiable, Codable, Equatable {
    let id: UUID
    var createdAt: Date
    var notes: String
    var actionItems: String

    init(id: UUID = UUID(), createdAt: Date = Date(), notes: String = "", actionItems: String = "") {
        self.id = id
        self.createdAt = createdAt
        self.notes = notes
        self.actionItems = actionItems
    }
}
