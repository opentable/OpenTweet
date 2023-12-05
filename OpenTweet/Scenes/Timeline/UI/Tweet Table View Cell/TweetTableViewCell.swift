import UIKit

/// View model for the `TweetTableViewCell`
struct TweetTableViewCellViewModel {
    struct Image {
        let url: URL?
        let placeholderImage: UIImage?
    }
    
    let author: String
    let avatarImage: Image
    let content: NSAttributedString
    let date: String
}

final class TweetTableViewCell: UITableViewCell {
    @IBOutlet private weak var avatarImageView: UIImageView!
    @IBOutlet private weak var authorLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var contentLabel: UILabel!
}

extension TweetTableViewCell: TableViewCellConfigurable, ImageProvidable {
    typealias Info = TweetTableViewCellViewModel
    
    func configure(withInfo info: TweetTableViewCellViewModel) {
        avatarImageView.image = info.avatarImage.placeholderImage
        authorLabel.text = info.author
        dateLabel.text = info.date
        contentLabel.attributedText = info.content
        
        if let avatarImageUrl = info.avatarImage.url {
            fetchImage(fromUrl: avatarImageUrl) { [weak self] image in
                guard let image else { return }
                
                DispatchQueue.main.async {
                    self?.avatarImageView.image = image
                }
            }
        }
    }
}
