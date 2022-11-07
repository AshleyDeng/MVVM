import UIKit

final class UserTableViewCell: UITableViewCell {
    static let identifier = "\(UserTableViewCell.self)"
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        return label
    }()
    
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        return label
    }()
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(nameLabel)
        contentView.addSubview(emailLabel)
        contentView.clipsToBounds = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        nameLabel.frame = CGRect(x: 10,
                                 y: 5,
                                 width: contentView.frame.size.width,
                                 height: contentView.frame.size.height / 2)
        
        emailLabel.frame = CGRect(x: 10,
                                  y: contentView.frame.size.height / 2,
                                  width: contentView.frame.size.width,
                                  height: contentView.frame.size.height / 2)
    }
    
    override func prepareForReuse() {
        nameLabel.text = nil
        emailLabel.text = nil
    }
    
    func config(with user: User) {
        nameLabel.text = user.name
        emailLabel.text = user.email
    }
}
