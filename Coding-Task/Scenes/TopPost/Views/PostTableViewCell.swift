//
//  PostTableViewCell.swift
//  Coding-Task
//
//  Created by Jonathan on 2/26/18.
//  Copyright © 2018 Jonathan. All rights reserved.
//

import UIKit

class PostTableViewCell: UITableViewCell {
    @IBOutlet var thumbNail: UIImageView!
    @IBOutlet var author: UILabel!
    @IBOutlet var title: UILabel!
    @IBOutlet var comments: UILabel!
    @IBOutlet var timeCreated: UILabel!
    var preview: String!
    var parentController: UIViewController!
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

    @objc func showImage(_: UITapGestureRecognizer) {
        guard preview != nil else {
            let alert = UIAlertController(title: "No Image Available", message: "There is no high resolution image for this thumbnail", preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))

            parentController.present(alert, animated: true)
            return
        }
        let decodedString = preview.stringByDecodingHTMLEntities
        print(decodedString)
        let controller = parentController.storyboard?.instantiateViewController(withIdentifier: "preview") as! ImageViewController
        let url = URL(string: decodedString)
        controller.url = url
        parentController.navigationController?.pushViewController(controller, animated: true)
    }
}
