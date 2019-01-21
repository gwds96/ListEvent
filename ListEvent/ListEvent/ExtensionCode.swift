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

