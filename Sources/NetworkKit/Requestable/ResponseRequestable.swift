//
//  ResponseRequestable.swift
//  
//
//  Created by Mahmoud Alaa on 9/12/23.
//

import Foundation

public
protocol ResponseRequestable: Requestable {
    associatedtype Response
    
    var responseDecoder: ResponseDecoder { get }
}
