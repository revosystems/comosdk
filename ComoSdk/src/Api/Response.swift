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
    
    enum ResponseErrorCode:Error, CustomStringConvertible {       
        case sdkNotSettedUp
        case invalidInputData
        case noData
        case errorStatus
        case invalidResponse
        case errorResponse(errors:[ResponseError]?)
        
        var description: String {
            switch self {
            case .sdkNotSettedUp: return "Como SDK has not been set up, call Como.shared.setup() to fix it"
            case .invalidInputData : return  "Invalid Input data"
            case .noData: return "Didn't receive response Data"
            case .errorStatus: return "No 200 status received"
            case .invalidResponse : return "Can't decode de response"
            case .errorResponse(let errors) : return errors?.map { $0.message }.implode(", ") ?? "Unknown error"
            }
        }
        
    }

}
