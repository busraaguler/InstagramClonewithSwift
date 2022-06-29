//
//  FeedCell.swift
//  InstaCloneFirebase
//
//  Created by busraguler on 16.06.2022.
//

import UIKit
import Firebase

class FeedCell: UITableViewCell {

    @IBOutlet weak var userEmailLabel: UILabel!
    
    @IBOutlet weak var documentIdLabel: UILabel!
    @IBOutlet weak var likeCountLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func likeButtonClicked(_ sender: Any) {
        
        let FirestoreDatabase = Firestore.firestore()
        if let likeCount = Int(likeCountLabel.text!){
            
            let likeStore = ["likes": likeCount + 1] as [String : Any]
            FirestoreDatabase.collection("Posts").document(documentIdLabel.text!).setData(likeStore, merge: true)
            //setdata sadece like ' güncelle diğerlerinde bi değişiklik yapma demek
            
        }
        
        
        
    }
}
