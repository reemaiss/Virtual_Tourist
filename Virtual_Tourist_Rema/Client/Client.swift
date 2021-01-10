//
//  Client.swift
//  Virtual_Tourist_Rema
//
//  Created by Rema alsuwailm on 26/05/1442 AH.
//

import Foundation

// bd84fc89211a7918ecb9c2754af718eb
// 1216d82de19fed18

class Client {
    
    struct Constants {
        static let ApiKey = "bd84fc89211a7918ecb9c2754af718eb"
        static let ApiSecret = "1216d82de19fed18"
        static let BaseURL = "https://api.flickr.com/services/rest"
        static let Method = "flickr.photos.search"
        static let Pages = 12
    }
    
    enum Endpoints {
        case  getPhotosByLocation(Double,Double)
        
        var stringValue: String {
            switch self {
            case .getPhotosByLocation(let lat, let lon) :
                return"\(Constants.BaseURL)?api_key=\(Constants.ApiKey)&method=\(Constants.Method)&per_page=\(Constants.Pages)&format=json&nojsoncallback=?&lat=\(lat)&lon=\(lon)&page=\((1...10).randomElement() ?? 1)"
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    
    class func taskForGETRequest<ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void) -> URLSessionDataTask {
        print("the url is\(url)and \(responseType)")
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            let decoder = JSONDecoder()
            do {
                var potosUrl: [String] = []
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                do {
                    let errorResponse = try decoder.decode(ErorrResponse.self, from: data) as Error
                        //as Error
                    DispatchQueue.main.async {
                        completion(nil, errorResponse)
                    }
                } catch {
                    DispatchQueue.main.async {
                        print("so \(error)")
                        completion(nil, error)
                    }
                }
            }
        }
        task.resume()
        return task
    }
    
    class func getPhotosByLocationRequst(long: Double, lat: Double , completion: @escaping(Bool,[PhotoObj],Error?)->Void){
        var photos: [PhotoObj] = []
        taskForGETRequest(url: Endpoints.getPhotosByLocation(lat, long).url, responseType: locationPhotoResponse.self) { (response, error) in
            if let response = response {
                completion(true,response.photos.photo,nil)
                return photos = response.photos.photo
            } else {
                completion(false,response?.photos.photo ?? [] ,error)
            }
        }
    }
    
}
