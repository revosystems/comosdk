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

    public class Response:Codable, CustomStringConvertible {
        let status:ResponseStatus
        let errors:[ResponseError]?
        
        public var description: String {
            errors?.map { $0.code + ": " + $0.message }.implode("\n") ?? "OK"
        }
    }
    
    enum ResponseErrorCode:Error {
        case invalidInputData
        case noData
        case errorStatus
        case invalidResponse
        case errorResponse(errors:[ResponseError]?)
    }

}
