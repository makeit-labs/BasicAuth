import Foundation
import Kitura

public protocol RouterRequestProtocol {
    var headers: Headers { get }
    var urlURL: URL { get }
}

extension RouterRequest: RouterRequestProtocol {

}
