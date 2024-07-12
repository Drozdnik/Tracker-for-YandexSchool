import Foundation

actor NetworkServiceActor {
    var task: URLSessionDataTask?
    var isCancelled: Bool = false
    
    func set(_ dataTask: URLSessionDataTask) {
        task = dataTask
    }
    
    func cancel() {
        isCancelled = true
        task?.cancel()
    }
}

