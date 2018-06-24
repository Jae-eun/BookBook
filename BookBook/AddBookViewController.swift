//
//  AddBookViewController.swift
//  BookBook
//
//  Created by SWUCOMPUTER on 2018. 6. 3..
//  Copyright © 2018년 SWUCOMPUTER. All rights reserved.
//

import UIKit

class AddBookViewController: UIViewController, UITextFieldDelegate,
UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    

    @IBOutlet var bookImage: UIImageView!
    @IBOutlet var buttonCamera: UIButton!
    @IBOutlet var bookName: UITextField!
    @IBOutlet var pickerCate: UIPickerView!
    @IBOutlet var writerName: UITextField!
    @IBOutlet var importance: UITextField!
    @IBOutlet var bookPages: UITextField!
    
    
    // 카메라로 사진을 찍음
    @IBAction func takePicture(_ sender: UIButton) {
        let myPicker = UIImagePickerController()
        myPicker.delegate = self
        myPicker.allowsEditing = true
        myPicker.sourceType = .camera
        self.present(myPicker, animated: true, completion: nil)
    }
    
    // 앨범에서 사진을 고름
    @IBAction func selectPicture(_ sender: UIButton) {
        let myPicker = UIImagePickerController()
        myPicker.delegate = self;
        myPicker.sourceType = .photoLibrary
        self.present(myPicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.bookImage.image = image
           
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    // 카테고리 선택 - 피커뷰 부분
    let categoryArray: Array<String> = ["소설", "시", "에세이", "인문", "역사", "문화", "자기계발", "경제/경영",
                                        "예술", "여행", "정치" ,"사회", "과학", "IT", "기타"]
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categoryArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categoryArray[row]
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        if !(UIImagePickerController.isSourceTypeAvailable(.camera)) {
            let alert = UIAlertController(title: "Error!!", message: "Device has no Camera!", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
            buttonCamera.isEnabled = false
        }
        
      
    }
    
    @IBAction func saveBook(_ sender: UIBarButtonItem) {
        
        let name = bookName.text!
        let category: String = categoryArray[self.pickerCate.selectedRow(inComponent: 0)]
        
        if (name == "") {
            let alert = UIAlertController(title: "책 제목을 입력하세요", message: "Save Failed!!", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                alert.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true)
            return
        }
        
        guard let myImage = bookImage.image else {
            let alert = UIAlertController(title: "이미지를 넣어주세요", message: "Save Failed!!", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                alert.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true)
            return
        }
        
        // 이미지 추가
        let myUrl = URL(string: "http://condi.swu.ac.kr/student/T10iphone/booklist/upload.php");
        var request = URLRequest(url:myUrl!);
        request.httpMethod = "POST";
        let boundary = "Boundary-\(NSUUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)",forHTTPHeaderField: "Content-Type")
        guard let imageData = UIImageJPEGRepresentation(myImage, 1) else { return }
        
        var body = Data()
        var dataString = "--\(boundary)\r\n"
        dataString += "Content-Disposition: form-data; name=\"userfile\";filename=\".jpg\"\r\n"
        dataString += "Content-Type: application/octet-stream\r\n\r\n"
        
        if let data = dataString.data(using: .utf8) {
            body.append(data)
        }
        
        body.append(imageData)
        
        dataString = "\r\n"
        dataString += "--\(boundary)--\r\n"
        if let data = dataString.data(using: .utf8) {
            body.append(data)
        }
        request.httpBody = body
        
        // 이미지 전송
        var imageFileName: String = ""
        let semaphore = DispatchSemaphore(value: 0)
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (responseData, response, responseError) in
            guard responseError == nil else { print("Error: calling POST"); return; }
            guard let receivedData = responseData else { print("Error: not receiving Data"); return; }
            if let utf8Data = String(data: receivedData, encoding: .utf8) {
                imageFileName = utf8Data
                print(imageFileName)
                semaphore.signal()
            }
        }
        task.resume()
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
        
        
        // table insert
        let urlString: String = "http://condi.swu.ac.kr/student/T10iphone/booklist/insertBook.php"
        guard let requestURL = URL(string: urlString) else { return }
        request = URLRequest(url: requestURL)
        request.httpMethod = "POST"
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        guard let userID = appDelegate.ID  else { return }
        
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let myDate = formatter.string(from: Date())
        
        var restString: String = "userid=" + userID + "&image=" + imageFileName + "&name=" + name
        restString += "&category=" + category
        restString += "&writer=" + writerName.text!  + "&importance=" + importance.text!
        restString += "&pages=" + bookPages.text! + "&date=" + myDate
        
        print(restString)
        
        request.httpBody = restString.data(using: .utf8)
 
        let session2 = URLSession.shared
        let task2 = session2.dataTask(with: request) { (responseData, response, responseError) in
            guard responseError == nil else { return }
            guard let receivedData = responseData else { return }
            if let utf8Data = String(data: receivedData, encoding: .utf8) {
                print(utf8Data)
            }
        }
        task2.resume()
         _ = self.navigationController?.popViewController(animated: true)
        
  
    }
}
