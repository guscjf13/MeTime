//
//  PagingCondition.swift
//  MeTime
//
//  Created by hyunchul on 2024/02/16.
//

import Foundation

struct PagingCondition: Codable {
    var cursorNo: Int
    var displayPerPage: Int
    var sort: String
    var minPrice: Int
    var maxPrice: Int
    var cursorDefaultValue: Bool
    
    func convertToParameter() -> [String : Any]? {
        do {
            let jsonData = try JSONEncoder().encode(self)
            let jsonString = String(data: jsonData, encoding: .utf8)
            return jsonString?.convertToDictionary()
        }
        catch let error {
           print("error: \(error.localizedDescription)")
        }
        
        return nil
    }
}
