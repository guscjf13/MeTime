//
//  NetworkManager.swift
//  MeTime
//
//  Created by hyunchul on 2024/01/01.
//

import Foundation
import Alamofire

final class NetworkManager {
    
    static let shared = NetworkManager()
    
    private let host = "http://34.64.232.33"
    
    enum EndPoint {
        case beverageList
        case beverageDetail(id: Int)
        
        var urlSuffix: String {
            switch self {
            case .beverageList:
                return "/alcohol"
            case.beverageDetail(let id):
                return "/alcohol/\(id)"
            }
        }
    }
    
    func requestBeverages(pagingCondition: PagingCondition, completion: (([Beverage], Bool) -> ())? = nil) {
        let urlString = host + EndPoint.beverageList.urlSuffix
        guard let url = URL(string: urlString) else { return }
        
        AF.request(
            url,
            method: .get,
            parameters: pagingCondition.convertToParameter(),
            encoding: URLEncoding.default
        )
        .responseDecodable(of: [Beverage].self) { response in
            switch response.result {
            case .success(let result):
                let hasNext = result.count == pagingCondition.displayPerPage
                completion?(result, hasNext)
            case .failure(let error):
                print("requestBeverages error \(error.localizedDescription)")
            }
        }
    }
    
    func requestBeverageDetail(beverageID: Int, completion: ((Beverage) -> ())? = nil) {
        let urlString = host + EndPoint.beverageDetail(id: beverageID).urlSuffix
        guard let url = URL(string: urlString) else { return }
        
        AF.request(
            url,
            method: .get,
            parameters: nil,
            encoding: URLEncoding.default
        )
        .responseDecodable(of: Beverage.self) { response in
            switch response.result {
            case .success(let result):
                completion?(result)
            case .failure(let error):
                print("requestBeverageDetail error \(error.localizedDescription)")
            }
        }
    }
}
