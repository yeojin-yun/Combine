//: [Previous](@previous)

import Foundation
import Combine

struct School {
    let name: String
    let numberOfStudents: CurrentValueSubject<Int, Never>
    
    init(name: String, numberOfStudents: Int) {
        self.name = name
        self.numberOfStudents = CurrentValueSubject(numberOfStudents)
    }
}

let citySchool = School(name: "citySchool", numberOfStudents: 10)

let publisher = CurrentValueSubject<School, Never>(citySchool)

publisher
    .flatMap(maxPublishers: .max(1), {
        $0.numberOfStudents
    })
    //.flatMap { $0.numberOfStudents }
    .sink { print("results: ", $0) }



let townSchool = School(name: "타운스쿨", numberOfStudents: 50)
//results:  10

//publisher.value = townSchool
//results:  10
//results:  50

citySchool.numberOfStudents.value += 1
//results:  10
//results:  50
//results:  11

townSchool.numberOfStudents.value -= 3
//results:  10
//results:  50
//results:  11
//results:  47




//: [Next](@next)
