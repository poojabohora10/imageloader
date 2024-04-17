//
//  ViewController.swift
//  ImageLoader
//
//  Created by APPLE on 14/04/24.
//

import UIKit

//imaege cache
var imageCache = NSCache<NSString, UIImage>()

class ViewController: UIViewController {
    
    @IBOutlet var colviw : UICollectionView!
    @IBOutlet var lblerror : UILabel!

    var imageurls = [Photo]()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        getImageUrls()
    }
    
    //get image urls
    func getImageUrls(){
        let imageServerUrl = "https://api.unsplash.com/photos?client_id=7WyXT9d3sEL6o6Wrdxm4ceJMWVFJWAI8N36uPdJLnlw".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        
        
        if let url = URL(string: imageServerUrl) {
            URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                if error != nil {
                    DispatchQueue.main.async {
                        self.lblerror.text = error!.localizedDescription
                        self.colviw.isHidden = true
                    }
                    return
                }
                if let data = data {
                    do {
                        let data1 = try JSONDecoder().decode([Photo].self, from: data)

                        DispatchQueue.main.async {
                            self.colviw.isHidden = false

                            self.imageurls.append(contentsOf: data1)
                            self.colviw.reloadData()
                        }
                    }
                    catch{
                        
                    }
                }
            }).resume()
        }
    }
}

//set collectionview
extension ViewController : UICollectionViewDataSource{

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 205;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)as! ImageCell

        if  imageurls.count > indexPath.row{
            cell.imgviw.loadImage(imageurls[indexPath.row].urls["thumb"]  , placeHolder: UIImage(named: "placeholder"))
        }
        else if imageurls.count > 0{//load first image for rest of the images
            cell.imgviw.loadImage(imageurls[0].urls["thumb"]  , placeHolder: UIImage(named: "placeholder"))
            
        }
        return cell
    }
    
    
}

extension  UIImageView {
    
    func loadImage(_ URLString: URL?, placeHolder: UIImage?) {
        
        self.image = nil
        
        if let url = URLString{
            
            if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
                self.image = cachedImage
                return
            }
            URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                
                if error != nil {
                    DispatchQueue.main.async {
                        self.image = placeHolder
                    }
                    return
                }
                if let data = data {
                    
                    if let downloadedImage = UIImage(data: data) {
                        imageCache.setObject(downloadedImage, forKey: url.absoluteString as NSString)
                        
                        DispatchQueue.main.async {
                            self.image = downloadedImage
                            
                        }
                    }
                }
            }).resume()
        }
    }
}

