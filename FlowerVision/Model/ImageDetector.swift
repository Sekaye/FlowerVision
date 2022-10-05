//
//  ImageDetector.swift
//  FlowerVision
//
//  Created by Sekaye Knutson on 10/3/22.
//

import Foundation
import UIKit
import Vision
import CoreML

struct ImageDetector {
    
    
    
    internal mutating func detect(_ img: CIImage) -> String? {
        
        var classification: String?
        //model configuration
        let config = MLModelConfiguration()
        guard let model = try? VNCoreMLModel(for: FlowerClassifier(configuration: config).model)
        else {fatalError("Error configuring model")}
        
        //request
        let mlRequest = VNCoreMLRequest(model: model) { request, error in
            guard let results = request.results
            else { fatalError("Failure to process results from request")}
            if let firstResult = results.first as? VNClassificationObservation
            {
                if firstResult.confidence > 0.5 {
                    classification = firstResult.identifier
                } else {
                    classification = "unknown flower"
                }
            }
        }
        
        //handler
        let handler = VNImageRequestHandler(ciImage: img)
        
        do{
            try handler.perform([mlRequest])
        } catch {
            print("error performing request")
        }
        
        return classification?.capitalized ?? "error"
        
    }
    

}
