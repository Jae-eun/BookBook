//
//  BookTableViewController.swift
//  BookBook
//
//  Created by SWUCOMPUTER on 2018. 6. 3..
//  Copyright © 2018년 SWUCOMPUTER. All rights reserved.
//

import UIKit


class BookTableViewController: UITableViewController {
 
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var imageLabel: UIImageView!
    @IBOutlet var cateLabel: UILabel!
    @IBOutlet var impoLabel: UILabel!
    
    var fetchedArray: [BookData] = Array()
    
    // View가 보여질 때 자료를 DB에서 가져오도록 한다
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    
        fetchedArray = []
       self.downloadDataFromServer()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections (in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView:UITableView, numberOfRowsInSection section: Int)->Int {
        return fetchedArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell = tableView.dequeueReusableCell(withIdentifier: "Book Cell", for: indexPath)  // Configure the cell...
        
       
        
        //var nameDisplay: String = ""
        //  var imageDisplay: String = ""
       //  var cateDisplay: String = ""
        //var impoDisplay: String = ""
        
        
        let book = fetchedArray[indexPath.row]
        cell.textLabel?.text = book.name
        
   
        
    //    if let nameLabel = book.value(forKey: "name") as? String {
     //       nameDisplay = nameLabel }
      
     //    if let imageLabel = book.value(forKey: "image") as? String {
     //    imageDisplay = imageLabel }
         
      //   if let cateLabel = book.value(forKey: "category") as? String {
      //   cateDisplay = cateLabel }
         
     //    if let impoLabel = book.value(forKey: "importance") as? String {
     //    impoDisplay = impoLabel }
         
       //  cell.textLabel?.text = nameDisplay
        //cell.imageLabel? = book.image
         cell.detailTextLabel?.text = book.category
         //cell.impoLabel?.text = book.importance
 
 
      
        return cell
    }

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if let name = appDelegate.userName {
            self.title = name + "'s BookList"
        }
    }
    
    
    func downloadDataFromServer() -> Void {
        let urlString: String = "http://condi.swu.ac.kr/student/T10iphone/booklist/bookTable.php"
        guard let requestURL = URL(string: urlString) else { return }
        let request = URLRequest(url: requestURL)
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (responseData, response, responseError) in
            guard responseError == nil else { print("Error: calling POST"); return; }
            guard let receivedData = responseData else { print("Error: not receiving Data"); return; }
            let response = response as! HTTPURLResponse
            
            if !(200...299 ~= response.statusCode) { print("HTTP response Error!"); return }
            do {
                if let jsonData = try JSONSerialization.jsonObject(with: receivedData, options:.allowFragments) as? [[String: Any]] {
                    for i in 0...jsonData.count-1 {
                        let newData: BookData = BookData()
                        var jsonElement = jsonData[i]
                     //   newData.bookno = jsonElement["bookno"] as! String
                        newData.userid = jsonElement["userid"] as! String
                        newData.image = jsonElement["image"] as! String
                        newData.name = jsonElement["name"] as! String
                        newData.category = jsonElement["category"] as! String
                        newData.writer = jsonElement["writer"] as! String
                        newData.pages = jsonElement["pages"] as! String
                        newData.date = jsonElement["date"]  as! String
                        self.fetchedArray.append(newData)
                    }
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            } catch {
                print("Error:")
            }
        }
        task.resume()
    }
    
  
    
    override func prepare (for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "toDetailView" {
            if let destination = segue.destination as? DetailViewController {
                if let selectedIndex = self.tableView.indexPathsForSelectedRows?.first?.row {
                    
                    let data = fetchedArray[selectedIndex]  // BookData 타입
                      destination.selectedData = data
                    destination.title = data.name
                    
                }
            }
            
        }
    }
    
    // MARK: - Table view data source
    
    /*
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedArray.count
    }
    */
    
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
   

}
