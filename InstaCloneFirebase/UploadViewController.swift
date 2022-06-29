//
//  UploadViewController.swift
//  InstaCloneFirebase
//
//  Created by busraguler on 15.06.2022.
//

import UIKit
import Firebase

class UploadViewController: UIViewController , UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var uploadButton: UIButton!
    
    override func viewDidLoad() {

        super.viewDidLoad()
        
        imageView.isUserInteractionEnabled = true //imageview'e tıklanılabilir özelliği
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(choosePicture))
        imageView.addGestureRecognizer(gestureRecognizer)

        // Do any additional setup after loading the view.
        
    }
    
    @objc func choosePicture(){
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .photoLibrary
        present(pickerController, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        imageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }
    
    func makeAlert(titleInput:String, messageInput:String){
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        present(alert, animated: true, completion: nil)
        
    }
    @IBAction func uploadButtonClicked(_ sender: Any) {
        let storage = Storage.storage()
        let storageReference = storage.reference()  //storage'a gider
        
        let mediaFolder = storageReference.child("media") //Stroga'daki media klasörüne gider.
        
        if let data = imageView.image?.jpegData(compressionQuality: 0.5) { //image'i data'ya dönüştürme
            
            let uuid = UUID().uuidString
            let imageReference = mediaFolder.child(uuid)
            imageReference.putData(data, metadata: nil) { (metadata, error) in
                
                if error != nil{ //hata varsa firebase hatasını yazdırır.
                    self.makeAlert(titleInput: "error", messageInput: error?.localizedDescription ?? "error")
                   
                }else{
                    
                    imageReference.downloadURL { (url, error) in  //kullanıcının kaydettiği resmin hangi url'ye ait olduğunu bulmka için
                        
                       if error == nil{
                            
                            let imageUrl = url?.absoluteString //Url'yi string'e çevir.
                           print(imageUrl)
                           
                           //Database
                           
                           let firestoreDatabase = Firestore.firestore()
                           
                           var firestoreReference : DocumentReference? = nil
                           
                           
                           let firestorePost = ["imageUrl" : imageUrl!, "postedBy" : Auth.auth().currentUser!.email!, "postComment" : self.commentTextField.text! , "date" : FieldValue.serverTimestamp() , "likes" : 0]
                           as [String : Any]
                           firestoreReference = firestoreDatabase.collection("Posts").addDocument(data: firestorePost, completion: { (error) in
                               
                               if error != nil {
                                   
                                   self.makeAlert(titleInput: "error", messageInput: error?.localizedDescription ?? "error")
                               }else{
                                   
                                   self.imageView.image = UIImage(named: "tapselect")
                                   self.commentTextField.text = ""
                                   self.tabBarController?.selectedIndex = 0
                               }
                                                        
                           })
                           
                           
                           
                        }
                    }
                }
            }
                
        }
        
    }

 

}
