//
//  FileUtils.swift
//  AgroPartnerships
//
//  Created by Kanyinsola Fapohunda on 05/08/2019.
//  Copyright © 2019 AgroPartnerships. All rights reserved.
//

import Foundation

class FileUtils {
    
    static func readHTMLResourceFile(fileName: String) -> String {
        AgroLogger.log("readHTMLResourceFile \(fileName)")
        var html = ""
        if let htmlPathURL = Bundle.main.url(forResource: fileName,
            withExtension: "html"){
            AgroLogger.log("Bundle.main.url \(htmlPathURL)")

            do {
                html = try String(contentsOf: htmlPathURL, encoding: .utf8)
            } catch  {
                AgroLogger.log("Unable to get the file.")
            }
        } else {
            AgroLogger.log("Couldn't find the file.")
        }
        return html
    }
}
