import Foundation
import RevoHttp

public class ComoApi {
    
    let url:String = "https://api.prod.como.com/api/v4/advanced/"
    
    let apiKey:String = "TOKEN"
    let branchId:String = ""
    let posId:String = ""
    let source:String = ""
    let sourceVersion:String = ""
    
    
    func submitEvent(then:@escaping(Result<ComoApi.Response, Error>) -> Void){
        Http.post(url + "submitEvent", headers: headers) { response in
            //print(response.toString)

            guard let data = response.data else {
                return then(.failure(ResponseErrorCode.noData))
            }
            
            guard let apiResponse = try? ComoApi.Response.decode(from: data) else {
                return then(.failure(ResponseErrorCode.invalidResponse))
            }
            
            guard apiResponse.status == .ok else {
                return then(.failure(ResponseErrorCode.errorResponse(errors: apiResponse.errors)))
            }
            
            guard response.statusCode >= 200, response.statusCode < 300 else {
                return then(.failure(ResponseErrorCode.errorStatus))
            }
            
            then(.success(apiResponse))
        }
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
