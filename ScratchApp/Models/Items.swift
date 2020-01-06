
import Foundation
struct Items : Codable {
	let badge_counts : Badge_counts?
	let profile_image : String?
	let display_name : String?

	enum CodingKeys: String, CodingKey {

		case badge_counts = "badge_counts"
		case profile_image = "profile_image"
		case display_name = "display_name"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		badge_counts = try values.decodeIfPresent(Badge_counts.self, forKey: .badge_counts)
		profile_image = try values.decodeIfPresent(String.self, forKey: .profile_image)
		display_name = try values.decodeIfPresent(String.self, forKey: .display_name)
	}

}
