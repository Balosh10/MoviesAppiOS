//
//  ConvertNSManagedObjectToData.swift
//  MovieApp
//
//  Created by osvaldo cespedes on 31/01/22.
//

import Foundation
import CoreData

struct ConvertNSManagedObjectToData {
    
    static func convertToData(moArray: [NSManagedObject]) -> Data{
        var jsonArray: [[String: Any]] = []
        for item in moArray {
            var dict: [String: Any] = [:]
            for attribute in item.entity.attributesByName {
                //check if value is present, then add key to dictionary so as to avoid the nil value crash
                if let value = item.value(forKey: attribute.key) {
                    dict[attribute.key] = value
                }
            }
            jsonArray.append(dict)
        }
        let jsonData = try! JSONSerialization.data(withJSONObject: jsonArray, options: .prettyPrinted)
        return jsonData
    }
    
}
