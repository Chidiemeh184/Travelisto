//
//  HotelNetworkProcessor.swift
//  Travelisto
//
//  Created by Chidi Emeh on 9/27/17.
//  Copyright © 2017 Chidi Emeh. All rights reserved.
//

import Foundation



class HotelNetworkProcessor {
    
    //Properties
    let url : URL
    lazy var configuration : URLSessionConfiguration = URLSessionConfiguration.default
    lazy var session : URLSession = URLSession(configuration: configuration)
    
    init(url: URL) {
        self.url = url
    }
    
    typealias JSONObject = ( (Codable?, CustomError?) -> Void  )
    
    //MARK: METHOD
    
    func downloadJSONFromURL(withStructType: String, _ completion : @escaping JSONObject ){
        let request = URLRequest(url: url)
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            if error == nil {
                if let httpResponse = response as? HTTPURLResponse {
                    switch httpResponse.statusCode {
                    case 200:
                        print("Success")
                        if let successResponseData = data {
                            do{
                                var downloadedObject : Codable?
                                    switch withStructType {
                                        case HotelAPISearchBy.hotelAirportSearch.rawValue:
                                                downloadedObject = try JSONDecoder().decode(HotelAirports.self, from: successResponseData)
                                        case HotelAPISearchBy.hotelGeosearchByBox.rawValue:
                                            downloadedObject = try JSONDecoder().decode(HotelAirports.self, from: successResponseData)
                                        case HotelAPISearchBy.hotelGeosearchByCircle.rawValue:
                                            downloadedObject = try JSONDecoder().decode(HotelAirports.self, from: successResponseData)
                                        default:
                                            print("No conformable case was found!")
                                    }
                                completion(downloadedObject, nil)
                            }catch let error as NSError {
                                print("Error decoding: \(error)")
                            }
                        }
                    default:
                        //eg Status 400 : Bad Request
                        //Sends the message to the user so they can correct search term
                        //or parameter requirements
                        //The Response from the status code is converted to Error
                        //object so that the message can be retrieved and sent to
                        //the user
                        print("Response Status code: \(httpResponse.statusCode)")
                        //Switch on status
                        
                        //If status is 400 get the data and use it to create
                        //Error object (from errorResponseDate)
                        
                        //Get message from Error object and pass to user
                        //so downloaded data will be nill and Error data will not be nil
                        
                        //eg Status 400 :
                        print("Response Status code: \(httpResponse.statusCode)")
                        if let errorData = data {
                            do {
                                let downloadedError = try JSONDecoder().decode(CustomError.self, from: errorData)
                                completion(nil, downloadedError)
                            } catch let error as NSError {
                                print("Error downloading error message: \(error)")
                            }
                        }

                        
                    }
                }
            }else {
                print(error?.localizedDescription ?? "Error downloading task")
            }
        }
        dataTask.resume()
        
    }//End Func downloadJSONFromURL(...)
    
    
}//End Class HotelNetworkProcessor
