//
//  ImageDataModel.swift
//  FlowerVision
//
//  Created by Sekaye Knutson on 10/5/22.
//

import Foundation

struct ImageDataModel: Decodable { // entire structure
   struct ImageQuery: Decodable { // query dictionary
      let pages : [String:ImageResults] // String is the changing pageid
   }
   let query : ImageQuery //reference to structure
}

struct ImageResults:Decodable { //This is the data you are interested in
   struct Original: Decodable {
      let source: String
   }
   let original: Original
}
