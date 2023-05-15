
import Foundation

// MARK: - Welcome
    
    struct Welcome: Codable {
        let data: [Genre]
    }

    // MARK: - Datum
    struct Genre: Codable {
        let id: Int
        let name: String
        let picture: String
        let pictureSmall, pictureMedium, pictureBig, pictureXl: String
        let type: TypeEnum

        enum CodingKeys: String, CodingKey {
            case id, name, picture
            case pictureSmall = "picture_small"
            case pictureMedium = "picture_medium"
            case pictureBig = "picture_big"
            case pictureXl = "picture_xl"
            case type
        }
    }

    enum TypeEnum: String, Codable {
        case genre = "genre"
    }

 

