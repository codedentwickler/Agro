import UIKit

class DateDropDownTextField: AgroTextField, UITextFieldDelegate{

    private var datePicker: UIDatePicker!
    private var selectedDate: String!
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupLayout()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    private func setupDatePicker() -> () {
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: StringLiterals.DONE,
                                         style: .plain, target: self,
                                         action: #selector(userPressDoneButton))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: StringLiterals.CANCEL, style: .plain, target: self, action: #selector(userPressCancelButton));
        
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)

        datePicker = UIDatePicker()
        inputView = datePicker
        inputAccessoryView = toolbar
//        datePicker.addTarget(self, action: #selector(handleDatePicker), for: UIControl.Event.valueChanged)
        datePicker.datePickerMode = .date
    
        delegate = self
    }
    
    @objc func userPressDoneButton(){
        handleDatePicker()
        endEditing(true)
    }
    
    @objc func userPressCancelButton(){
        endEditing(true)
    }
    
    public func setupDatePicker(withMinimumDate minimumDate: Date = Date(),
                                withMaximumDate maximumDate: Date = Date(),
                                withDefaultDate defaultDate: Date = Date()) {
        datePicker.minimumDate = minimumDate
        datePicker.maximumDate = maximumDate
        datePicker.setDate(defaultDate, animated: true)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
    }
    
    open func setupLayout() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.topAnchor.constraint(equalTo: topAnchor).isActive = true
        self.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        self.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true

        addDropDownIndicator()
        setupDatePicker()
    }
    
    @objc func handleDatePicker() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd, yyyy"
        text = dateFormatter.string(from: datePicker.date)
        dateFormatter.dateFormat = "yyyy-MM-dd"
        selectedDate = dateFormatter.string(from: datePicker.date)
    }
}
