import Foundation

@objc class Student: NSObject {
    private var grade: Int
    @objc private var person: Person
    
    @objc init(name: String, age: Int, grade: Int) {
        self.grade = grade
        self.person = Person(name: name, age: Int(age))
        super.init()
    }
    
    @objc func introduce() {
        person.sayHello()
        print("I'm in grade \(grade)")
    }

    
    
    @objc func getGrade() -> Int {
        return grade
    }
    
    @objc func setGrade(_ newGrade: Int) {
        grade = newGrade
    }
}
