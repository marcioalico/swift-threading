//
//  ViewController.swift
//  ThreadingProject
//
//  Created by Marcio Alico on 2/3/22.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imageView: UIImageView!
    
    let urlStrings = ["https://hdwallsource.com/img/2014/7/large-40567-41517-hd-wallpapers.jpg",
                      "https://cdn.wallpapersafari.com/23/82/aRxJjZ.jpg"]
    
    var data = Data()
    var tracker = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tableView.delegate = self
        tableView.dataSource = self
        
        getImageInRightWay()
        addNavigationBarButton()
    }
    
    func getImageInWrongWay() {
        // Downloading image in main thread blocks user interaction while loading
        data = try! Data(contentsOf: URL(string: urlStrings[0])!)
        imageView.image = UIImage(data: data)
    }
    
    func getImageInRightWay() {
        
        DispatchQueue.global().async {
            // background thread -> request to fetch image data
            self.data = try! Data(contentsOf: URL(string: self.urlStrings[self.tracker])!)
            
            DispatchQueue.main.async {
                // Main thread -> refresh user interface
                self.imageView.image = UIImage(data: self.data)
            }
            
        }
    }
    
    func addNavigationBarButton() {
        self.navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(changeImage))
    }
    
    @objc func changeImage() {
        if tracker == 0 {
            tracker += 1
        } else {
            tracker -= 1
        }
        
        getImageInRightWay()
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        var contentConfig = cell.defaultContentConfiguration()
        contentConfig.text = "Threading Test"
        cell.contentConfiguration = contentConfig
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 55
    }
}

