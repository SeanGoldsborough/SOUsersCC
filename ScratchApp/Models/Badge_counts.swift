
import Foundation
struct Badge_counts : Codable {
	let bronze : Int?
	let silver : Int?
	let gold : Int?

	enum CodingKeys: String, CodingKey {

		case bronze = "bronze"
		case silver = "silver"
		case gold = "gold"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		bronze = try values.decodeIfPresent(Int.self, forKey: .bronze)
		silver = try values.decodeIfPresent(Int.self, forKey: .silver)
		gold = try values.decodeIfPresent(Int.self, forKey: .gold)
	}

}
