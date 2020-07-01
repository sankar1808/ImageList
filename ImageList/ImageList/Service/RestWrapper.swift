//
//  RestWrapper.swift
//  ImageList
//
//  Created by Sankaranarayana Settyvari on 30/06/20.
//  Copyright © 2020 Sankaranarayana Settyvari. All rights reserved.
//


import Foundation
import UIKit

protocol RestWrapperDelegate {
    
    // Classes that adopt this protocol
    
    func didReceivePhotosData(arrayList:NSMutableArray, titleString:String)
    
}

class RestWrapper {
    
    var delegate: RestWrapperDelegate?
    var appDelegate :AppDelegate!
    
    init() {
        
    }
    
    
    func getPhotosData()
    {
        let array:NSMutableArray = NSMutableArray.init()

        guard let urlString = URL (string: "https://dl.dropboxusercontent.com/s/2iodh4vg0eortkl/facts.json")
            else
        {
            return
        }
        let session = URLSession.shared
        let task = session.dataTask(with: urlString, completionHandler: { data, response, error in
            
            guard error == nil else {
                return
            }
            guard data != nil else {
                return
            }
            
            let str = String(decoding: data!, as: UTF8.self)
            
            let dict = self.convertToDictionary(text: str)
            let getValue = dict!["title"] as? NSString
            let getValues = dict!["rows"]  as? Array<Dictionary<String, Any>>
            
            
            for photoObj:Dictionary<String, Any> in getValues! {
                let title = photoObj["title"]
                let descriptionValue = photoObj["description"]
                let imageURL = photoObj["imageHref"]
                
                let photo:Photo = Photo()
                photo.title = title as? NSString
                photo.imageURL = imageURL as? NSString
                photo.titleDescription = descriptionValue as? NSString
                array.add(photo)
                
            }
            DispatchQueue.main.async() {
                self.delegate?.didReceivePhotosData(arrayList: array, titleString: getValue! as String)
            }
        })
        task.resume()
    }
    
    
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
}
