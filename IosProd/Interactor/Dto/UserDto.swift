struct UserDTO: Codable {
    let id: String
    let username: String
    let email: String
    let accounts: [BankAccountDTO]
    
    func toModel() -> User {
        return User(
            id: id,
            username: username,
            email: email,
            accounts: accounts.map { $0.toModel() }
        )
    }
    
    static func fromModel(_ model: User) -> UserDTO {
        return UserDTO(
            id: model.id,
            username: model.username,
            email: model.email,
            accounts: model.accounts.map { BankAccountDTO.fromModel($0) }
        )
    }
}
