
import EVReflection

class TransactionsResponse: BaseResponse {
    public var data: [TransactionsData]!
}

class TransactionsData: EVNetworkingObject {
    public var UserId: String!
    public var amount: String!
    public var created_time: String!
    public var status: String!
    public var tag: String!
    public var type: String!
    public var _id: String!
}

