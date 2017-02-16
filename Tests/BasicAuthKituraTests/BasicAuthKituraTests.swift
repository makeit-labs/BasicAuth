import XCTest

@testable import Kitura
@testable import KituraNet
@testable import BasicAuthKitura

extension String {
    func base64Encoded() -> String? {
        if let data = self.data(using: .utf8) {
            return data.base64EncodedString()
        }
        return nil
    }
}

class RouterRequestStub: RouterRequestProtocol {
    var headers: Headers
    var urlURL: URL

    init(headers: Headers, urlURL: URL) {
        self.headers = headers
        self.urlURL = urlURL
    }
}

class BasicAuthKituraTests: XCTestCase {
    func testBasicAuthURL() {
        let headers = Headers(headers: HeadersContainer())
        let urlURL = URL(string: "http://john:johnpass@example.com/")!
        let request = RouterRequestStub(headers: headers, urlURL: urlURL)

        XCTAssertEqual(basicAuth(request)?.name, "john")
        XCTAssertEqual(basicAuth(request)?.password, "johnpass")
    }

    func testBasicAuthHeaders() {
        let encodedCredentials = "mary:marypass".base64Encoded()!
        let headerContainer = HeadersContainer()
        headerContainer.append("Authorization", value: "Basic \(encodedCredentials)")
        let headers = Headers(headers: headerContainer)
        let urlURL = URL(string: "http://example.com/")!
        let request = RouterRequestStub(headers: headers, urlURL: urlURL)

        XCTAssertEqual(basicAuth(request)?.name, "mary")
        XCTAssertEqual(basicAuth(request)?.password, "marypass")
    }
}
