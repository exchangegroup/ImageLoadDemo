import UIKit

class UrlLog {
  var urls = [String: Int]()
  var totalRequests = 0
  var uniqueUrls = [String: Bool]()
  
  func add(url: String) {
    let requestsNumber = (urls[url] ?? 0) + 1
    urls[url] = requestsNumber
    totalRequests += 1
    
    uniqueUrls[url] = true
  }
  
  func remove(url: String) {
    let requestsNumber = (urls[url] ?? 0) - 1
    
    //    if requestsNumber == 0 {
    //      urls.removeValueForKey(url)
    //    } else {
    //      urls[url] = requestsNumber
    //    }
  }
}

class ViewController: UIViewController {
  var imageLoader = ImageLoader()
  var currentImageIndex = 0
  var urlLog = UrlLog()

  @IBOutlet weak var imageView: UIImageView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    imageLoader.logger = { message, url in
      print("\(message) \(url)")
    }
    
    Moa.settings.requestTimeoutSeconds = 10
    Moa.settings.maximumSimultaneousDownloads = 3
    
    Moa.logger = { logType, url, status, error in
      switch logType {
      case .RequestSent:
        self.urlLog.add(url)
        
      case .RequestCancelled, .ResponseSuccess, .ResponseError:
        self.urlLog.remove(url)
        
      }
      
      if let error = error {
        print(error.localizedDescription)
      }
      
      print("Ongoing requests: \(self.urlLog.urls.count) / \(self.urlLog.totalRequests)")
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

