import UIKit

struct Activity {
    let title: String
    let category: Category
    let cost: Double
    let Date: Date
    let location: String
    let host: String
    let description: String
}

struct Activities {
    static var randTime: Date {
        return Date(timeIntervalSinceNow: TimeInterval(arc4random_uniform(UInt32(3600*24*30)))) 
    }
    static var activities = [Activity(title: "Karaoke Night", category: Category.music, cost: 3,  
                                      Date: Activities.randTime, 
                                      location: "53 Clementi Complex #02-85", host: "933 Choir", 
                                      description: "Join us for a night of fun! Traditional chinese songs included"),
                             
                             Activity(title: "Dinner gathering", category: Category.dining, cost: 15, 
                                      Date: Activities.randTime, 
                                      location: "2 Yishun Mall #01-21", host: "Ban Huat Restaurant", 
                                      description: "Celebrate Mother's day with a 8 course meal by Ban Huat."),
                             
                             Activity(title: "Chinese Chess", category: Category.boardGame, cost: 0, 
                                      Date: Activities.randTime, 
                                      location: "YewTee Community Club", host: "nil", 
                                      description: "Join us for a game of Chinese Chess!"),
                             
                             Activity(title: "NDP 2017 Roadshow", category: Category.celebration, cost: 0, 
                                      Date: Activities.randTime, 
                                      location: "Jurong East Mrt", host: "SAF", 
                                      description: "Public exhibition of our army latest technology"),
                             
                             Activity(title: "JB one day tour", category: Category.travel, cost: 50, 
                                      Date: Activities.randTime, 
                                      location: "Keat Hong Community Club", host: "Traveller Pte Ltd", 
                                      description: "Full day tour in Johor Bahru. Lunch and Dinner included."),
                             
                             Activity(title: "Cooking Class", category: Category.dining, cost: 10, 
                                      Date: Activities.randTime, 
                                      location: "Yishun Community Club", host: "Chef Alex Wong", 
                                      description: "Learn how to cook traditional Cantonese dishes!"),
                             
                             Activity(title: "NTUC Income Run", category: Category.sports, cost: 0, 
                                      Date: Activities.randTime, 
                                      location: "Singapore Padang", host: "NTUC Income", 
                                      description: "Join us for a 5km walk/run. Free for all pioneers. Goodie bag included."),
                             
                             Activity(title: "NDP Rehearsal", category: Category.celebration, cost: 5, 
                                      Date: Activities.randTime, 
                                      location: "Various CC", host: "nil", 
                                      description: "View the rehearsal of NDP2017! Limited tickets. Transport provided"),
                             
                             Activity(title: "Mahjong night", category: Category.boardGame, cost: 0, 
                                      Date: Activities.randTime, 
                                      location: "Choa Chu Kang Community Club", host: "nil", 
                                      description: "Join us for a night of fun! Limited signups."),
                             
                             Activity(title: "Farm-hopping tour", category: Category.travel, cost: 10, 
                                      Date: Activities.randTime, 
                                      location: "Bedok Community Club", host: "Travellog Pte Ltd", 
                                      description: "Visit Singapore countryside! Fully guided tour and lunch provided"),]
}
