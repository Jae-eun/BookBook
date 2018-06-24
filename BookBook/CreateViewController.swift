//
//  CreateViewController.swift
//  BookBook
//
//  Created by SWUCOMPUTER on 2018. 6. 3..
//  Copyright © 2018년 SWUCOMPUTER. All rights reserved.
//

import UIKit


class CreateViewController: UIViewController, UITextFieldDelegate {
        
        @IBOutlet var textID: UITextField!
        @IBOutlet var textPassword: UITextField!
        @IBOutlet var rePassword: UITextField!
        @IBOutlet var textName: UITextField!
        @IBOutlet var labelStatus: UILabel!
        
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {   //delegate method
            
            if textField == self.textName {
                textField.resignFirstResponder()
                self.textID.becomeFirstResponder()
            }
            else if textField == self.textID {
                textField.resignFirstResponder()
                self.textPassword.becomeFirstResponder()
            }
            else if textField == self.textPassword {
                textField.resignFirstResponder()
                self.rePassword.becomeFirstResponder()
            }
            textField.resignFirstResponder()
            return true
        }
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
           labelStatus.text = ""
            // Do any additional setup after loading the view.
        }
        
        func executeRequest (request: URLRequest) -> Void {
            let session = URLSession.shared
            let task = session.dataTask(with: request) { (responseData, response, responseError) in
                guard responseError == nil else {
                    print("Error: calling POST")
                    return
                }
                guard let receivedData = responseData else {
                    print("Error: not receiving Data")
                    return
                }
                if let utf8Data = String(data: receivedData, encoding: .utf8) {
                    DispatchQueue.main.async {     // for Main Thread Checker
                        self.labelStatus.text = utf8Data
                    }
                    print(utf8Data)  // php에서 출력한 echo data가 debug 창에 표시됨
                }
            }
            task.resume()
        }
        
        @IBAction func buttonSave() {
            if textID.text == "" {
                labelStatus.text = "아이디를 입력하세요"; return;
            }
            if textPassword.text == "" {
                labelStatus.text = "패스워드를 입력하세요"; return;
            }
            if textPassword.text != rePassword.text {
                labelStatus.text = "비밀번호가 일치하지 않습니다"; return;
            }
            if textName.text == "" {
                labelStatus.text = "이름을 입력하세요"; return;
            }
            let urlString: String = "http://condi.swu.ac.kr/student/T10iphone/insertUser.php"
            
            guard let requestURL = URL(string: urlString) else {
                return
            }
            
            var request = URLRequest(url: requestURL)
            
            request.httpMethod = "POST"
            
            let restString: String = "id=" + textID.text! + "&passwd=" + textPassword.text! + "&name=" + textName.text!
            
            request.httpBody = restString.data(using: .utf8)
            
            self.executeRequest(request: request)
        }
        
        @IBAction func buttonBack() {
            self.dismiss(animated: true, completion: nil)
        }

}
