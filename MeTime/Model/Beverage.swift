//
//  Beverage.swift
//  MeTime
//
//  Created by hyunchul on 2024/02/09.
//

import Foundation

class Beverage: Decodable {
    var id: Int?
    var name: String?
    var engName: String?
    var price: Int?
    var category: BeverageType?
    var capacity: Int?
    var starCount: Int?
    var thumbnailImageUrl: String?
    var detailImageUrl: String?
    var distributors: [String]?
    var keywords: [String]?
    var comments: [String]?
    var reactionCount: ReactionCount?
    var wineFlavor: WineFlavor?
    
    enum CodingKeys: String,CodingKey {
        case id
        case name
        case engName
        case price
        case category
        case capacity
        case starCount
        case thumbnailImageUrl
        case detailImageUrl
        case distributors
        case keywords
        case comments
        case reactionCount
        case wineFlavor
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try? container.decode(Int.self, forKey: .id)
        name = try? container.decode(String.self, forKey: .name)
        engName = try? container.decode(String.self, forKey: .engName)
        price = try? container.decode(Int.self, forKey: .price)
        category = try? container.decode(BeverageType.self, forKey: .category)
        starCount = try? container.decode(Int.self, forKey: .starCount)
        thumbnailImageUrl = try? container.decode(String.self, forKey: .thumbnailImageUrl)
        detailImageUrl = try? container.decode(String.self, forKey: .detailImageUrl)
        distributors = try? container.decode([String].self, forKey: .distributors)
        keywords = try? container.decode([String].self, forKey: .keywords)
        reactionCount = try? container.decode(ReactionCount.self, forKey: .reactionCount)
    }
}

struct WineFlavor: Decodable {
    var sugarContent: Int?
    var acidity: Int?
    var body: Int?
}

struct ReactionCount: Decodable {
    var likeCount: Int?
    var commentCount: Int?
}

enum BeverageType: Decodable {
    case beer(type: BeerType)
    case wine(type: WineType)
    case whiskey
    case etc(type: EtcType)
    
    enum BeerType: String, Decodable {
        case lager
        case wheet
        case ale
        case dark
    }

    enum WineType: String, Decodable {
        case red
        case white
        case sparkling
        case rose
    }

    enum EtcType: String, Decodable {
        case liquer
        case vodka
        case etc
    }
    
    var name: String? {
        switch self {
        case .beer(let type):
            switch type {
            case .lager:        return "라거"
            case .wheet:        return "밀맥주"
            case .ale:          return "에일"
            case .dark:         return "흑맥주"
            }
        case .wine(let type):
            switch type {
            case .red:          return "레드"
            case .white:        return "화이트"
            case .sparkling:    return "스파클링"
            case .rose:         return "로제"
            }
        case .whiskey:          return "위싀키"
        case .etc(let type):
            switch type {
            case .liquer:       return "리큐르"
            case .vodka:        return "보드카"
            case .etc:          return "기타"
            }
        }
    }
    
    static func getTypeFromString(type: String?) -> Self {
        guard let type else { return .etc(type: .etc) }
        switch type {
        case "라거":      return .beer(type: .lager)
        case "밀맥주":     return .beer(type: .wheet)
        case "에일":      return .beer(type: .ale)
        case "흑맥주":     return .beer(type: .dark)
            
        case "레드":      return .wine(type: .red)
        case "화이트":     return .wine(type: .white)
        case "스파클링":    return .wine(type: .sparkling)
        case "로제":      return .wine(type: .rose)
            
        case "위스키":     return .whiskey
            
        case "리큐르":     return .etc(type: .liquer)
        case "보드카":     return .etc(type: .vodka)
            
        default:        return .etc(type: .etc)
        }
    }
}
