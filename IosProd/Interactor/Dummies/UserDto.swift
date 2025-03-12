struct UserDto: AnyObject {
    private let username: String
    private let email: String
    private let accounts: [BankAccountDto]
}
