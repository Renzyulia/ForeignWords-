import Foundation

// MARK: For practice to injecting DI by Swinject
protocol LoggerProtocol {
  func log(_ message: String)
  var someString: String { get }
  var titleScreen: String { get }
}

protocol NumberProtocol {
  var number: Int { get }
}

class Logger: LoggerProtocol {
  let number: NumberProtocol
  var someString: String
  var titleScreen: String
  
  init(number: NumberProtocol, someString: String, titleScreen: String) {
    self.number = number
    self.someString = someString
    self.titleScreen = titleScreen
  }
  
  func log(_ message: String) {
    print(message)
  }
}

class Number: NumberProtocol {
  var number: Int
  
  init(number: Int) {
    self.number = number
  }
}
