//
//  Socket.swift
//  Sails
//
//  Created by  Danielle Lancashireon 03/10/2015.
//  Copyright © 2015 Danielle Lancashire. All rights reserved.
//

enum SocketErrors: ErrorType {
    case PosixSocketInitializationFailed
}

private typealias POSIXSocket = CInt

class Socket {
    private let posixSocket: POSIXSocket
    
    init(port: in_port_t = 8080) throws {
        posixSocket = socket(AF_INET, SOCK_STREAM, 0)
        guard posixSocket != -1 else {
            releaseSocket(posixSocket)
            throw SocketErrors.PosixSocketInitializationFailed
        }
        
        var value: Int32 = 1;
        guard setsockopt(posixSocket, SOL_SOCKET, SO_REUSEADDR, &value, socklen_t(sizeof(Int32))) != -1 else {
            releaseSocket(posixSocket)
            throw SocketErrors.PosixSocketInitializationFailed
        }
        
        nosigpipe(posixSocket)
        
        var addr = sockaddr_in(sin_len: __uint8_t(sizeof(sockaddr_in)), sin_family: sa_family_t(AF_INET), sin_port: port_htons(port), sin_addr: in_addr(s_addr: inet_addr("0.0.0.0")), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        var sock_addr = sockaddr(sa_len: 0, sa_family: 0, sa_data: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0))
        
        memcpy(&sock_addr, &addr, Int(sizeof(sockaddr_in)))
        guard bind(posixSocket, &sock_addr, socklen_t(sizeof(sockaddr_in))) != -1 else {
            releaseSocket(posixSocket)
            throw SocketErrors.PosixSocketInitializationFailed
        }
        guard listen(posixSocket, 20 /* max pending connection */ ) != -1 else {
            releaseSocket(posixSocket)
            throw SocketErrors.PosixSocketInitializationFailed
        }
    }
}

private func port_htons(port: in_port_t) -> in_port_t {
    let isLittleEndian = Int(OSHostByteOrder()) == OSLittleEndian
    return isLittleEndian ? _OSSwapInt16(port) : port
}

private func nosigpipe(socket: POSIXSocket) {
    // prevents crashes when blocking calls are pending and the app is paused.
    var no_sig_pipe: Int32 = 1;
    setsockopt(socket, SOL_SOCKET, SO_NOSIGPIPE, &no_sig_pipe, socklen_t(sizeof(Int32)));
}

private func releaseSocket(socket: POSIXSocket) {
    shutdown(socket, SHUT_RDWR)
}
