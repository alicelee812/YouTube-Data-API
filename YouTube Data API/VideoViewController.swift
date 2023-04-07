//
//  VideoViewController.swift
//  YouTube Data API
//
//  Created by Alice on 2023/3/29.
//

import UIKit
import WebKit

class VideoViewController: UIViewController {
    
    @IBOutlet weak var JamesWebView: WKWebView!
    
    //前一頁select到的tableview的row的位置
    var index: Int!
    
    //宣告儲存前一頁解析完成的API資料
    var data = [Video]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        //透過URLRequest指派並透過JamesWebView顯示網頁
        if let url = URL(string: "https://www.youtube.com/watch?v=\(data[index].videoID)") {
            let request = URLRequest(url: url)
            JamesWebView.load(request)
        }
        
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    
}
