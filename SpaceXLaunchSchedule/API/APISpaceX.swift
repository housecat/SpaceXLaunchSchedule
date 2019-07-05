//
//  APISpaceX.swift
//  SpaceXLaunchSchedule
//
//  Created by Mikhail Kouznetsov on 7/5/19.
//  Copyright © 2019 Mikhail Kouznetsov. All rights reserved.
//

import Foundation
import Alamofire

class APISpaceX{
    static var shared = APISpaceX()
    private let launchesURL:URL = URL(string: "https://api.spacexdata.com/v3/launches/upcoming")!
    private let nextMissionURL:URL = URL(string: "https://api.spacexdata.com/v3/launches/next")!
    
    func getUpcomingLaunces( complete: @escaping (Launches?, Error?) -> Void){
        request(launchesURL).responseData { response in
            guard let data = response.data, response.result.isSuccess == true else {
                complete(nil, response.error)
                return
            }
            
            let launches = try? JSONDecoder().decode(Launches.self, from: data)
            complete(launches, nil)
        }
    }
    
    func nextMission(  complete: @escaping (LaunchElement?, Error?) -> Void){
        request(nextMissionURL).responseData { response in
            guard let data = response.data, response.result.isSuccess == true else {
                complete(nil, response.error)
                return
            }
            
            let launch = try? JSONDecoder().decode(LaunchElement.self, from: data)
            complete(launch, nil)
        }
    }
}

