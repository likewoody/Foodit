//
//  MapDetailQuery.swift
//  Foodit
//
//  Created by Woody on 6/24/24.
//

import SQLite3
import Foundation
import UIKit

class MapDetailQuery: ObservableObject {
    // SQLite3
    var db: OpaquePointer? // pointer
    var mapDetail: [MapDetailModel] = []
    
    // 없다면 Create query
    init(){
        // userDomainMask = 이 app의 home directory
        // .appending(path: 파일명)
        let fileURL = try! FileManager.default.url(
            for: .documentDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: false).appendingPathComponent("sqlitePost.sqlite")
        
        // percent 글자 = 한글
        // c 언어 포인터로 쓰는 방법이라 &db<&의 역할 주소 연산자(위치)>라고 사용한다
        if sqlite3_open(fileURL.path(percentEncoded: true), &db) != SQLITE_OK {
            print("error opening database")
        }
        
        let createTableQuery = """
        CREATE TABLE IF NOT EXISTS post(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            address TEXT,
            date TEXT,
            review TEXT,
            category TEXT,
            lat REAL,
            lng REAL,
            image BLOB
        )
        """
        // Table 만들기
        // DOUBLE 대신에 => REAL 사용
        if sqlite3_exec(db, createTableQuery, nil, nil, nil) != SQLITE_OK {
            // error message c언어 스트링
            let errMsg = String(cString: sqlite3_errmsg(db)!)
            print("error creating table\ncode : \(errMsg)")
        }
    }
    
    // search Query
    // SwiftUI에서는 Protocol 사용 대신에 SearchQuery에서 [Student] type으로 바로 return 해준다.
    // 작업처리가 몇번 덜 움직이기 때문에 효율적이다.
    func searchDB(id: Int) -> [MapDetailModel]{
        var stmt: OpaquePointer?
        let queryString = "SELECT name, address, category, review, date, image FROM post WHERE id = ?"
        
        // 에러가 발생하는지 확인하기 위해서 if문 사용
        // -1 unlimit length 데이터 크기를 의미한다
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK {
            let errMsg = String(cString: sqlite3_errmsg(db)!)
            print("error creating table\ncode : \(errMsg)")
        }
        
        // WHERE 조건 검색
        sqlite3_bind_int(stmt, 1, Int32(id))
        
        // Data Search
        while(sqlite3_step(stmt) == SQLITE_ROW) {
            let name = String(cString: sqlite3_column_text(stmt, 0))
            let address = String(cString: sqlite3_column_text(stmt, 1))
            let category = String(cString: sqlite3_column_text(stmt, 2))
            let review = String(cString: sqlite3_column_text(stmt, 3))
            let date = String(cString: sqlite3_column_text(stmt, 4))
            
            var image: UIImage = UIImage()
            // Blob 이미지를 UIImage로 만들기
            if let blobImg = sqlite3_column_blob(stmt, 5) {
                let blobImgLength = sqlite3_column_bytes(stmt, 5)
                let img = Data(bytes: blobImg, count: Int(blobImgLength))
                image = UIImage(data: img)!
            }
            
            mapDetail.append(MapDetailModel(name: name, address: address, category: category, review: review, date: date, image: image))
        }
        return mapDetail
    }
}
