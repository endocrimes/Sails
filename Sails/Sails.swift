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
                    _ = self.parserType.init()
                }
            }
        }
    }
}