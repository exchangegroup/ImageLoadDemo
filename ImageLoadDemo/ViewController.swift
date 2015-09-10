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
    
    loadSingleImage()
  }
  
  @IBAction func startBulkImageLoad(sender: AnyObject) {
    imageLoader.startBulkLoad()
  }
  
  @IBAction func didTapLoadSingleImage(sender: AnyObject) {
    loadSingleImage()
  }
  
  private func loadSingleImage() {
    if currentImageIndex >= ImageLoader.urls.count - 1 { currentImageIndex = 0 }
    let url = imageLoader.getUrl(currentImageIndex)
    currentImageIndex += 1
    
    imageView.image = nil
    
    imageLoader.download(url) { image in
      dispatch_async(dispatch_get_main_queue()) { [weak self] in
        self?.imageView.image = image
      }
    }
  }
}

