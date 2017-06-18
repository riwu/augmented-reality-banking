import UIKit

struct Activity {
    let title: String
    let category: Category
    let cost: Double
    let date: Date
    let location: String
    let host: String
    let description: String
    var signUps: UInt32?
    let vacancy: UInt32?
    
    mutating func incrementSignUps() {
        if let signUps = signUps {
            self.signUps =  signUps + 1
        }
    }
}

struct Activities {
    static var randTime: Date {
        return Date(timeIntervalSinceNow: TimeInterval(UInt32(3600 * 24 * 3) + arc4random_uniform(UInt32(3600*24*30)))) 
    }
    
    static var randTimeNearer: Date {
        return Date(timeIntervalSinceNow: TimeInterval(arc4random_uniform(UInt32(3600*24*3)))) 
    }
    
    static var activities = [Activity(title: "Karaoke Night", category: Category.music, cost: 3,  
                                      date: Activities.randTime, 
                                      location: "53 Clementi Complex #02-85", host: "933 Choir", 
                                      description: "Join us for a night of fun! Traditional chinese songs included",
                                      signUps: arc4random_uniform(12), vacancy: 15 + arc4random_uniform(50)),
                             
                             Activity(title: "Dinner gathering", category: Category.dining, cost: 15, 
                                      date: Activities.randTime, 
                                      location: "2 Yishun Mall #01-21", host: "Ban Huat Restaurant", 
                                      description: "Celebrate Mother's day with a 8 course meal by Ban Huat.",
                                      signUps: arc4random_uniform(12), vacancy: 15 + arc4random_uniform(50)),
                             
                             Activity(title: "Chinese Chess", category: Category.boardGame, cost: 0, 
                                      date: Activities.randTime, 
                                      location: "YewTee Community Club", host: "nil", 
                                      description: "Join us for a game of Chinese Chess!",
                                      signUps: arc4random_uniform(12), vacancy: 15 + arc4random_uniform(50)),
                             
                             Activity(title: "NDP 2017 Roadshow", category: Category.celebration, cost: 0, 
                                      date: Activities.randTime, 
                                      location: "Jurong East Mrt", host: "SAF", 
                                      description: "Public exhibition of our army latest technology",
                                      signUps: arc4random_uniform(12), vacancy: 15 + arc4random_uniform(50)),
                             
                             Activity(title: "JB one day tour", category: Category.travel, cost: 50, 
                                      date: Activities.randTime, 
                                      location: "Keat Hong Community Club", host: "Traveller Pte Ltd", 
                                      description: "Full day tour in Johor Bahru. Lunch and Dinner included.",
                                      signUps: arc4random_uniform(12), vacancy: 15 + arc4random_uniform(50)),
                             
                             Activity(title: "Cooking Class", category: Category.dining, cost: 10, 
                                      date: Activities.randTime, 
                                      location: "Yishun Community Club", host: "Chef Alex Wong", 
                                      description: "Learn how to cook traditional Cantonese dishes!",
                                      signUps: arc4random_uniform(12), vacancy: 15 + arc4random_uniform(50)),
                             
                             Activity(title: "NTUC Income Run", category: Category.sports, cost: 0, 
                                      date: Activities.randTime, 
                                      location: "Singapore Padang", host: "NTUC Income", 
                                      description: "Join us for a 5km walk/run. Free for all pioneers. Goodie bag included.",
                                      signUps: arc4random_uniform(12), vacancy: 15 + arc4random_uniform(50)),
                             
                             Activity(title: "NDP Rehearsal", category: Category.celebration, cost: 5, 
                                      date: Activities.randTime, 
                                      location: "Various CC", host: "nil", 
                                      description: "View the rehearsal of NDP2017! Limited tickets. Transport provided",
                                      signUps: arc4random_uniform(12), vacancy: 15 + arc4random_uniform(50)),
                             
                             Activity(title: "Mahjong night", category: Category.boardGame, cost: 0, 
                                      date: Activities.randTime, 
                                      location: "Choa Chu Kang Community Club", host: "nil", 
                                      description: "Join us for a night of fun! Limited signups.",
                                      signUps: arc4random_uniform(12), vacancy: 15 + arc4random_uniform(50)),
                             
                             Activity(title: "Farm-hopping tour", category: Category.travel, cost: 10, 
                                      date: Activities.randTime, 
                                      location: "Bedok Community Club", host: "Travellog Pte Ltd", 
                                      description: "Visit Singapore countryside! Fully guided tour and lunch provided",
                                      signUps: arc4random_uniform(12), vacancy: 15 + arc4random_uniform(50)),
                             ].sorted { $0.date < $1.date }
    
    static var schedules = [Activity(title: "Pizza Delivery", category: Category.foodDelivery, cost: 15, 
                                     date: Activities.randTimeNearer, 
                                     location: "Home", host: "SATS", 
                                     description: "Pizza 15 inch with beef",
                                     signUps: nil, vacancy: nil),
                            
                            Activity(title: "Plumbing Service", category: Category.repair, cost: 0, 
                                     date: Activities.randTimeNearer, 
                                     location: "Home", host: "BS Plumbing Services", 
                                     description: "Repair master bedroom toilet",
                                     signUps: nil, vacancy: nil),
                            
                            Activity(title: "Singapore General Hospital", category: Category.travel, cost: 10, 
                                     date: Activities.randTimeNearer, 
                                     location: "Void Deck", host: "Uber", 
                                     description: "Travel to SGH for yearly check up",
                                     signUps: nil, vacancy: nil),
                            ].sorted { $0.date < $1.date }
}
