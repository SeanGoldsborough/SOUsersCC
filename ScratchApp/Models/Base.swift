
import Foundation
struct Base : Codable {
	let items : [Items]?

	enum CodingKeys: String, CodingKey {

		case items = "items"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		items = try values.decodeIfPresent([Items].self, forKey: .items)
	}

}
