
import UIKit
import DropDown

class DropDownTextField: AgroTextField {
    
    internal var dropDown: DropDown!
    public var selectionAction: SelectionClosure?
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupLayout()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    public func setupDataField() -> () {
    
        addDropDownIndicator()
        
        dropDown = DropDown()
        dropDown.anchorView = self
        dropDown.direction = .bottom
        
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.selectionAction?(index, item)
            self.text = item
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(userTapTextField))
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(tap)
    }
    
    @objc func userTapTextField() {
        self.dropDown.show()
    }
    
    private func setupLayout() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.topAnchor.constraint(equalTo: topAnchor).isActive = true
        self.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        self.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true

        setupDataField()
    }
    
    public func doSelection(index: Index){
        self.selectionAction?(index, dropDown.dataSource[index])
        text = dropDown.dataSource[index]
        dropDown.selectRow(index)
    }
    
    public var dropDownData: [String]? {
        didSet{
            if let d = dropDownData{
                dropDown.dataSource = d
            }
        }
    }
    
    public var putData: String?{
        didSet{
            if let d = putData{
                dropDown.dataSource.append(d)
            }
        }
    }
    
    public var selectedData: String? {
        get{
            return dropDown.selectedItem
        }
    }
    
    public var selectedItemIndex: Int?{
        return dropDown.indexForSelectedRow
    }
}
