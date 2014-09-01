import Foundation


@objc public class NoteBlockTextTableViewCell : NoteBlockTableViewCell, DTAttributedTextContentViewDelegate
{
    // MARK: - Public Properties
    public var onUrlClick: ((NSURL) -> Void)?
    public var attributedText: NSAttributedString? {
        didSet {            
            attributedLabel.attributedString = attributedText != nil ? attributedText! :  NSAttributedString()
            setNeedsLayout()
        }
    }
    public var numberOfLines: Int {
        return maxNumberOfLines
    }
    public var labelInsets: UIEdgeInsets {
        return insets
    }
    public var isBadge: Bool = false {
        didSet {
            backgroundColor = isBadge ? WPStyleGuide.Notifications.badgeBackgroundColor : WPStyleGuide.Notifications.blockBackgroundColor
        }
    }
    
    // MARK: - View Methods
    public override func awakeFromNib() {
        super.awakeFromNib()
                
        backgroundColor                   = WPStyleGuide.Notifications.blockBackgroundColor
        selectionStyle                    = .None

        attributedLabel.backgroundColor   = UIColor.clearColor()
        attributedLabel.numberOfLines     = numberOfLines
        attributedLabel.delegate          = self
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        // Manually update DTAttributedLabel's size
        attributedLabel.layoutFrameHeightIsConstrainedByBounds = false
        
        let insets  = labelInsets
        let width   = min(bounds.width, maxWidth) - insets.left - insets.right
        var size    = attributedLabel.suggestedFrameSizeToFitEntireStringConstraintedToWidth(width)
        attributedLabel.frame.size = size
    }
    
    // MARK: - DTAttributedTextContentViewDelegate
    public func attributedTextContentView(attributedTextContentView: DTAttributedTextContentView!, viewForLink url: NSURL!, identifier: String!, frame: CGRect) -> UIView! {
        let linkButton                          = DTLinkButton(frame: frame)
        
        linkButton.URL                          = url
        linkButton.showsTouchWhenHighlighted    = false
        
        linkButton.addTarget(self, action: Selector("buttonWasPressed:"), forControlEvents: .TouchUpInside)

        return linkButton
    }
    
    // MARK: - IBActions
    @IBAction public func buttonWasPressed(sender: DTLinkButton) {
        if let listener = onUrlClick {
            listener(sender.URL)
        }
    }
    
    // MARK: - Private
    private let maxWidth            = WPTableViewFixedWidth
    private let insets              = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 14)
    private let maxNumberOfLines    = 0
    
    // MARK: - IBOutlets
    @IBOutlet private weak var attributedLabel: DTAttributedLabel!
}
