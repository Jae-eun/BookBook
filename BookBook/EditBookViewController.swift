//
//  EditBookViewController.swift
//  BookBook
//
//  Created by SWUCOMPUTER on 2018. 6. 22..
//  Copyright © 2018년 SWUCOMPUTER. All rights reserved.
//

import UIKit

class EditBookViewController: UIViewController, UITextFieldDelegate,
UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet var imgBook: UIImageView!
    @IBOutlet var textTitle: UITextField!
    @IBOutlet var textImportance: UITextField!
    @IBOutlet var textWriter: UITextField!
    @IBOutlet var textPage: UITextField!
    @IBOutlet var pickerCate: UIPickerView!
    @IBOutlet var buttonCamera: UIButton!
   // @IBOutlet var buttonAlbum: UIButton!
    
    var selectedEditData: BookData?
    
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
            self.imgBook.image = image
            
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
        
        // Do any additional setup after loading the view.
        guard let bookData = selectedEditData else { return }
        textTitle.text = bookData.name
        textWriter.text = bookData.writer
        textImportance.text = bookData.importance
        textPage.text = bookData.pages
        
        var imageName = bookData.image
        if (imageName != "") {
            let urlString = "http://condi.swu.ac.kr/student/T10iphone/booklist/"
            imageName = urlString + imageName
            let url = URL(string: imageName)!
            if let imageData = try? Data(contentsOf: url) {
                imgBook.image = UIImage(data:imageData)
            }
        }
        
        switch bookData.category {
        case "소설":
            self.pickerCate.selectRow(0, inComponent: 0, animated: true)
        case "시":
            self.pickerCate.selectRow(1, inComponent: 0, animated: true)
        case "에세이":
            self.pickerCate.selectRow(2, inComponent: 0, animated: true)
        case "인문":
            self.pickerCate.selectRow(3, inComponent: 0, animated: true)
        case "역사":
            self.pickerCate.selectRow(4, inComponent: 0, animated: true)
        case "문화":
            self.pickerCate.selectRow(5, inComponent: 0, animated: true)
        case "자기계발":
            self.pickerCate.selectRow(6, inComponent: 0, animated: true)
        case "경제/경영":
            self.pickerCate.selectRow(7, inComponent: 0, animated: true)
        case "예술":
            self.pickerCate.selectRow(8, inComponent: 0, animated: true)
        case "여행":
            self.pickerCate.selectRow(9, inComponent: 0, animated: true)
        case "정치":
            self.pickerCate.selectRow(10, inComponent: 0, animated: true)
        case "사회":
            self.pickerCate.selectRow(11, inComponent: 0, animated: true)
        case "과학":
            self.pickerCate.selectRow(12, inComponent: 0, animated: true)
        case "IT":
            self.pickerCate.selectRow(13, inComponent: 0, animated: true)
        default:
            self.pickerCate.selectRow(14, inComponent: 0, animated: true)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func editBook(_ sender: UIBarButtonItem) {
        let name = textTitle.text!
        let category: String = categoryArray[self.pickerCate.selectedRow(inComponent: 0)]
        
        if (name == "") {
            let alert = UIAlertController(title: "책 제목을 입력하세요", message: "Save Failed!!", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                alert.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true)
            return
        }
        
        guard let myImage = imgBook.image else {
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
        let urlString: String = "http://condi.swu.ac.kr/student/T10iphone/booklist/updateBook.php"
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
        restString += "&writer=" + textWriter.text!  + "&importance=" + textImportance.text!
        restString += "&pages=" + textPage.text! + "&date=" + myDate
        
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
        
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
