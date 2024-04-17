//
//  ImageCell.swift
//  ImageLoader
//
//  Created by APPLE on 14/04/24.
//

import UIKit

class ImageCell: UICollectionViewCell {
    @IBOutlet var imgviw: UIImageView!
}
//
//  Photo.swift
//  Submissions
//
//  Created by Apple on 14/04/24.
//

/// A struct representing a photo from the  API.
public struct Photo: Codable {

    public let urls: [String: URL]

      private enum CodingKeys: String, CodingKey {
      
        case urls
       
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        urls = try container.decode([String:URL].self,forKey: .urls)
       
    }

    public func encode(to encoder: Encoder) throws {
       
    }

}
