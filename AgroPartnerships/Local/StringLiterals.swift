import Foundation

struct StringLiterals {
    
    // Loading Indicator Messages
    static let STARTING =                       "Starting . . ."
    static let REQUESTING_FOR_OTP =             "Requesting for Otp . . ."
    static let VALIDATING_OTP =                 "Validating OTP . . ."
    static let CREATING_PIN =                   "Creating pin . . ."
    static let CREATING_PLAN =                  "Creating plan . . ."
    static let AUTHENTICATING_USER =            "Authenticating, please wait . . ."
    static let PLEASE_WAIT =                    "Please Wait . . ."
    static let CHECKING_IF_CUSTOMER_EXIST =     "Checking if customer's record exists . . ."
    static let CREATING_NEW_CUSTOMER_ACCOUNT =  "Setting up your new account . . ."
    
    // In app strings
    static let GENERIC_NETWORK_ERROR =          "An unexpected network error occurred. please try again"
    static let BACK =                           "Back"
    static let SIGN_IN =                        "Sign In"
    static let PLEASE_CHOOSE_ONE =              "Please Choose One"
    static let FIELD_IS_REQUIRED =              "This Field is required!"
    static let ALL_FIELDS_REQUIRED =            "All Fields are required!"
    static let TERMS_N_CONDITION_TEXT =         "By signing up, you agree to the " +
        "<a href='http://www.google.com//'>Terms of Service</a> and " +
    "<a href='http://www.google.com//'>Privacy Policy</a>"
    static let BVN_NOT_VALID =                  "BVN must be 11-digits long"
    static let CARD_NUMBER_NOT_VALID =          "Account Number must be at least 16-digits long"
    static let CVV_NOT_VALID =                  "CVV must be 3-digits long"
    static let CARD_EXPIRY_DATE_NOT_VALID =     "Card expiry date is invalid. \n Seems your card has expired"
    static let ADD_CARD =                       "Add Card"
    static let ADD_BANK =                       "Add Bank"
    static let DONE =                           "Done"
    static let DELETE =                         "Delete"
    static let CHOOSE_ONE =                     "Choose One"

    // Dialog Text
    static let CANCEL =                         "Cancel"
    static let CONFIRM =                        "Confirm"
    static let OK =                             "OK"
    
    static let SAVINGS_PLAN =                   ["3 Months",
                                                 "6 Months",
                                                 "1 Year",
                                                 "2 Years",
                                                 "Infinity"]
    
    static let GENDERS =                        ["Male", "Female"]
    
    static let DURATION_TYPES =                  ["Days", "Weeks", "Months", "Years"]
    
    static let DEDUCTION_FREQS =                 ["Daily", "Weekly", "Monthly", "Quarterly"]
    
    static let PLAN_ITEMS =                     [ "Car", "Hospital", "Marriage", "Vacation", "WealthFund", "Rent","Shopping",
                                                "Land","Fees","Baby","Wedding","Gifts"]
    
    static let MONTHS =                          [("Jan", "01"), ("Feb", "02"), ("Mar", "03"), ("April", "04"),
                                                  ("May", "05"), ("June", "06"), ("July", "07"), ("Aug", "08"),
                                                  ("Sept", "09"), ("Oct", "10"), ("Nov", "11"), ("Dec", "12")]
    
    
    static let SAMPLE =                         ["Item 1","Item 2","Item 3","Item 4","Item 5","Item 6","Item 7","Item 8"]
    static let Titles =                         ["Mr", "Mrs", "Miss"]
    static let DialingCodes =                   ["+234"]
}
