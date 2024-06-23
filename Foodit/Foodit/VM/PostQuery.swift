//
//  PostQuery.swift
//  Foodit
//
//  Created by Woody on 6/23/24.
//

import SwiftUI // for UIImage
import SQLite3

// Protocol 대신해줄 Observar => ObservableObject
class PostQuery: ObservableObject{
    // SQLite3
    var db: OpaquePointer? // pointer
    var post: [Post] = []
    
    // 없다면 Create query
    init(){
        // userDomainMask = 이 app의 home directory
        // .appending(path: 파일명)
        let fileURL = try! FileManager.default.url(
            for: .documentDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: false).appendingPathComponent("postList.sqlite")
        
        // percent 글자 = 한글
        // c 언어 포인터로 쓰는 방법이라 &db<&의 역할 주소 연산자(위치)>라고 사용한다
        if sqlite3_open(fileURL.path(percentEncoded: true), &db) != SQLITE_OK {
            print("error opening database")
        }
        
        let createTableQuery = """
        CREATE TABLE IF NOT EXISTS post(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            newAddress TEXT,
            oldAddress TEXT,
            phone TEXT,
            operationTime TEXT,
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
    func searchDB() -> [Post]{
        var stmt: OpaquePointer?
        let queryString = "SELECT * FROM post ORDER BY date DESC"
        
        // 에러가 발생하는지 확인하기 위해서 if문 사용
        // -1 unlimit length 데이터 크기를 의미한다
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK {
            let errMsg = String(cString: sqlite3_errmsg(db)!)
            print("error creating table\ncode : \(errMsg)")
        }
        
        // 불러올 데이터가 있다면 불러온다.
        while(sqlite3_step(stmt) == SQLITE_ROW) {
            let id = Int(sqlite3_column_int(stmt, 0))
            let name = String(cString: sqlite3_column_text(stmt, 1))
//            let newAddress = String(cString: sqlite3_column_text(stmt, 2))
//            let oldAddress = String(cString: sqlite3_column_text(stmt, 3))
//            let phone = String(cString: sqlite3_column_text(stmt, 4))
//            let operationTime = String(cString: sqlite3_column_text(stmt, 5))
            let date = String(cString: sqlite3_column_text(stmt, 6))
            let review = String(cString: sqlite3_column_text(stmt, 7))
            let category = String(cString: sqlite3_column_text(stmt, 8))
//            let lat = Double(sqlite3_column_int(stmt, 9))
//            let lng = Double(sqlite3_column_int(stmt, 10))
            
            var image: UIImage = UIImage()
            // Blob 이미지를 UIImage로 만들기
            if let blobImg = sqlite3_column_blob(stmt, 11) {
                let blobImgLength = sqlite3_column_bytes(stmt, 11)
                let img = Data(bytes: blobImg, count: Int(blobImgLength))
                image = UIImage(data: img)!
            }
            
            post.append(Post(id: id, name: name, date: date, review: review, category: category, image: image))
//            post.append(Post(id: id, name: name, newAddress: newAddress, oldAddress: oldAddress, phone: phone, operationTime: operationTime, date: date, review: review, category: category, lat: lat, lng: lng, image: image))
        }
        return post
    }
    
    
    // insert
    func insertDB(name: String, date: String, review: String, category: String, image: UIImage) -> Bool{
        var stmt: OpaquePointer?
        
        // 2 bytes의 코드를 쓰는 곳에서 사용함 (한글)
        // -1 unlimit length 데이터 크기를 의미한다
        let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
        let queryString = "INSERT INTO post (name, date, review, category, image) VALUES (?,?,?,?,?)"
        
        sqlite3_prepare(db, queryString, -1, &stmt, nil)
        
        // insert 실행
        // type이 text이기 때문에 bind_text 타입 잘 확인
        sqlite3_bind_text(stmt, 1, name, -1, SQLITE_TRANSIENT)
        sqlite3_bind_text(stmt, 2, date, -1, SQLITE_TRANSIENT)
        sqlite3_bind_text(stmt, 3, review, -1, SQLITE_TRANSIENT)
        sqlite3_bind_text(stmt, 4, category, -1, SQLITE_TRANSIENT)
        
        // c로 짜여진 방법이기 때문에 NSData alias 설정 0.4는 크기
        let blobImg = image.jpegData(compressionQuality: 0.4)! as NSData
        sqlite3_bind_blob(stmt, 5, blobImg.bytes, Int32(blobImg.length), SQLITE_TRANSIENT)
        
        
        if sqlite3_step(stmt) == SQLITE_DONE {
            return true
        } else {
            print("실패")
            return false
        }
    }
    
    
    // update query
//    newAddress: String, oldAddress: String, phone: String, operationTime: String,
    //lat: Double, lng: Double,
    func updateDB(name: String, date: String, review: String, category: String, image: UIImage, id: Int) -> Bool{
        var stmt: OpaquePointer?
        
        // 2 bytes의 코드를 쓰는 곳에서 사용함 (한글)
        // -1 unlimit length 데이터 크기를 의미한다
        let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
        let queryString = "UPDATE post SET name = ?, date = ?, review = ?, category = ?, image = ? WHERE id = ?"
        
//        newAddress = ?, oldAddress = ?, phone = ?, operationTime = ?,
//        lat = ?, lng = ?,
        
        sqlite3_prepare(db, queryString, -1, &stmt, nil)
        
        // insert 실행
        // type이 text이기 때문에 bind_text 타입 잘 확인
        sqlite3_bind_text(stmt, 1, name, -1, SQLITE_TRANSIENT)
//        sqlite3_bind_text(stmt, 2, newAddress, -1, SQLITE_TRANSIENT)
//        sqlite3_bind_text(stmt, 3, oldAddress, -1, SQLITE_TRANSIENT)
//        sqlite3_bind_text(stmt, 4, phone, -1, SQLITE_TRANSIENT)
//        sqlite3_bind_text(stmt, 5, operationTime, -1, SQLITE_TRANSIENT)
        sqlite3_bind_text(stmt, 2, date, -1, SQLITE_TRANSIENT)
        sqlite3_bind_text(stmt, 3, review, -1, SQLITE_TRANSIENT)
        sqlite3_bind_text(stmt, 4, category, -1, SQLITE_TRANSIENT)
//        sqlite3_bind_double(stmt, 8, Double(Int32(lat)))
//        sqlite3_bind_double(stmt, 9, Double(Int32(lng)))
        
        let blobImg = image.jpegData(compressionQuality: 0.4)! as NSData
        sqlite3_bind_blob(stmt, 5, blobImg.bytes, Int32(blobImg.length), SQLITE_TRANSIENT)
        
        sqlite3_bind_int(stmt, 6, Int32(id))
        
        if sqlite3_step(stmt) == SQLITE_DONE {
            return true
        } else {
            print("실패")
            return false
        }
    }
    
    // delete query
    func deleteDB(id: Int) -> Bool{
        var stmt: OpaquePointer?
        
        // 2 bytes의 코드를 쓰는 곳에서 사용함 (한글)
        // -1 unlimit length 데이터 크기를 의미한다
//        let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
        let queryString = "DELETE FROM post WHERE id = ?"
        
        sqlite3_prepare(db, queryString, -1, &stmt, nil)
        
        // insert 실행
        // type이 text이기 때문에 bind_text 타입 잘 확인
        sqlite3_bind_int(stmt, 1, Int32(id))
        
        
        if sqlite3_step(stmt) == SQLITE_DONE {
            return true
        } else {
            print("실패")
            return false
        }
    }
}
