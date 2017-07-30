import KituraNet

struct docker_swift {

    var text = "Hello, World!"
    
    func test() {
        HTTP.get("") { (response) in
            print(response)
        }
    }
}
