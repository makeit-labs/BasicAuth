# BasicAuth 🔑🗝🔎

Generic basic auth Authorization header field parser for [Kitura](http://www.kitura.io/) (Swift 3).

(Not associated with or endorsed by the Kitura team.)

## Motivation
Kitura is a fast, lightweight web server framework for Swift 3.

While [Kitura-CredentialsHTTP](https://github.com/IBM-Swift/Kitura-CredentialsHTTP)
provides a complete authentication framework that is pluggable,
there are times when reading the auth header directly is useful.

You might want to parse the Basic Auth headers yourself in a custom
middleware, for example.

BasicAuth simply extracts the Authorization parser from Kitura-CredentialsHTTP
and packages it into a single easy-to-use function that optionally returns
the user's credentials.

Inspired by the [Node.js](https://nodejs.org/en/) library [basic-auth](https://github.com/jshttp/basic-auth).

## Installation

This is a Swift Package manager module. Install it by including it in your
`Package.swift` file.

```swift
    dependencies: [
        .Package(url: "https://github.com/makeit-labs/BasicAuth.git", majorVersion: 1, minor: 0)
    ]
```

## Usage

```swift
import Foundation
import Kitura
import BasicAuth

let router = Router()
let users = ["john" : "1234", "mary" : "1234"]

let basicAuthMiddleware = RouterMiddlewareGenerator { request, response, next in
    guard let user = basicAuth(request),
        let storedPassword = users[user.name],
        (storedPassword == user.password) else {
        response.headers.append("WWW-Authenticate", value: "Basic realm=\"User\"")
        try response.send(status: .unauthorized).end()
        return
    }
    next()
}

router.all("/", middleware: basicAuthMiddleware)
```

### `UserCredentials`

Just a plain old Swift struct that holds the credentials.

```swift
public struct UserCredentials {
    public var name: String
    public var password: String
}
```

### `basicAuth(_ request: RouterRequestProtocol) -> UserCredentials?`

Get the basic auth credentials from the given request. If there is a basic auth
component in the URL, the username and password are returned. Else, the
`Authorization` header is parsed and if the header is invalid, `nil` is
returned, otherwise a `UserCredentials` object with `name` and `password`,
properties.

## Attributions

Most of the code contained in BasicAuth is from [Kitura-CredentialsHTTP](https://github.com/IBM-Swift/Kitura-CredentialsHTTP).

## License

This library is licensed under Apache 2.0. Full license text is available in
[LICENSE](LICENSE).
