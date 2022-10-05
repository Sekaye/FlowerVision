//
//  WikiDataModel.swift
//  FlowerVision
//
//  Created by Sekaye Knutson on 10/5/22.
//

import Foundation


struct ExtractDataModel: Codable { // entire structure
   struct Query: Codable { // query dictionary
      let pages : [String:Results] // String is the changing pageid
   }
   let query : Query //reference to structure
}

struct Results:Codable { //This is the data you are interested in
   let pageid: Int
   let extract: String
   let title: String
}


