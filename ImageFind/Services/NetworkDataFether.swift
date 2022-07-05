//
//  NetworkDataFether.swift
//  ImageFind
//
//  Created by Anna Nosyk on 01/07/2022.
//

import Foundation

class NetworkDataFether {
    var networkService = NetworkService()
    // for getting data
    func getImages(searchText: String, completion: @escaping (SearchResults?)->()) {
        networkService.request(searchText: searchText) { data, error in
            if let error = error {
                print(error.localizedDescription)
                // no data
                completion(nil)
            }
            
            let decode = self.decodeJSON(type: SearchResults.self, from: data)
            completion(decode)
        }
    }
    //convert JSON data
    func decodeJSON<T:Decodable>(type: T.Type, from: Data?)-> T? {
        let decoder = JSONDecoder()
        guard let data = from else {return nil}
        
        do {
            let object = try decoder.decode( type.self, from: data)
            return object
        } catch let jsonError {
            print("Failed to decode JSON \(jsonError)")
            return nil
        }
    }
}
