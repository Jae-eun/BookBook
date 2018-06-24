//
//  RecommendViewController.swift
//  BookBook
//
//  Created by SWUCOMPUTER on 2018. 6. 3..
//  Copyright © 2018년 SWUCOMPUTER. All rights reserved.
//

import UIKit

class RecommendViewController: UIViewController {

    @IBOutlet var bookImage: UIImageView!
    @IBOutlet var bookName: UILabel!

  
    var selectedData: BookData?
    
    override func viewDidLoad() {
         super.viewDidLoad()
        // Do any additional setup after loading the view.
        guard let bookData = selectedData else { return }
        bookName.text = bookData.name

        
        var imageName = bookData.image
        if (imageName != "") {
            let urlString = "http://condi.swu.ac.kr/student/T10iphone/booklist/"
            imageName = urlString + imageName
            let url = URL(string: imageName)!
            if let imageData = try? Data(contentsOf: url) {
                bookImage.image = UIImage(data:imageData)
            }
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addBooklist(_ sender: Any) {
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
