// Swift Test Template
// 使用方法: このファイルをコピーして YourAppTests/ に配置

import XCTest
@testable import YourApp

final class [FeatureName]Tests: XCTestCase {

  // MARK: - Properties

  var sut: [ClassToTest]!  // System Under Test

  // MARK: - Lifecycle

  override func setUp() {
    super.setUp()
    sut = [ClassToTest]()
  }

  override func tearDown() {
    sut = nil
    super.tearDown()
  }

  // MARK: - Tests

  func test初期状態() {
    // Arrange & Act
    // setUp()で初期化済み

    // Assert
    XCTAssertNotNil(sut)
  }

  func testサンプルメソッド() {
    // Arrange
    let input = "test input"
    let expected = "expected output"

    // Act
    let result = sut.sampleMethod(input: input)

    // Assert
    XCTAssertEqual(result, expected)
  }

  func test非同期処理() async throws {
    // Arrange
    let expectedValue = "async result"

    // Act
    let result = try await sut.fetchData()

    // Assert
    XCTAssertEqual(result, expectedValue)
  }

  func testエラーハンドリング() {
    // Arrange
    let invalidInput = ""

    // Act & Assert
    XCTAssertThrowsError(try sut.validate(input: invalidInput)) { error in
      XCTAssertTrue(error is ValidationError)
    }
  }

  func testパフォーマンス() {
    // Arrange
    let largeArray = (0..<10000).map { $0 }

    // Act & Assert
    measure {
      _ = sut.processArray(largeArray)
    }
  }
}

// MARK: - ViewModel Tests Example

final class [FeatureName]ViewModelTests: XCTestCase {

  var sut: [FeatureName]ViewModel!
  var mockRepository: Mock[FeatureName]Repository!

  override func setUp() {
    super.setUp()
    mockRepository = Mock[FeatureName]Repository()
    sut = [FeatureName]ViewModel(repository: mockRepository)
  }

  override func tearDown() {
    sut = nil
    mockRepository = nil
    super.tearDown()
  }

  func testデータ取得成功() async {
    // Arrange
    let mockData = [MockModel(id: "1", name: "Test")]
    mockRepository.fetchDataResult = .success(mockData)

    // Act
    await sut.loadData()

    // Assert
    switch sut.state {
    case .loaded(let data):
      XCTAssertEqual(data.count, 1)
      XCTAssertEqual(data.first?.name, "Test")
    default:
      XCTFail("Expected loaded state")
    }
  }

  func testデータ取得失敗() async {
    // Arrange
    let mockError = NSError(domain: "test", code: 500)
    mockRepository.fetchDataResult = .failure(mockError)

    // Act
    await sut.loadData()

    // Assert
    switch sut.state {
    case .error(let error):
      XCTAssertNotNil(error)
    default:
      XCTFail("Expected error state")
    }
  }
}

// MARK: - Mock Repository

class Mock[FeatureName]Repository: [FeatureName]RepositoryProtocol {
  var fetchDataResult: Result<[MockModel], Error> = .success([])

  func fetchData() async throws -> [MockModel] {
    switch fetchDataResult {
    case .success(let data):
      return data
    case .failure(let error):
      throw error
    }
  }
}

// MARK: - Mock Model

struct MockModel: Codable, Identifiable, Equatable {
  let id: String
  let name: String
}
