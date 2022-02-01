//
//  ApiRest.swift
//  MovieApp
//
//  Created by osvaldo cespedes on 28/01/22.
//

import Foundation

class APIService {

    static var shared:APIService {
        return APIService()
    }

    var BASE_GATEWAY:String {
        switch Environment.init(rawValue: AppInfo.shared.environment){
        case .Development:
            return "https://api.themoviedb.org/3/"
        case .Production:
            return ""
        case .QA:
            return ""
        default:
            return ""
        }
    }
    
    var accessToken = "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI0MDA5ZDFiMTFkZWRiNWFlZTNmOWI1NjE3YjhhNDJjMiIsInN1YiI6IjVmZTEwZjZlYWI2ODQ5MDAzZjdmNzM4MiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.L5FK8ilJjbClDwfCzhR8ZWbcjMRnb7xDY5m3b-LOVns"
    var apiKey = "4009d1b11dedb5aee3f9b5617b8a42c2"
    var imageBase = "https://image.tmdb.org/t/p/original"
    
    init() {
        
    }
    
}

extension APIService {
    
    func apiRequest<model:Decodable>(_ url: String,
                                     _ model : model.Type?,
                                     _ methodType: HTTPMethod = .get,
                                     _ parameters: [String: Any]? = [:],
                                     _ headers:[String: Any]? = [:],
                                     onSuccess: @escaping (model) -> (),
                                     onFailure: @escaping (String) -> ()) {
        
        guard InternetConnectionManager.isConnectedToNetwork() else {
            onFailure(Localizable.text(.without_internet))
            return
        }
        
        guard let urlRequest:URLRequest = self.createRequest(url:url,
                                                             method:methodType,
                                                             parameters: parameters,
                                                             headers:headers) else {
            onFailure(Localizable.error.Service_not_available.localized)
            return
        }
        
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            
            self.printRequest(urlRequest: urlRequest,
                              data:data,
                              error:error?.localizedDescription)
            
            guard let safeData = data,
                  let response = response as? HTTPURLResponse,
                  error == nil else {
                      onFailure(error?.localizedDescription ?? Localizable.error.Service_not_available.localized)
                      return
                  }
            
            guard (200 ... 299) ~= response.statusCode else {
                onFailure(Localizable.error.Service_not_available.localized)
                return
            }
            
            do
            {
               let decoder = JSONDecoder()
               let result = try decoder.decode(model!.self, from: safeData)
               onSuccess(result)
            }
            catch let errorCodable
            {
                print(errorCodable)
                onFailure(Localizable.error.Service_not_available.localized)
                return
            }

        }.resume()

    }
            
}

extension APIService {
    
    //
    // Create request
    private func createRequest(url:String,
                               method: HTTPMethod,
                               parameters: [String: Any]? = [:],
                               headers:[String: Any]? = [:]) -> URLRequest? {
        
        guard let api = URL(string: url) else {
            return nil
        }
        
        var request = URLRequest(url: api)
        request.httpMethod = method.rawValue
        
        if let headers = headers as? [String : String],  headers.count > 0 {
            request.allHTTPHeaderFields = headers
        } else {
            request.allHTTPHeaderFields = ["Content-Type": "application/json", "Accept": "application/json" ] as [String:String]
        }
       
        request.timeoutInterval = 360

        if let parameters = parameters,
           parameters.count > 0 {
            request.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: .fragmentsAllowed)
        }
        return request
    }
    
    //
    //MARK debug api rest
    private func printRequest(urlRequest:URLRequest,
                              data:Data?,
                              error:String?) {
        
        guard Setting.activePrintRequest else {
           return
        }
        
        debugPrint("-------- REQUEST INFORMATION --------------")
        debugPrint("URL: \(urlRequest.url!)")
        debugPrint("METHOD: \(String(describing: urlRequest.httpMethod))")
        debugPrint("Request Header: \(String(describing: urlRequest.allHTTPHeaderFields))")

        if let body = urlRequest.httpBody,
           let strbody = NSString(data: body, encoding: String.Encoding.utf8.rawValue) {
            debugPrint("Request Params: \(strbody)")
        }
        
       if let data = data {
            do {
                // make sure this JSON is in the format we expect
                // convert data to json
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    // try to read out a dictionary
                    debugPrint("Response: \(json)")
                }
            } catch let error as NSError {
                debugPrint("Failed to load: \(error.localizedDescription)")
            }
        }
        
        if let error = error {
            debugPrint("Error: \(error)")
        }
    }
    
}

