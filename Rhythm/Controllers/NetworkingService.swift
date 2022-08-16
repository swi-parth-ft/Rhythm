//
//  NetworkingService.swift
//  Rhythm
//
//  Created by Vrushank on 2022-08-06.
//

import Foundation
import UIKit

class NetworkingService{
//    var delegate : networkingDelegateProtocol?
    static var Shared = NetworkingService()
    
    var userEmail :String = ""
    
    func setUserEmail(email:String){
        self.userEmail = email
    }
    
    func getUserEmail() -> String{
        return self.userEmail
    }
    
    //get tracks details from API using completion handler
    func getTracksFromURL(url:String,completionHandler : @escaping (Result <Summary, Error>)->Void ){
        
        
        let urlObj = URL(string:url)!
        
        let task = URLSession.shared.dataTask(with: urlObj)
        {
            data,response,error in
            guard error == nil else{
                completionHandler(.failure(error!))
                return
            }
            guard let httpResponse = response as? HTTPURLResponse,(200...299).contains(httpResponse.statusCode) else{
                print("Incorrect response")
                return
            }
            if let jsonData = data{
                print(jsonData)
                let decoder = JSONDecoder()
                do{
                    let result = try decoder.decode(Summary.self,from:jsonData)
//                    print(result)
                    
                    completionHandler(.success(result))
                }
                catch{
                    print(error)
                }
            }
        }
        task.resume()
    }
    
    //getImage using completion handler
    func getImage(albumId:String, completionHandler : @escaping (Result <UIImage, Error>)->Void ){
        let imageUrl = "https://api.napster.com/imageserver/v2/albums/\(albumId)/images/500x500.jpg"
        let urlObj = URL(string: imageUrl)!
        
        let task = URLSession.shared.dataTask(with: urlObj)
        { data, response, error in
            guard error == nil else {
                completionHandler(.failure(error!))
                return
            }
            guard let httpRespons = response as? HTTPURLResponse, (200...299).contains(httpRespons.statusCode) else {
                print ("Incorrect response ")
                return
            }
            
            if let imageData = data {
                let image = UIImage(data:imageData)
                completionHandler(.success(image!))
            }
        }
        task.resume()
    }
    
    
    //get genres details from API using completion handler
    func getGenresFromURL(completionHandler : @escaping (Result <Genre, Error>)->Void ){
        
        let url = "https://api.napster.com/v2.2/genres?apikey=YTkxZTRhNzAtODdlNy00ZjMzLTg0MWItOTc0NmZmNjU4Yzk4"
        
        let urlObj = URL(string:url)!
        
        let task = URLSession.shared.dataTask(with: urlObj)
        {
            data,response,error in
            guard error == nil else{
                completionHandler(.failure(error!))
                return
            }
            guard let httpResponse = response as? HTTPURLResponse,(200...299).contains(httpResponse.statusCode) else{
                print("Incorrect response")
                return
            }
            if let jsonData = data{
                print(jsonData)
                let decoder = JSONDecoder()
                do{
                    let result = try decoder.decode(Genre.self,from:jsonData)
//                    print(result)
                    
                    completionHandler(.success(result))
                }
                catch{
                    print(error)
                }
            }
        }
        task.resume()
    }
    
    //get genres details from API using completion handler
    func getAlbumsFromURL(url:String,completionHandler : @escaping (Result <Albums, Error>)->Void ){
        
        let urlObj = URL(string:url)!
        
        let task = URLSession.shared.dataTask(with: urlObj)
        {
            data,response,error in
            guard error == nil else{
                completionHandler(.failure(error!))
                return
            }
            guard let httpResponse = response as? HTTPURLResponse,(200...299).contains(httpResponse.statusCode) else{
                print("Incorrect response")
                return
            }
            if let jsonData = data{
                print(jsonData)
                let decoder = JSONDecoder()
                do{
                    let result = try decoder.decode(Albums.self,from:jsonData)
//                    print(result)
                    
                    completionHandler(.success(result))
                }
                catch{
                    print(error)
                }
            }
        }
        task.resume()
    }
    
//    //get new releases from API using completion handler
//    func getNewReleasesFromURL(completionHandler : @escaping (Result <Summary, Error>)->Void ){
//
//        let url = "https://api.napster.com/v2.2/tracks/top?apikey=YTkxZTRhNzAtODdlNy00ZjMzLTg0MWItOTc0NmZmNjU4Yzk4&limit=50&offset=2"
//        let urlObj = URL(string:url)!
//
//        let task = URLSession.shared.dataTask(with: urlObj)
//        {
//            data,response,error in
//            guard error == nil else{
//                completionHandler(.failure(error!))
//                return
//            }
//            guard let httpResponse = response as? HTTPURLResponse,(200...299).contains(httpResponse.statusCode) else{
//                print("Incorrect response")
//                return
//            }
//            if let jsonData = data{
//                print(jsonData)
//                let decoder = JSONDecoder()
//                do{
//                    let result = try decoder.decode(Summary.self,from:jsonData)
////                    print(result)
//
//                    completionHandler(.success(result))
//                }
//                catch{
//                    print(error)
//                }
//            }
//        }
//        task.resume()
//    }
}



////
////  NetworkingService.swift
////  Rhythm
////
////  Created by Vrushank on 2022-08-06.
////
//
//import Foundation
//import UIKit
//
//class NetworkingService{
////    var delegate : networkingDelegateProtocol?
//    static var Shared = NetworkingService()
//
//    //get tracks details from API using completion handler
//    func getTracksFromURL(url:String,completionHandler : @escaping (Result <Summary, Error>)->Void ){
//
//
//        let urlObj = URL(string:url)!
//
//        let task = URLSession.shared.dataTask(with: urlObj)
//        {
//            data,response,error in
//            guard error == nil else{
//                completionHandler(.failure(error!))
//                return
//            }
//            guard let httpResponse = response as? HTTPURLResponse,(200...299).contains(httpResponse.statusCode) else{
//                print("Incorrect response")
//                return
//            }
//            if let jsonData = data{
//                print(jsonData)
//                let decoder = JSONDecoder()
//                do{
//                    let result = try decoder.decode(Summary.self,from:jsonData)
////                    print(result)
//
//                    completionHandler(.success(result))
//                }
//                catch{
//                    print(error)
//                }
//            }
//        }
//        task.resume()
//    }
//
//    //getImage using completion handler
//    func getImage(albumId:String, completionHandler : @escaping (Result <UIImage, Error>)->Void ){
//        let imageUrl = "https://api.napster.com/imageserver/v2/albums/\(albumId)/images/500x500.jpg"
//        let urlObj = URL(string: imageUrl)!
//
//        let task = URLSession.shared.dataTask(with: urlObj)
//        { data, response, error in
//            guard error == nil else {
//                completionHandler(.failure(error!))
//                return
//            }
//            guard let httpRespons = response as? HTTPURLResponse, (200...299).contains(httpRespons.statusCode) else {
//                print ("Incorrect response ")
//                return
//            }
//
//            if let imageData = data {
//                let image = UIImage(data:imageData)
//                completionHandler(.success(image!))
//            }
//        }
//        task.resume()
//    }
//
//    //get new releases from API using completion handler
//    func getNewReleasesFromURL(completionHandler : @escaping (Result <Summary, Error>)->Void ){
//
//        let url = "https://api.napster.com/v2.2/tracks/top?apikey=YTkxZTRhNzAtODdlNy00ZjMzLTg0MWItOTc0NmZmNjU4Yzk4&limit=50&offset=2"
//        let urlObj = URL(string:url)!
//
//        let task = URLSession.shared.dataTask(with: urlObj)
//        {
//            data,response,error in
//            guard error == nil else{
//                completionHandler(.failure(error!))
//                return
//            }
//            guard let httpResponse = response as? HTTPURLResponse,(200...299).contains(httpResponse.statusCode) else{
//                print("Incorrect response")
//                return
//            }
//            if let jsonData = data{
//                print(jsonData)
//                let decoder = JSONDecoder()
//                do{
//                    let result = try decoder.decode(Summary.self,from:jsonData)
////                    print(result)
//
//                    completionHandler(.success(result))
//                }
//                catch{
//                    print(error)
//                }
//            }
//        }
//        task.resume()
//    }
//}
