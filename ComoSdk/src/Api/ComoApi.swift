import Foundation
import RevoHttp

public class ComoApi {
    
    //let url:String = "https://api.prod.como.com/api/v4/advanced/"
    let url:String = "https://api.prod.bcomo.com/api/v4/advanced/"
    
    let apiKey:String        = "TOKEN"
    let branchId:String      = ""
    let posId:String         = ""
    let source:String        = ""
    let sourceVersion:String = ""
    
    
    //MARK: - Structs
    public class MemberDetailsResponse : Response {
        //let membership:String? = nil
        let memberNotes:[MemberNote]
    }
    
    public class MemberNote:Codable {
        let content:String
        let type:String
    }
    
    //MARK: - Methods
    public func getMemberDetails(customer:ComoCustomer, purchase:ComoPurchase, then:@escaping(Result<MemberDetailsResponse, Error>) -> Void){
        
        struct MemberDetails : Codable {
            let customer:ComoCustomer
            let purchase:ComoPurchase
        }
        
        let object = MemberDetails(customer: customer, purchase: purchase)
                      
        post("getMemberDetails?returnAssets=active&expand=assets.redeemable", object:object, then:then)
    }
    
    public func quickRegister(phoneNumber:String, email:String? = nil, authCode:String? = nil, then:@escaping(Result<ComoApi.Response, Error>) -> Void){
                
        struct QuickRegister : Codable {
            let customer:ComoCustomer
            let quickRegistrationCode:String?
        }
        
        let object = QuickRegister(customer: ComoCustomer(phoneNumber: phoneNumber, email: email), quickRegistrationCode: authCode)
        
        post("registration/quick", object:object, then: then)
    }
    
    public func submitEvent(then:@escaping(Result<ComoApi.Response, Error>) -> Void){
        post("submitEvent", then:then)
    }
    
    
    //MARK: -
    private func post<T>(_ url:String, object:Codable? = nil, then:@escaping(Result<T, Error>) -> Void) where T: ComoApi.Response {
        
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

    private func parse<T>(response:HttpResponse) -> Result<T, Error> where T:ComoApi.Response {
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
