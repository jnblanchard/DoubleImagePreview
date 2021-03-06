//
//  ViewController.swift
//  DoubleImagePreview
//
//  Created by John N Blanchard on 10/4/16.
//  Copyright © 2016 John N Blanchard. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var doubleImagePreView: DoubleImagePreView!

    override func viewDidLoad() {
        super.viewDidLoad()
        doubleImagePreView.set(originalImage: UIImage(named: "unedited")!, retouchedImage: UIImage(named: "edited")!)
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

