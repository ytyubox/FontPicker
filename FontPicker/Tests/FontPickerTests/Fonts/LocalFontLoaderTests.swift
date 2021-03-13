//
/* 
 *		Created by 游宗諭 in 2021/3/13
 *		
 *		Using Swift 5.0
 *		
 *		Running on macOS 11.2
 */


import XCTest
import LoadingSystem
import TestUtils
import FontPicker

public struct LocalFont:Equatable {
    
}

public final class LocalFontLoader<AStore: Store>: LocalLoader<[Font], AStore> where AStore.Local == LocalFont {
    public convenience init(store: AStore, currentDate: @escaping () -> Date) {
        self.init(store: store, currentDate: currentDate) {
            cache in
            cache.item.toModels()
        }
    }
}

extension LocalFont: LocalModel {
    public var model: Font {
        Font(name: "", variants: [], subsets: [], category: "")
    }
}


final class LoadFontFromCacheTests: XCTestCase {
  
    func test_init_doesNotMessageStoreUponCreation() {
        let (_, store) = makeSUT()

        XCTAssertEqual(store.receivedMessages, [])
    }

    func test_load_requestsCacheRetrieval() {
        let (sut, store) = makeSUT()

        sut.load { _ in }

        XCTAssertEqual(store.receivedMessages, [.retrieve])
    }

    func test_load_failsOnRetrievalError() {
        let (sut, store) = makeSUT()
        let retrievalError = anyNSError()

        expect(sut, toCompleteWith: .failure(retrievalError), when: {
            store.completeRetrieval(with: retrievalError)
        })
    }

    func test_load_deliversNoImagesOnEmptyCache() {
        let (sut, store) = makeSUT()

        expect(sut, toCompleteWith: .success([]), when: {
            store.completeRetrievalWithEmptyCache()
        })
    }

    func test_load_deliversCachedImagesOnNonExpiredCache() {
        let font = uniqueFont()
        let fixedCurrentDate = Date()
        let nonExpiredTimestamp = fixedCurrentDate.minusCacheMaxAge().adding(seconds: 1)
        let (sut, store) = makeSUT(currentDate: { fixedCurrentDate })

        expect(sut, toCompleteWith: .success(font.models), when: {
            store.completeRetrieval(with: font.local, timestamp: nonExpiredTimestamp)
        })
    }

    func test_load_deliversNoImagesOnCacheExpiration() {
        let font = uniqueFont()
        let fixedCurrentDate = Date()
        let expirationTimestamp = fixedCurrentDate.minusCacheMaxAge()
        let (sut, store) = makeSUT(currentDate: { fixedCurrentDate })

        expect(sut, toCompleteWith: .success([]), when: {
            store.completeRetrieval(with: font.local, timestamp: expirationTimestamp)
        })
    }

    func test_load_deliversNoImagesOnExpiredCache() {
        let font = uniqueFont()
        let fixedCurrentDate = Date()
        let expiredTimestamp = fixedCurrentDate.minusCacheMaxAge().adding(seconds: -1)
        let (sut, store) = makeSUT(currentDate: { fixedCurrentDate })

        expect(sut, toCompleteWith: .success([]), when: {
            store.completeRetrieval(with: font.local, timestamp: expiredTimestamp)
        })
    }

    func test_load_hasNoSideEffectsOnRetrievalError() {
        let (sut, store) = makeSUT()

        sut.load { _ in }
        store.completeRetrieval(with: anyNSError())

        XCTAssertEqual(store.receivedMessages, [.retrieve])
    }

    func test_load_hasNoSideEffectsOnEmptyCache() {
        let (sut, store) = makeSUT()

        sut.load { _ in }
        store.completeRetrievalWithEmptyCache()

        XCTAssertEqual(store.receivedMessages, [.retrieve])
    }

    func test_load_hasNoSideEffectsOnNonExpiredCache() {
        let font = uniqueFont()
        let fixedCurrentDate = Date()
        let nonExpiredTimestamp = fixedCurrentDate.minusCacheMaxAge().adding(seconds: 1)
        let (sut, store) = makeSUT(currentDate: { fixedCurrentDate })

        sut.load { _ in }
        store.completeRetrieval(with: font.local, timestamp: nonExpiredTimestamp)

        XCTAssertEqual(store.receivedMessages, [.retrieve])
    }

    func test_load_hasNoSideEffectsOnCacheExpiration() {
        let font = uniqueFont()
        let fixedCurrentDate = Date()
        let expirationTimestamp = fixedCurrentDate.minusCacheMaxAge()
        let (sut, store) = makeSUT(currentDate: { fixedCurrentDate })

        sut.load { _ in }
        store.completeRetrieval(with: font.local, timestamp: expirationTimestamp)

        XCTAssertEqual(store.receivedMessages, [.retrieve])
    }

    func test_load_hasNoSideEffectsOnExpiredCache() {
        let font
            = uniqueFont()
        let fixedCurrentDate = Date()
        let expiredTimestamp = fixedCurrentDate.minusCacheMaxAge().adding(seconds: -1)
        let (sut, store) = makeSUT(currentDate: { fixedCurrentDate })

        sut.load { _ in }
        store.completeRetrieval(with: font.local, timestamp: expiredTimestamp)

        XCTAssertEqual(store.receivedMessages, [.retrieve])
    }

    func test_load_doesNotDeliverResultAfterSUTInstanceHasBeenDeallocated() {
        let store = StoreSpy()
        var sut: SUT? = LocalFontLoader(store: store, currentDate: Date.init)

        var receivedResults = [SUT.Outcome]()
        sut?.load { receivedResults.append($0) }

        sut = nil
        store.completeRetrievalWithEmptyCache()

        XCTAssertTrue(receivedResults.isEmpty)
    }

    // MARK: - Helpers

    private typealias SUT = LocalFontLoader<StoreSpy>
    private func makeSUT(currentDate: @escaping () -> Date = Date.init, file: StaticString = #filePath, line: UInt = #line) -> (sut: SUT, store: StoreSpy) {
        let store = StoreSpy()
        let sut = LocalFontLoader(store: store, currentDate: currentDate)
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, store)
    }

    private func expect(_ sut: SUT, toCompleteWith expectedResult: SUT.Outcome, when action: () -> Void, file: StaticString = #filePath, line: UInt = #line) {
        let exp = expectation(description: "Wait for load completion")

        sut.load { receivedResult in
            switch (receivedResult, expectedResult) {
            case let (.success(receivedImages), .success(expectedImages)):
                XCTAssertEqual(receivedImages, expectedImages, file: file, line: line)

            case let (.failure(receivedError as NSError), .failure(expectedError as NSError)):
                XCTAssertEqual(receivedError, expectedError, file: file, line: line)

            default:
                XCTFail("Expected result \(expectedResult), got \(receivedResult) instead", file: file, line: line)
            }

            exp.fulfill()
        }

        action()
        wait(for: [exp], timeout: 1.0)
    }
    
    func uniqueFont() -> (models: [Font], local: [LocalFont]) {
       
        return ([], [])
    }

    class StoreSpy: Store {
        
        typealias Local = LocalFont
        enum ReceivedMessage: Equatable {
            case deleteCached
            case insert([Local], Date)
            case retrieve
        }

        private(set) var receivedMessages = [ReceivedMessage]()

        private var deletionCompletions = [DeletionCompletion]()
        private var insertionCompletions = [InsertionCompletion]()
        private var retrievalCompletions = [RetrievalCompletion]()

        func deleteCached(completion: @escaping DeletionCompletion) {
            deletionCompletions.append(completion)
            receivedMessages.append(.deleteCached)
        }

        func completeDeletion(with error: Error, at index: Int = 0) {
            deletionCompletions[index](.failure(error))
        }

        func completeDeletionSuccessfully(at index: Int = 0) {
            deletionCompletions[index](.success(()))
        }

        func insert(_ font: [Local], timestamp: Date, completion: @escaping InsertionCompletion) {
            insertionCompletions.append(completion)
            receivedMessages.append(.insert(font, timestamp))
        }

        func completeInsertion(with error: Error, at index: Int = 0) {
            insertionCompletions[index](.failure(error))
        }

        func completeInsertionSuccessfully(at index: Int = 0) {
            insertionCompletions[index](.success(()))
        }

        func retrieve(completion: @escaping RetrievalCompletion) {
            retrievalCompletions.append(completion)
            receivedMessages.append(.retrieve)
        }

        func completeRetrieval(with error: Error, at index: Int = 0) {
            retrievalCompletions[index](.failure(error))
        }

        func completeRetrievalWithEmptyCache(at index: Int = 0) {
            retrievalCompletions[index](.success(.none))
        }

        func completeRetrieval(with local: [Local], timestamp: Date, at index: Int = 0) {
            retrievalCompletions[index](.success(CachedItem(item: local, timestamp: timestamp)))
        }
    }
}


extension Date {
    func minusCacheMaxAge() -> Date {
        return adding(days: -fontCacheMaxAgeInDays)
    }
    
    private var fontCacheMaxAgeInDays: Int {
        return 7
    }
    
    private func adding(days: Int) -> Date {
        return Calendar(identifier: .gregorian).date(byAdding: .day, value: days, to: self)!
    }
}

extension Date {
    func adding(seconds: TimeInterval) -> Date {
        return self + seconds
    }
}
