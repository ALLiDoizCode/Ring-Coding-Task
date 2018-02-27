//
//  ImageViewController.swift
//  Coding-Task
//
//  Created by Jonathan on 2/27/18.
//  Copyright © 2018 Jonathan. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    var url:URL!
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let imageURl = url else {
            return
        }
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: imageURl)
            DispatchQueue.main.async {
                if let imageData = data {
                    self.imageView.image = UIImage(data: imageData)
                }
                
            }
        }
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
