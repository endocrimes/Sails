//
//  Sails.swift
//  Sails
//
//  Created by  Danielle Lancashireon 03/10/2015.
//  Copyright © 2015 Danielle Lancashire. All rights reserved.
//

public class Sails {
    private let router: Router
    private let socket: Socket
    private let parserType: HTTPParser.Type
    private let clientQueue = dispatch_queue_create("co.rocketapps.Sails.clientQueue", nil)
    
    init(socket: Socket = try! Socket(port: 8080), router: Router, parserType: HTTPParser.Type = ConcreteHTTPParser.self) {
        self.socket = socket
        self.router = router
        self.parserType = parserType
    }
    
    func start() {
        dispatch_async(clientQueue) {
            while let client = try? self.socket.acceptClient() {
                guard let clientAddress = client.peername() else { return }
                print("New connection from: ", clientAddress)
                
                dispatch_async(self.clientQueue) {
                    let parser = self.parserType.init()
                    while let request = parser.parse(client), let handler = self.router.handlerForRequest(request) {
                        let response = handler(request)
                        Sails.respond(client, response: response)
                        client.close()
                    }
                }
            }
            
            self.stop()
        }
    }
    
    func stop() {
        socket.close()
    }
    
    private static func respond(socket: Socket, response: HTTPResponse) {
        do {
            try socket.sendUTF8("HTTP/1.1 \(response.statusCode)\r\n")
            if let body = response.body {
                try socket.sendUTF8("Content-Length: \(body.length)\r\n")
            } else {
                try socket.sendUTF8("Content-Length: 0\r\n")
            }
            for (name, value) in response.headers {
                try socket.sendUTF8("\(name): \(value)\r\n")
            }
            try socket.sendUTF8("\r\n")
            if let body = response.body where response.method != .HEAD  {
                try socket.sendData(body)
            }
        }
        catch {
            
        }
    }
}