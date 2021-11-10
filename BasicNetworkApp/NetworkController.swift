//
//  NetworkController.swift
//  BasicNetworkApp
//
//  Created by Thor on 10/11/2021.
//

import Foundation

enum HTTP{
    
    enum Method: String{
        case get = "GET"
        case post = "POST"
        case put = "PUT"
        case delete = "DELETE"
    }
    
    enum Header{
        enum Field: String{
            case contentType = "Content-Type"
        }
        
        enum Value: String{
            case json = "application/json"
        }
    }
}

extension URLRequest{
    mutating func addValues(for endpoint: NetworkController.Endpoint){
        switch endpoint{
        case .foo:
            setValue(HTTP.Header.Value.json.rawValue, forHTTPHeaderField: HTTP.Header.Field.contentType.rawValue)
        }
    }
}

struct NetworkController {
    
    private static let baseUrl = "postman-echo.com"
    
    enum Endpoint{
        case foo(path: String = "/post")
        
        var request : URLRequest?{
            guard let url = url else {return nil }
            
            var request = URLRequest(url: url)
            request.httpMethod = httpMethod //HTTP.Method.post.rawValue
            request.httpBody = httpBody
            request.addValues(for: self)
            return request
        }
        
        
        private var url: URL? {
            var components = URLComponents()
            components.scheme = "https"
            components.host = baseUrl
            components.path = path
            return components.url
        }
        
        private var path: String{
            switch self{
            case .foo(path: let path):
                return path
            }
        }
        
        private var httpMethod: String{
            switch self {
            case .foo:
                return HTTP.Method.post.rawValue
            }
        }
        
        
        private var httpBody : Data?{
            return try? JSONSerialization.data(withJSONObject: body, options: [])
        }
        
        private var body: [String: Any]{
            switch self{
            case .foo:
                return [
                    "foo1": "bar1",
                    "foo2":"bar1"
                ]
            }
        }
    }
    
    
    static func foo(){
        guard let request = Endpoint.foo().request else { return }
        
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("An error occured: \(error) ")
                return
            }
            
            if let data = data {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]{
                        print("JSON: \(json)")
                    }
                } catch let error {
                    print("Whoops! We couldn't parse that data into JSON: \(error) ")
                }
            }
            
        }.resume()
 
    }
    
    
    //    static func foo(){
    //
    //        guard let url = URL(string: "https://postman-echo.com/post") else {return }
    //        var request = URLRequest(url:url)
    //
    //        request.httpMethod = "POST"
    //        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    //
    //        let body: [String: Any] = [
    //            "foo1": "bar1",
    //            "foo2":"bar1"
    //        ]
    //
    //        do {
    //            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
    //        } catch let error {
    //            print("JSON body: \(error)")
    //        }
    //
    //        URLSession.shared.dataTask(with: request) { (data, response, error) in
    //            if let error = error {
    //                print("An error occured: \(error) ")
    //                return
    //            }
    //
    //            if let data = data {
    //                do {
    //                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]{
    //                        print("JSON: \(json)")
    //                    }
    //                } catch let error {
    //                    print("Whoops! We couldn't parse that data into JSON: \(error) ")
    //                }
    //            }
    //
    //        }.resume()
    //
    //    }
}
