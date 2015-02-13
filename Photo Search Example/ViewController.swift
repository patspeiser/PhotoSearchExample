//
//  ViewController.swift
//  Photo Search Example
//
//  Created by pat on 2/13/15.
//  Copyright (c) 2015 patspeiser. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UISearchBarDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    let mySearchURL: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        searchInstagramByHashtag("dogs")
        
    }
    
    func searchInstagramByHashtag(searchString:String) {
        let manager = AFHTTPRequestOperationManager()
        
        manager.GET( "https://api.instagram.com/v1/tags/\(searchString)/media/recent?client_id=39ff8497317044ffb456c2eed5a5fe4c",
            parameters: nil,
            success: { (operation: AFHTTPRequestOperation!,responseObject: AnyObject!) in
                //println("JSON: " + responseObject.description)
                
                if let dataArray = responseObject["data"] as? [AnyObject]{
                    var urlArray:[String] = []
                    for dataObject in dataArray {
                        if let imageURLString = dataObject.valueForKeyPath("images.standard_resolution.url") as? String {
                            urlArray.append(imageURLString)
                        }
                    }
                    self.scrollView.contentSize = CGSizeMake(320, 320 * CGFloat(dataArray.count))
                    
                    let imageWidth = self.view.frame.width
                    self.scrollView.contentSize = CGSizeMake(imageWidth, imageWidth * CGFloat(dataArray.count))
                    
                    for var i = 0; i < urlArray.count; i++ {
                        let imageView = UIImageView(frame: CGRectMake(0, imageWidth*CGFloat(i), imageWidth, imageWidth))
                        imageView.setImageWithURL( NSURL(string: urlArray[i]))
                        self.scrollView.addSubview(imageView)
                    }
                }
            },
            failure: { (operation: AFHTTPRequestOperation!,error: NSError!) in
                println("Error: " + error.localizedDescription)
        })

        
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        for subview in self.scrollView.subviews {
            subview.removeFromSuperview()
        }
        
        searchBar.resignFirstResponder()
        
        var searchText = searchBar.text.stringByReplacingOccurrencesOfString(" ", withString: "")
        //println(searchText)
        
        searchInstagramByHashtag(searchText)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

