import Foundation
import RevoHttp

extension Como {
    
    public class Api {
    
        //let url:String = "https://api.prod.como.com/api/v4/advanced/"
        let url:String = "https://api.prod.bcomo.com/api/v4/advanced/"
        
        let apiKey:String        = "TOKEN"
        let branchId:String      = ""
        let posId:String         = ""
        let source:String        = ""
        let sourceVersion:String = ""
         
        
        //MARK: -
        public func post<T:Codable>(_ url:String, object:Codable? = nil, then:@escaping(Result<T, Error>) -> Void) where T: Como.Api.Response {
            
            guard let object = object else{
                return Http.post(self.url + url, headers: headers) { response in
                    then(self.parse(response: response))
                }
            }
                    
            guard let body = try? object.json() else {
                return then(.failure(ResponseErrorCode.invalidInputData))
            }
            
            print("[COMO] Request: " + body)
            
            Http.post(self.url + url, body:body, headers: headers) { response in
                then(self.parse(response: response))
            }
        }

        private func parse<T:Codable>(response:HttpResponse) -> Result<T, Error> where T:Como.Api.Response {
            guard let data = response.data else {
                return .failure(ResponseErrorCode.noData)
            }
            
            guard let apiResponse = try? T.decode(from: data) else {
                return .failure(ResponseErrorCode.invalidResponse)
            }
            
            guard apiResponse.status == .ok else {
                return .failure(ResponseErrorCode.errorResponse(errors: apiResponse.errors))
            }
            
            guard response.statusCode >= 200, response.statusCode < 300 else {
                return .failure(ResponseErrorCode.errorStatus)
            }
            
            return .success(apiResponse)
        }
        
        private var headers:[String:String] {
            [
                "Content-Type" : "application/json",
                "X-Api-Key" : apiKey,
                "X-Branch-Id" : branchId,
                "X-Pos-Id" : posId,
                "X-Source-Type" : "App",
                "X-Source-Name" : source,
                "X-Source-Version" : sourceVersion
            ]
        }
    }
}