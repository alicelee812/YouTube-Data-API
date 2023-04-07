//
//  JamesTableViewController.swift
//  YouTube Data API
//
//  Created by Alice on 2023/3/29.
//

import UIKit

class JamesTableViewController: UITableViewController {
    
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    
    //宣告allVideos變數儲存所有影片
    var allVideos = [Video]()
    //宣告favoriteVideos變數儲存isFavorite為true的影片
    var favoriteVideos = [Video]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchItems()
        
        //固定row的高度
        tableView.rowHeight = 300
        

    }
    
    
    //定義抓資料的fetchItems
    func fetchItems() {
        let apikey = "[YOUR_API_KEY]"
        //let nextPageToken = "EAAaBlBUOkNESQ"
        
        let urlString = "https://youtube.googleapis.com/youtube/v3/playlistItems?part=snippet&maxResults=50&playlistId=UU4_Ds33FmwzcTDL3G2pbs7g&key=[YOUR_API_KEY]"
        if let url = URL(string: urlString) {
            //{}的程式是closure，資料下載完成時會執行{}的程式，傳入data(抓到的資料),reponse(後台回傳抓資料的結果),error(錯誤資訊)三個參數。
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data {
                    let decoder = JSONDecoder()
                    do {
                        //透過decode將Data轉成對應的物件內容
                        let searchResponse = try decoder.decode(SearchResponse.self, from: data)
                        // 將解碼後的資料取出需要的項目整理到新的array中
                        var newvideos: [Video] = []
                        for item in searchResponse.items {
                            let video = Video(thumbnailUrl: item.snippet.thumbnails.standard.url , title: item.snippet.title, videoID: item.snippet.resourceId.videoId)
                            newvideos += [video]
                        }
                        //因為completionHandler將在function dataTask執行過後一段時間才執行，所以要加self
                        self.allVideos = newvideos
                        //需在main thread執行UI相關的程式
                        DispatchQueue.main.async {
                            //如果沒有reload data，表格不會更新，只會看到一片空白
                            self.tableView.reloadData()
                        }
                        print("get data")
                    } catch {
                        print(error)
                    }
                }
            } .resume()
            print("function dataTask執行完會先回傳task，然後呼叫task的resume啟動它")
        }
        
    }
    
    
    //點選likeButton時，將影片加入喜愛項目，並更新點選的cell內容
    @IBAction func likeAction(_ sender: UIButton) {
        //更新allVideos的isFavorite狀態
        allVideos[sender.tag].isFavorite = !allVideos[sender.tag].isFavorite
        //更新指定的cell(at indexPaths: [IndexPath],with animation: UITableView.RowAnimation)
        tableView.reloadRows(at: [IndexPath(row: sender.tag, section: 0)], with: .none)
    }
    
    
    //點選segmentedControl時，重新整理表格，才會出現有點選like的影片
    @IBAction func changeSegmentedControl(_ sender: UISegmentedControl) {
        segmentedControl.selectedSegmentIndex = sender.selectedSegmentIndex
        tableView.reloadData()
    }
    

 
    
    

    // MARK: - Table view data source

    //表格有幾段
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    //每一段表格有幾列
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //當segment為0時，顯示所有抓到的影片
        if segmentedControl.selectedSegmentIndex == 0  {
            return allVideos.count
        //當segment為1時，顯示有點選isFavorite的影片
        } else {
            //array過濾函示filter，可以把$0看成array的元素
            favoriteVideos = allVideos.filter({ $0.isFavorite})
            return favoriteVideos.count
        }
    }
    
    //回傳哪一個cell，可從參數 indexPath 得到 section & row
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = tableView.dequeueReusableCell(withIdentifier: "JamesTableViewCell", for: indexPath) as! JamesTableViewCell
        
        //當segment為0時，顯示所有抓到的影片; 當segment為1時，顯示有點選isFavorite的影片
        var video: Video
        //也可以這樣寫：var video = allVideos[indexPath.row]
        if segmentedControl.selectedSegmentIndex == 0  {
            video = allVideos[indexPath.row]
        } else {
            video = favoriteVideos[indexPath.row]
        }
        
        //顯示影片標題
        cell.titleLabel.text = video.title
        
        //用三元運算子來簡化條件判斷式的寫法 (likeButton顯示的image)
        cell.likeButton.imageView?.image = video.isFavorite ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart")
        //原條件判斷式寫法 (likeButton顯示的image)
        /*
        var isFavoriate = true
        if isFavoriate {
            cell.likeButton.imageView?.image = UIImage(systemName: "heart.fill")
        } else {
            cell.likeButton.imageView?.image = UIImage(systemName: "heart")
        }
         */
        
        
        //用tag辨別點選了哪一個按鈕
        cell.likeButton.tag = indexPath.row
        
        //先顯示預設圖片，才不會因從網路抓取需時間而看到先前的圖片
        cell.thumbnailImageView.image = UIImage(systemName: "video.circle.fill")
        URLSession.shared.dataTask(with:
                                    video.thumbnailUrl) { data, response, error in
            if let data {
                let image = UIImage(data: data)
                    DispatchQueue.main.async {
                        cell.thumbnailImageView.image = image
                    }
            }
        }.resume()
        
        return cell
    }
    
    
    //以prepare傳遞資料到下一頁
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let videoVC = segue.destination as? VideoViewController {
            let selectedRow = tableView.indexPathForSelectedRow
            if let passIndex = selectedRow?.row {
                videoVC.index = passIndex
                videoVC.data = allVideos
            }
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
