//
//  ViewController.swift
//  SwiftDogs
//
//  Created by Alejandro Zielinsky on 2018-04-28.
//  Copyright © 2018 Alejandro Zielinsky. All rights reserved.
//

import UIKit

//struct Photo : Decodable
//{
//    let image:UIImage?
//    let photoName:String
//    //let flickrURL:String
//    let photoURL:String
//    let id: String
//    let farmID:Int
//    let serverID:String
//    let secret:String
//    
//   init(dict: [String: Any])
//    {
//        id = (dict["id"] as? String)!
//        photoName = (dict["title"] as? String)!
//        farmID = (dict["farm"] as? Int)!
//        serverID = (dict["server"] as? String)!
//        secret = (dict["secret"] as? String)!
//        image = nil;
//        photoURL = "https://farm\(farmID).staticflickr.com/\(serverID)/\(id)_\(secret).jpg"
//    }
//}

class ViewController: UIViewController , UICollectionViewDataSource
{

    var allPhotos = [Photo]()
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.startSessionTask()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return self.allPhotos.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! PhotoCell;
        
        cell.img.image = self.allPhotos[indexPath.row].image
        cell.label.text = self.allPhotos[indexPath.row].photoName
        
        return cell;
    }
    
    func fetchImageForPhoto(photo: Photo)
    {
        guard let photoURL =  URL(string:photo.photoURL)
            else
        { return }
        
        let request = NSURLRequest(url: photoURL)
        
        URLSession.shared.dataTask(with: request as URLRequest)
        {
            (data,response,error) in
            guard let imageData = data,
               let image = UIImage(data:imageData) else
            {
    
                print("Couldnt find image");
                return;
            }
            DispatchQueue.main.async
            {
                photo.image = image;
                self.collectionView.reloadData()
            }

        }.resume()
    }
    

    
    func startSessionTask()
    {
        guard let url =  URL(string:"https://api.flickr.com/services/rest/?method=flickr.photos.search&format=json&nojsoncallback=1&api_key=12b4f5ab7547f2de3140c989f974d48e&tags=dogs")
        else
        { return }
        
        URLSession.shared.dataTask(with: url)
        {
            (data,response,err) in
            
            guard let data = data else {return}
         
            do
            {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
             
                guard let jsonDictionary = json as? [String:AnyObject],
                    let photos = jsonDictionary["photos"] as? [String:AnyObject],
                let photosArray = photos["photo"] as? [[String:AnyObject]] else
                {
                    return
                }
                

                for photo in photosArray
                {
                    let p = Photo(dict:photo);
                    self.fetchImageForPhoto(photo:p)
                    self.allPhotos.append(p)
                }
                
            }
            catch let jsonErr
            {
                print("Error serializing json:",jsonErr)
            }
        }.resume()


    }
//
}

