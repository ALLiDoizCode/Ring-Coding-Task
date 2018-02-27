//
//  PostTableViewCell.swift
//  Coding-Task
//
//  Created by Jonathan on 2/26/18.
//  Copyright © 2018 Jonathan. All rights reserved.
//

import UIKit

class PostTableViewCell: UITableViewCell {
    @IBOutlet weak var thumbNail: UIImageView!
    @IBOutlet weak var author: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var comments: UILabel!
    @IBOutlet weak var timeCreated: UILabel!
    var preview:String!
    var parentController:UIViewController!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showImage(_:)))
        tapGesture.numberOfTapsRequired = 1
        tapGesture.numberOfTouchesRequired = 1
        thumbNail.addGestureRecognizer(tapGesture)
        thumbNail.isUserInteractionEnabled = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @objc func showImage(_ sender: UITapGestureRecognizer) {
        guard preview != nil else {
            let alert = UIAlertController(title: "No Image Available", message: "There is no high resolution image for this thumbnail", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
            parentController.present(alert, animated: true)
            return
        }
        var decodedString = preview.stringByDecodingHTMLEntities
        print(decodedString)
        let controller = parentController.storyboard?.instantiateViewController(withIdentifier: "preview") as! ImageViewController
        let url = URL(string: decodedString)
        controller.url = url
        parentController.navigationController?.pushViewController(controller, animated: true)
    }
}
