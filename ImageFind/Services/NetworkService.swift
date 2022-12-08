//
//  NetworkService.swift
//  ImageFind
//
//  Created by Anna Nosyk on 01/07/2022.



import Foundation

class NetworkService {
    
    // get URL request
    func request(searchText: String, completion: @escaping (Data?, Error?) -> Void) {
        let parameters = self.setupParameters(searchText: searchText)
        let url = self.url(param: parameters)
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = setupHeders()
        request.httpMethod = "get"
        let task = createDataTask(from: request, completion: completion)
        task.resume()
        
        print(url)
        
    }
    
    //for headers in request
    private func setupHeders() -> [String:String]? {
        var headers = [String: String]()
        headers["Authorization"] = "Client-ID byjZNZL2pG_65flBC7l-KaCbsw3dXqbHE-83YsfOu0Q"
        return headers
    }
    
    // for parameters in url string
    private func setupParameters(searchText: String) -> [String:String] {
        var parameters = [String:String]()
        parameters["query"] = searchText
        parameters["page"] = String(1)
        parameters["per_page"] = String(50)
        return parameters
    }
    
    //for the url string
    private  func url(param: [String: String]) -> URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.unsplash.com"
        components.path = "/search/photos"
        components.queryItems = param.map{
            URLQueryItem(name: $0, value: $1)
        }
        
        return components.url!
    }
    
    //for url session dataTask
    private func createDataTask(from request: URLRequest,completion: @escaping (Data?, Error?) -> Void) -> URLSessionDataTask {
        return URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                completion(data, error)
            }
            
        }
    }
}
