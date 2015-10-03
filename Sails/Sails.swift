//
//  Sails.swift
//  Sails
//
//  Created by  Danielle Lancashireon 03/10/2015.
//  Copyright © 2015 Danielle Lancashire. All rights reserved.
//

public protocol Router {
    
}

public class Sails {
    private let router: Router
    
    init(router: Router) {
        self.router = router
    }
}