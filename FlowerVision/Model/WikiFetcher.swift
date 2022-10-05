//
//  WikiFetcher.swift
//  FlowerVision
//
//  Created by Sekaye Knutson on 10/4/22.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON

struct WikiFetcher {
   
   var delegate: WikiFetcherDelegate?
   let extractWikiURL = "https://en.wikipedia.org/w/api.php?action=query&prop=extracts&exchars=400&redirects=resolve&explaintext=1&format=json&titles="
   let imageWikiURL = "https://en.wikipedia.org/w/api.php?action=query&prop=pageimages&exchars=400&redirects=resolve&explaintext=1&format=json&titles="
   
   func fetchExtract(with flowerName: String) {
      //extract url setup
      let urlString = extractWikiURL + flowerName
      guard let url = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
      else { fatalError("failure creating url from flower input") }
      guard let readyURL = URL(string: url)
      else { fatalError("failed to convert the url string to a URL") }
      
      //create session and task
      let session = URLSession(configuration: .default)
      let task = session.dataTask(with: readyURL) { data, response, error in
         if error != nil { print("error retrieving information from wikipedia \(error)") }
         else
         {
            guard let safeData = data
            else { fatalError("Data retrieved is nil") }
            print("DATAA")
            print(safeData)
            parseExtractData(from: safeData)
         }
      }
      //execute task
      task.resume()
   }
   func fetchImage(with flowerName: String) {
      let urlString = imageWikiURL + flowerName
      guard let url = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
      else { fatalError("failure creating url from flower input") }
      guard let readyURL = URL(string: url)
      else { fatalError("failed to convert the url string to a URL") }
      
      //create session and task
      let session = URLSession(configuration: .default)
      let task = session.dataTask(with: readyURL) { data, response, error in
         if error != nil { print("error retrieving information from wikipedia \(error)") }
         else
         {
            guard let safeData = data
            else { fatalError("Data retrieved is nil") }
            parseImageData(from: safeData)
         }
      }
      //execute task
      task.resume()
   }
   private func parseExtractData(from data: Data){
      let decoder = JSONDecoder()
      do {
         let decodedData = try decoder.decode(ExtractDataModel.self, from: data).query.pages
         if let pageKey = decodedData.first?.key { //dictionary key captured here
            let results = decodedData[pageKey]!
            delegate?.didFinishFetchingExtract(title: results.title, description: results.extract)
         }
      } catch {
         print("Error",error)
      }
   }
   private func parseImageData (from data: Data) {
      let decoder = JSONDecoder()
      do {
         let decodedData = try decoder.decode(ImageDataModel.self, from: data).query.pages
         if let pageKey = decodedData.first?.key { //dictionary key captured here
            let results = decodedData[pageKey]!
            
            //convert image url to UIImage
            let url = URL(string: results.thumbnail.source)!
            let data = try? Data(contentsOf: url)
            if let imageData = data {
               let image = UIImage(data: imageData)
               delegate?.didFinishFetchingImage(image: image!)
            }
         }
      } catch {
         print("Error",error)
      }
   }
}

protocol WikiFetcherDelegate {
   func didFinishFetchingExtract(title: String, description: String)
   func didFinishFetchingImage(image: UIImage)
}

