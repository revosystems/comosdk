import Foundation

extension Como.Api {

    public enum ResponseStatus:String, Codable {
        case ok, error
    }

    public struct ResponseError:Codable {
        public let code:String
        public let message:String
        public let cause:String?
    }

    //https://forums.swift.org/t/inheriting-from-a-codable-class/14874/10
    public class Response: CustomStringConvertible {    //When making only the subclasses codable, we avoid that ugly codingkeys thing
        let status:ResponseStatus = .ok
        let errors:[ResponseError]? = nil
        
        public var description: String {
            errors?.map { $0.code + ": " + $0.message }.implode("\n") ?? "OK"
        }
    }
    
    public class DefaultResponse : Response, Codable { }
    
    enum ResponseErrorCode:Error {
        case invalidInputData
        case noData
        case errorStatus
        case invalidResponse
        case errorResponse(errors:[ResponseError]?)
    }

}
