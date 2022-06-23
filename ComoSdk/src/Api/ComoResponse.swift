import Foundation

public extension ComoApi {

    enum ResponseStatus:String, Codable {
        case ok, error
    }

    struct ResponseError:Codable {
        let code:String
        let message:String
        let cause:String?
    }

    class Response:Codable, CustomStringConvertible {
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
