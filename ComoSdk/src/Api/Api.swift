import Foundation
import RevoHttp

extension Como {
    
    public class Api {
    
        //let url:String = "https://api.prod.como.com/api/v4/advanced/"
        let url:String = "https://api.prod.como.com/api/v4/"
        
        let apiKey:String
        let branchId:String
        let posId:String
        let source:String
        let sourceVersion:String
         
        var debug:Bool
        
        
        init(key:String, branchId:String, posId:String, source:String, sourceVersion:String, debug:Bool = false) {
            self.apiKey     = key
            self.branchId   = branchId
            self.posId      = posId
            self.source     = source
            self.sourceVersion = sourceVersion
            self.debug      = debug
        }
        
        
        public func post<T>(_ url:String, object:Codable? = nil) async throws -> T where T: Como.Api.Response {
            return try await withCheckedThrowingContinuation { continuation in
                post(url, object: object) { (result:Result<T,Error>) in
                    switch result {
                    case .success(let response) : continuation.resume(returning: response)
                    case .failure(let error) : continuation.resume(throwing: error)
                    }
                }
            }
        }
        
        //MARK: -
        private func post<T>(_ url:String, object:Codable? = nil, then:@escaping(Result<T, Error>) -> Void) where T: Como.Api.Response {
            
            guard let object = object else{
                return Http.post(self.url + url, headers: headers) { response in
                    then(self.parse(response: response))
                }
            }
                    
            guard let body = try? object.json(with:encoder) else {
                return then(.failure(ResponseErrorCode.invalidInputData))
            }
            
            if debug {
                print("[COMO] Request: " + body)
            }
            
            Http.post(self.url + url, body:body, headers: headers) { response in
                then(self.parse(response: response))
            }
        }

        private func parse<T>(response:HttpResponse) -> Result<T, Error> where T:Como.Api.Response {
            guard let data = response.data else {
                return .failure(ResponseErrorCode.noData)
            }

            if debug {
                print("[COMO] Response: " + response.toString)
            }
            
            do {
                let apiResponse = try decoder.decode(T.self, from: data)
                guard apiResponse.status == .ok else {
                    return .failure(ResponseErrorCode.errorResponse(errors: apiResponse.errors))
                }
                
                guard response.statusCode >= 200, response.statusCode < 300 else {
                    return .failure(ResponseErrorCode.errorStatus)
                }
                return .success(apiResponse)
            } catch {
                if debug {
                    print("[COMO - Decoding response error]" + error.localizedDescription)
                    print(error)
                }
                return .failure(ResponseErrorCode.invalidResponse)
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
        
        lazy var decoder:JSONDecoder = {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            return decoder
        }()
        
        lazy var encoder:JSONEncoder = {
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            return encoder
        }()
    }
}
