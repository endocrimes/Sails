//
//  Socket.swift
//  Sails
//
//  Created by  Danielle Lancashireon 03/10/2015.
//  Copyright © 2015 Danielle Lancashire. All rights reserved.
//


import Foundation /* currently dependant on Foundation for String -> NSData */


public enum SocketErrors: ErrorType {
    case PosixSocketInitializationFailed
    case PosixSocketWriteFailed
    case StringDataConversionFailed
    case PosixSocketAcceptFailed
}

public typealias POSIXSocket = CInt

public class Socket {
    private let posixSocket: POSIXSocket
    
    public init(posixSocket: POSIXSocket) {
        self.posixSocket = posixSocket
    }
    
    public init(port: in_port_t = 8080) throws {
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

public extension Socket {
    func sendData(data: NSData) throws {
        var totalSent = 0
        let unsafePointer = UnsafePointer<UInt8>(data.bytes)
        while totalSent < data.length {
            let sent = write(posixSocket, unsafePointer + totalSent, Int(data.length - totalSent))
            guard sent != 0 else {
                throw SocketErrors.PosixSocketWriteFailed
            }
            
            totalSent += sent
        }
    }
    
    func sendUTF8(string: String) throws {
        guard let utf8Data = string.dataUsingEncoding(NSUTF8StringEncoding) else {
            throw SocketErrors.StringDataConversionFailed
        }
        
        try sendData(utf8Data)
    }
}

public extension Socket {
    func peername() -> String? {
        var addr = sockaddr(), len: socklen_t = socklen_t(sizeof(sockaddr))
        guard getpeername(posixSocket, &addr, &len) != 0 else {
            return nil
        }
        
        var hostBuffer = [CChar](count: Int(NI_MAXHOST), repeatedValue: 0)
        guard getnameinfo(&addr, len, &hostBuffer, socklen_t(hostBuffer.count), nil, 0, NI_NUMERICHOST) != 0 else {
            return nil
        }
        
        return String.fromCString(hostBuffer)
    }
}

public extension Socket {
    func acceptClient() throws -> Socket {
        var addr = sockaddr(sa_len: 0, sa_family: 0, sa_data: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0))
        var len: socklen_t = 0
        
        let clientSocket = accept(posixSocket, &addr, &len)
        guard clientSocket != -1 else {
            throw SocketErrors.PosixSocketAcceptFailed
        }
        
        nosigpipe(clientSocket)
        
        return Socket(posixSocket: clientSocket)
    }
}

public extension Socket {
    func close() {
        releaseSocket(posixSocket)
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
