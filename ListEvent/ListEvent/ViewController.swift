import UIKit
import Foundation

struct Event: Codable, Equatable {
    let status: Int
    let response: Response
}

struct Response: Codable, Equatable {
    let events: [Events]
}

struct Events: Codable, Equatable {
    let id: Int
    let status: Int
    let photo: String?
    let name: String?
    let description_raw: String?
    let description_html: String?
    let schedule_permanent: String?
    let schedule_date_warning: String?
    let schedule_time_alert: String?
    let schedule_start_date: String?
    let schedule_start_time: String?
    let schedule_end_date: String?
    let schedule_end_time: String?
    let schedule_one_day_event: Bool?
    let schedule_extra: String?
    let going_count: Int?
    let went_count: Int?
    let venue: Venue
}

struct Venue: Codable, Equatable {
    let id: Int?
    let name: String?
    let type: Int?
    let description: String?
    let schedule_openinghour: String?
    let schedule_closinghour: String?
    let schedule_closed: String?
}

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var events = [Events]()
    
    let imageCache = NSCache<AnyObject, AnyObject>()
    
    func takeImage(url: String) -> UIImage {
        var image: UIImage? = nil
        
        if let imageFromCache = imageCache.object(forKey: url as AnyObject) as? UIImage {
            image = imageFromCache
            return image!
        }
        
        if let urlImage = URL(string: url) {
            do {
                let dataImage = try Data(contentsOf: urlImage)
                let img = UIImage(data: dataImage)!
                imageCache.setObject(img, forKey: url as AnyObject)
                image = img
                return image!
            } catch let error {
                print(error.localizedDescription)
            }
        }
        return UIImage.init(named: "Noimage")!
    }
    
    override func viewDidLoad() {
        let task = URLSession.shared.dataTask(with: URL(
            string: "http://172.16.18.91/18175d1_mobile_100_fresher/public/api/v0/listPopularEvents")!) {(result, response, error) in
                guard
                    let data = result,
                    error == nil else {
                        return
                }
                do {
                    guard let obj = try? JSONDecoder().decode(Event.self, from: data) else {
                        return
                    }
                    DispatchQueue.main.async {
                        self.events = obj.response.events
                        self.tableView.reloadData()
                    }
                }
        }
        task.resume()
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let certifier = "EventCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: certifier, for: indexPath) as! EventCell
        if events[indexPath.row].photo != nil {
            cell.eventImage.image = takeImage(url: events[indexPath.row].photo!)
        }
        cell.titlelabel.text = events[indexPath.row].name
        cell.dateStartLabel.text = events[indexPath.row].schedule_start_date
        cell.timeStartLabel.text = events[indexPath.row].schedule_start_time
        cell.placeLabel.text = events[indexPath.row].venue.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let certifier = "DetailVC"
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: certifier) as! DetailVC
        if events[indexPath.row].photo != nil {
            vc.eventImg = takeImage(url: events[indexPath.row].photo!)
        }
        vc.eventTitle = events[indexPath.row].name
        vc.eventDetail = events[indexPath.row].description_raw?.htmlToString
        vc.eventGoing = String(events[indexPath.row].going_count ?? 0)
        vc.eventWent = String(events[indexPath.row].went_count ?? 0)
        self.present(vc, animated: true, completion: nil)
    }
}

extension String {
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
            return try NSAttributedString(data: data,
                                          options: [.documentType: NSAttributedString.DocumentType.html,
                                                    .characterEncoding: String.Encoding.utf8.rawValue],
                                          documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
}
