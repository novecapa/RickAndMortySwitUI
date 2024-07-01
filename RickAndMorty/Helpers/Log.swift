//
//  Log.swift
//  RickAndMorty
//
//  Created by Josep Cerdá Penadés on 11/6/24.
//

import Foundation

class Log {

    static func thisRequest(_ response: HTTPURLResponse, data: Data, request: URLRequest?) {
        let code = response.statusCode
        let url  = response.url?.absoluteString ?? ""
        let icon  = [200, 201, 204].contains(code) ? "✅" : "❌"
        print("------------------------------------------")
        print("\(icon) 🔽 [\(code)] \(url)")
        print("\(data.prettyPrintedJSONString ?? "")")
        print("\(icon) 🔼 [\(code)] \(url)")
        print("------------------------------------------")
    }
}
extension Data {
    var prettyPrintedJSONString: String? {
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
              let data = try? JSONSerialization.data(withJSONObject: object,
                                                     options: [.withoutEscapingSlashes]),
              let prettyPrintedString = String(data: data,
                                               encoding: .utf8) else { return nil }
        return prettyPrintedString
    }
}
