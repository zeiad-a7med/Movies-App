//
//  AddViewController.swift
//  Movies
//
//  Created by Zeiad on 11/01/2025.
//

import UIKit

class AddViewController: UIViewController, UIImagePickerControllerDelegate
        & UINavigationControllerDelegate
{

    var firstVc: AddMovieProtocol?
    @IBOutlet weak var pickedImage: UIImageView!
    @IBOutlet weak var movieTitle: UITextField!
    @IBOutlet weak var movieRating: UITextField!
    @IBOutlet weak var movieReleaseYear: UITextField!
    @IBOutlet weak var movieGenre: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func saveAndBack(_ sender: Any) {

        if movieTitle.text != "" && movieRating.text != ""
            && movieReleaseYear.text != "" && movieGenre.text != ""
        {
            var imgPath: String?
            if pickedImage.image != nil {
                imgPath = saveImageToDocumentsDirectory(
                    image: pickedImage.image!,
                    fileName: (movieTitle.text! + ".png"))
            }
            var movie = Movie(
                id: nil, title: movieTitle.text!, image: imgPath,
                rating: Double(movieRating.text!),
                releaseYear: Int(movieReleaseYear.text!)!,
                genre: [movieGenre.text!])
            firstVc?.addMovie(movie: movie)
            self.navigationController?.popViewController(animated: true)
        }
    }
    @IBAction func uploadImag(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            imagePicker.sourceType = .photoLibrary
            present(imagePicker, animated: true, completion: nil)
        } else {
            print("No library available")
        }

    }
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey:
            Any]
    ) {
        let img = info[UIImagePickerController.InfoKey.originalImage]
        pickedImage.image = img as? UIImage
        self.dismiss(animated: true, completion: nil)
    }

    func saveImageToDocumentsDirectory(image: UIImage, fileName: String)
        -> String?
    {
        // Convert the UIImage to PNG or JPEG data
        guard let data = image.pngData() else {
            print("Failed to convert image to PNG data")
            return nil
        }

        // Get the Documents directory path
        let fileManager = FileManager.default
        let documentsDirectory = try? fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)

        // Create the full file path
        let fileURL = documentsDirectory?.appendingPathComponent(fileName)

        do {
            // Write the image data to the file
            try data.write(to: fileURL!)
            print("Image saved successfully at: \(fileURL!.path)")
            return fileURL!.path
        } catch {
            print("Error saving image: \(error.localizedDescription)")
            return nil
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
