import UIKit

class ViewController: UIViewController {
  var imageLoader = ImageLoader()
  var currentImageIndex = 0

  @IBOutlet weak var imageView: UIImageView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    imageLoader.logger = { message, url in
      print("\(message) \(url)")
    }
  }
  
  @IBAction func startBulkImageLoad(sender: AnyObject) {
    imageLoader.startBulkLoad()
  }
  
  @IBAction func loadSingleImage(sender: AnyObject) {
    if currentImageIndex >= ImageLoader.urls.count - 1 { currentImageIndex = 0 }
    let url = ImageLoader.urls[currentImageIndex]
    currentImageIndex += 1
    
    imageLoader.download(url) { image in
      dispatch_async(dispatch_get_main_queue()) { [weak self] in
        self?.imageView.image = image
      }
    }
  }
}

