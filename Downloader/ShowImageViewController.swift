//
//  ShowImageViewController.swift
//  Downloader
//
//  Created by Kushagra Gupta on 08/08/16.
//  Copyright © 2016 Kushagra Gupta. All rights reserved.
//

import UIKit

class ShowImageViewController: UIViewController{
    
    
    @IBOutlet weak var displayImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let data = NSData(contentsOfURL: fileURL!)
        displayImage.image = UIImage(data: data!)
        
        
    }
}
