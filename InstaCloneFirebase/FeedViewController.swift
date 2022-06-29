//
//  FeedViewController.swift
//  InstaCloneFirebase
//
//  Created by busraguler on 15.06.2022.
//

import UIKit
import Firebase
import SDWebImage

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var likesArray = [Int]()
    var userEmailArray = [String]()
    var commentArray = [String]()
    var ımageArray = [String]()
    var documentIdArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        getDataFirestore()

        
    }
    func getDataFirestore(){
        let FirestoreDatabase = Firestore.firestore()
        //posts collection'daki documentlere snapshot ile erişilir.
        //tarihe göre azalan şekilde sıralar
        FirestoreDatabase.collection("Posts").order(by: "date", descending: true).addSnapshotListener { (snapshot, error) in
            if error != nil {
                print(error?.localizedDescription)
            }else{
                // document : collection içindeki documnetlerdir.
                if snapshot?.isEmpty != true && snapshot != nil{
                    self.userEmailArray.removeAll(keepingCapacity: false)
                    self.commentArray.removeAll(keepingCapacity: false)
                    self.ımageArray.removeAll(keepingCapacity: false)
                    self.likesArray.removeAll(keepingCapacity: false)
                    self.documentIdArray.removeAll(keepingCapacity: false)
                    
                    for document in snapshot!.documents {
                        let documentId = document.documentID
                        self.documentIdArray.append(documentId)
                        
                        if let postedBy = document.get("postedBy") as? String {
                            self.userEmailArray.append(postedBy)
                        }
                        if let likes = document.get("likes") as? Int {
                            self.likesArray.append(likes)
                        }
                        if let postComment = document.get("postComment") as? String {
                            self.commentArray.append(postComment)
                        }
                        if let imageUrl = document.get("imageUrl") as? String {
                            self.ımageArray.append(imageUrl)
                        }
                            
                    }
                    
                    self.tableView.reloadData() //Tablevieew verileri güncelle
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userEmailArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FeedCell
        cell.likeCountLabel.text = String(likesArray[indexPath.row])
        cell.userEmailLabel.text = userEmailArray[indexPath.row]
        //cell.userImageView.image = UIImage(named: "mona lisa.jpeg")
        cell.userImageView.sd_setImage(with: URL(string: self.ımageArray[indexPath.row]))
        cell.commentLabel.text = commentArray[indexPath.row]
        cell.documentIdLabel.text = documentIdArray[indexPath.row]
        return cell
        
    }
    


}
