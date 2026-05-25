//
//  URLSessionProtocol.swift
//  StackFollow
//
//  Created by Mac on 25.05.2026.
//

import Foundation

protocol URLSessionProtocol {

    func data(from url: URL) async throws -> (Data, URLResponse)
}

extension URLSession: URLSessionProtocol {}
