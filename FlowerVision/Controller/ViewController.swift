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
    @IBOutlet weak var centerImage: UIImageView!
    
    //properties
    let imagePicker = UIImagePickerController()

    // MARK: - View Scenes
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
    }
    
    // MARK: - Actions
    @IBAction func cameraButtonPressed(_ sender: UIBarButtonItem) {
        present(imagePicker, animated: true, completion: nil)
    }
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let chosenImage = info[UIImagePickerController.InfoKey.originalImage]
            as? UIImage {
            centerImage.image = chosenImage
        }
        imagePicker.dismiss(animated: true)
    }
}
