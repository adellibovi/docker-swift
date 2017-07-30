import KituraNet
import Foundation

class Runner {
    var keepAliveReferenceCount = 0
    let runLoop = RunLoop.current
    
    init() {}
    
    func execute(_ done: (@escaping () -> ()) -> ()) -> Runner {
        lock(); done { self.unlock() }; return self
    }
    func lock() { keepAliveReferenceCount += 1 }
    func unlock() { keepAliveReferenceCount -= 1 }
    func wait() {
        while keepAliveReferenceCount > 0 &&
            runLoop.run(mode: .defaultRunLoopMode, before: Date(timeIntervalSinceNow: 0.1)) { }
    }
}


let options: [ClientRequest.Options] = [
    .schema("http"),
    .method("GET"),
    .hostname("localhost"),
    .path("/info"),
    .socketPath("/var/run/docker.sock")
]
HTTP.request(options) { (response) in
    guard let response = response else { return }
    var data = Data()
    do {
        _ = try response.read(into: &data)
        let test = String(data: data, encoding: String.Encoding.utf8)
        print(test)
    } catch {
        print("Error in Kirutra-Request response: \(error)")
    }
    
}.end()

let runner = Runner.init()
runner.lock()
runner.wait()
