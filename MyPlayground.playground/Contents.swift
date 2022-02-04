import UIKit

let result = [1, 2, 3].map { $0 + 1 }.map { "만 \($0)살" }
print(result)

let num: Int? = 1
let result2 = num.map { $0 + 1 }
print(result2)

let myResult: Result<Int, Error> = .success(2)
let result3 = myResult.map { $0 + 1 }
print(result3)

// Map
// 1. Generic 타입
// Optional: enum Optional<Wrapped>
// Sequence: associatedtype Element
// Result: enum Result<Success, Failure> where Failure : Error
// Publisher: associatedtype Output

// 2. transform 함수를 인자로 받음.

// transform: A -> B
// F<A> -(map)-> F<B>

let ageString: String? = "10"
let result4 = ageString.map { Int($0) }
// result4: Int??
// transform: A -> OptionalB
// Optional<A> -(map)-> Optional<Optional<B>>

if let x = ageString.map(Int.init), let y = x {
    print(y)
}

if case let .some(.some(x)) = ageString.map(Int.init) {
    print(x)
}

if case let x?? = ageString.map(Int.init) {
    print(x)
}
// 이런식으로 언래핑을 두번해야하는 경우 문법이 복잡해짐
// 이럴 때 flatMap 사용

let result5 = ageString.flatMap(Int.init)
// transform: A -> OptionalB
// Optional<A> -(flatMap)-> Optional<B>
// map과 flatMap 두가지 모두 활용하면 작은 함수들을 composition해서 더 복잡한 작업을 파이프라인처럼 구성할 수 있게 됨

// 앱에서 일어나는 작업들은 데이터 타입을 전환해주는 작업이라고 볼 수 있음
// UIEvent -> IndexPath -> Model -> URL -> Data -> Model -> ViewModel -> View

struct MyModel: Decodable {
    let name: String
}

let myLabel = UILabel()

if let data = UserDefaults.standard.data(forKey: "my_data_key") {
    if let model = try? JSONDecoder().decode(MyModel.self, from: data) {
        let welcomeMessage = "Hello \(model.name)"
        myLabel.text = welcomeMessage
    }
}

let welcomeMessage = UserDefaults.standard.data(forKey: "my_data_key")
    .flatMap { try? JSONDecoder().decode(MyModel.self, from: $0) }
    .map(\.name)
    .map { "Hello \($0)" }

myLabel.text = welcomeMessage
