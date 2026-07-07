import XCTest
@testable import Familymeetingnotes

final class FamilymeetingnotesTests: XCTestCase {
    var store: Store!

    @MainActor override func setUp() {
        super.setUp()
        store = Store()
        store.items = []
        store.save()
    }

    @MainActor func testSeedDataBelowFreeLimit() {
        let seed = Store.seedData()
        XCTAssertLessThan(seed.count, Store.freeLimit)
    }

    @MainActor func testAddItem() {
        let item = Meeting()
        let added = store.add(item, isPro: false)
        XCTAssertTrue(added)
        XCTAssertEqual(store.items.count, 1)
    }

    @MainActor func testFreeLimitBlocksAdd() {
        for _ in 0..<Store.freeLimit {
            _ = store.add(Meeting(), isPro: false)
        }
        let blocked = store.add(Meeting(), isPro: false)
        XCTAssertFalse(blocked)
        XCTAssertEqual(store.items.count, Store.freeLimit)
    }

    @MainActor func testProBypassesLimit() {
        for _ in 0..<Store.freeLimit {
            _ = store.add(Meeting(), isPro: true)
        }
        let added = store.add(Meeting(), isPro: true)
        XCTAssertTrue(added)
    }

    @MainActor func testDeleteItem() {
        let item = Meeting()
        _ = store.add(item, isPro: false)
        store.delete(id: item.id)
        XCTAssertTrue(store.items.isEmpty)
    }

    @MainActor func testUpdateItem() {
        var item = Meeting()
        _ = store.add(item, isPro: false)
        item = store.items[0]
        store.update(item)
        XCTAssertEqual(store.items.count, 1)
    }

    @MainActor func testCanAddRespectsLimit() {
        XCTAssertTrue(store.canAdd(isPro: false))
    }

    @MainActor func testPersistenceRoundTrip() {
        let item = Meeting()
        _ = store.add(item, isPro: false)
        store.save()
        store.load()
        XCTAssertEqual(store.items.first?.id, item.id)
    }
}
