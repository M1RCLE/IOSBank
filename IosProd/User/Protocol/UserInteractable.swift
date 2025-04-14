protocol UserInteractable: AnyObject {
    func fetchUserData(userId: String)
    func fetchUserAccounts(userId: String)
}
