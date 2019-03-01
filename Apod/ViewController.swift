//
//  ViewController.swift
//  Apod
//
//  Created by Mark Meretzky on 3/1/19.
//  Copyright © 2019 New York University School of Professional Studies. All rights reserved.
//

import UIKit;

class ViewController: UIViewController {
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var imageView: UIImageView!;
    @IBOutlet weak var textView: UITextView!;
    
    override func viewDidLoad() {
        super.viewDidLoad();
        // Do any additional setup after loading the view, typically from a nib.
        
        let string: String = "https://api.nasa.gov/planetary/apod?api_key=DEMO_KEY";
        
        guard let url: URL = URL(string: string) else {
            fatalError("could not create URL from string \"\(string)\"");
        }
        
        let task: URLSessionDataTask = URLSession.shared.dataTask(with: url) {
            (data: Data?, response: URLResponse?, error: Error?) in
            
            if let error: Error = error {
                print("error = \(error)");
            }
            
            guard let data: Data = data else {
                return;
            }
            
            let dictionary: [String: Any];
            do {
                try dictionary = JSONSerialization.jsonObject(with: data) as! [String: Any];
            } catch {
                fatalError("could not create dictionary: \(error)");
            }
            
            guard let string: String = dictionary["url"] as? String else {
                fatalError("could not get url from dictionary");
            }
            
            guard let imageUrl: URL = URL(string: string) else {
                fatalError("could not create image URL from string \"\(string)\"");
            }
            
            let imageData: Data;
            do {
                imageData = try Data(contentsOf: imageUrl);
            } catch {
                fatalError("could not get image data from \(imageUrl): \(error)");
            }

            guard let image: UIImage = UIImage(data: imageData) else {
                fatalError("could not create image");
            }
            
            var header: String = "Astronomy Picture Of the Day";
            if let title: String = dictionary["title"] as? String {
                header += "\n\(title)";
            }
            if let date: String = dictionary["date"] as? String {
                header += "\n\(date)";
            }
            
            let explanation: String = dictionary["explanation"] as? String ?? "";
            
            DispatchQueue.main.async {
                //The following statements must be executed by the main thread
                //because they write on the screen.
                self.label.text = header;
                self.imageView.image = image;
                self.textView.text = explanation;
            }
        }
        
        task.resume();
    }

}
