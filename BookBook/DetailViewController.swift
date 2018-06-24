//
//  DetailViewController.swift
//  BookBook
//
//  Created by SWUCOMPUTER on 2018. 6. 3..
//  Copyright © 2018년 SWUCOMPUTER. All rights reserved.
//

import UIKit
import CoreData

class DetailViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var bookImage: UIImageView!
    @IBOutlet var bookName: UILabel!
    @IBOutlet var category: UILabel!
    @IBOutlet var writerName: UILabel!
    @IBOutlet var importance: UILabel!
    @IBOutlet var bookPages: UILabel!
    @IBOutlet var savedDate: UILabel!
    @IBOutlet var readFinish: UIButton!
    
    var detailBook: NSManagedObject?
    var selectedData: BookData?
    
    override func viewDidLoad() {
        // Do any additional setup after loading the view.
        guard let bookData = selectedData else { return }
        bookName.text = bookData.name
        category.text = bookData.category
        writerName.text = bookData.writer
        importance.text = bookData.importance
        bookPages.text = bookData.pages
        savedDate.text = bookData.date
        
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
    
    
    func getContext () -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool { textField.resignFirstResponder()
        return true
        
    }
    
    var Finish = "읽기 완료!"
    /*
    @IBAction func finish() {
        let context = getContext()
        let entity = NSEntityDescription.entity(forEntityName: "myBooks", in: context)
        
        // friend record를 새로 생성함
        let object = NSManagedObject(entity: entity!, insertInto: context)
        object.setValue(bookName.text, forKey: "bookName")
        object.setValue(Finish, forKey: "finishRead")
        object.setValue(Date(), forKey: "readDate")
        do {
            try context.save()
            print("saved!")
        } catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)") }
        // 현재의 View를 없애고 이전 화면으로 복귀
        self.navigationController?.popViewController(animated: true)
        
    }*/
    
    override func prepare (for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "toEditDetail" {
            if let destination = segue.destination as? EditBookViewController
            {
                destination.selectedEditData = selectedData
                destination.title = "책 상세정보 수정"
            }
            
        }
    }

    @IBAction func deleteBtn(_ sender: Any) {
        let alert = UIAlertController(title: "정말 삭제 하시겠습니까?", message: "", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Delete", style: .cancel, handler: { action in
            let urlString: String = "http://condi.swu.ac.kr/student/T10iphone/booklist/deleteBook.php"
            guard let requestURL = URL(string: urlString) else { return }
            var request = URLRequest(url: requestURL)
            request.httpMethod = "POST"
            guard let bookNO = self.selectedData?.bookno else { return }
            let restString: String = "bookno=" + bookNO
            request.httpBody = restString.data(using: .utf8)
            let session = URLSession.shared
            let task = session.dataTask(with: request) { (responseData, response, responseError) in
                guard responseError == nil else { return }
                guard let receivedData = responseData else { return }
                if let utf8Data = String(data: receivedData, encoding: .utf8) {
                    print(utf8Data)  // php에서 출력한 echo data가 debug 창에 표시됨
                }
            }
            task.resume()
            self.navigationController?.popViewController(animated: true)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        
        self.present(alert, animated: true)
    }
    
}
