//
//  ViewController.swift
//  FlowerVision
//
//  Created by Sekaye Knutson on 10/3/22.
//

import UIKit
import Vision
import CoreML

class ViewController: UIViewController {
   
   //outlets
   @IBOutlet weak var userImage: UIImageView!
   @IBOutlet weak var flowerDescription: UILabel!
   @IBOutlet weak var wikiImage: UIImageView!
   @IBOutlet weak var centerCameraIcon: UIImageView!
   @IBOutlet weak var flowerTitle: UILabel!
   @IBOutlet weak var introTitle: UILabel!
   @IBOutlet weak var centerCameraButton: UIButton!
   
   //properties
   private let imagePicker = UIImagePickerController()
   private var imageDetector = ImageDetector()
   private var wikiFetcher = WikiFetcher()
   
   // MARK: - View Scenes
   override func viewDidLoad() {
      super.viewDidLoad()
      imagePicker.delegate = self
      imagePicker.sourceType = .camera
      imagePicker.allowsEditing = false
      wikiFetcher.delegate = self
   }
   
   // MARK: - Actions
   @IBAction func cameraButtonPressed(_ sender: UIBarButtonItem) {
      present(imagePicker, animated: true, completion: nil)
   }
   
   @IBAction func centerCameraPressed(_ sender: UIButton) {
      present(imagePicker, animated: true, completion: nil)
   }
   
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
   func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
      centerCameraIcon.isHidden = true
      centerCameraButton.isHidden = true
      introTitle.isHidden = true
      if let chosenImage = info[UIImagePickerController.InfoKey.originalImage]
            as? UIImage {
         userImage.image = chosenImage
         guard let convertedImage = CIImage(image: chosenImage)
         else { fatalError("failure converting chosen image to Core Image type image") }
         
         guard let flowerName = imageDetector.detect(convertedImage)
         else {fatalError("unable to process image and return a flower name")}
         flowerTitle.text = flowerName
         wikiFetcher.fetchExtract(with: flowerName)
         wikiFetcher.fetchImage(with: flowerName)
         
      }
      imagePicker.dismiss(animated: true)
   }
}

// MARK: - Update UI after Fetch
extension ViewController: WikiFetcherDelegate {
   func didFinishFetchingExtract(title: String, description: String) {
      DispatchQueue.main.async {
         self.flowerTitle.text = title
         self.flowerDescription.text = description
      }
   }
   func didFinishFetchingImage(image: UIImage) {
      DispatchQueue.main.async {
         self.wikiImage.image = image
      }
      
   }
}
