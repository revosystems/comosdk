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

    struct Response:Codable {
        let status:ResponseStatus
        let errors:[ResponseError]?
    }
    
    enum ResponseErrorCode:Error {
        case noData
        case errorStatus
        case invalidResponse
        case errorResponse(errors:[ResponseError]?)
    }

}
