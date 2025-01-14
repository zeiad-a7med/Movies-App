//
//  DBManager.swift
//  ScrollView
//
//  Created by Zeiad on 12/01/2025.
//

import Foundation
import SQLite3

class DBManager {
    private var myDB: OpaquePointer?
    static let shared = DBManager()
    private init() {
        print("this is a private init")
        myDB = self.createDatabase(dbName: DBName)
        createTable(createTableString: DBMoviesTableCreationQuery)
    }

    //    func createDatabase(dbName: String?) -> OpaquePointer? {
    //        var db: OpaquePointer?
    //        guard let dbPath = dbName else {
    //            print("part1DbPath is nil.")
    //            return nil
    //        }
    //        if sqlite3_open(dbPath, &db) == SQLITE_OK {
    //            print("Successfully opened connection to database at \(dbPath)")
    //            return db
    //        } else {
    //            print("Unable to open database.")
    //            return nil
    //        }
    //    }
    func createDatabase(dbName: String?) -> OpaquePointer? {
        var db: OpaquePointer?
        guard let dbName = dbName else {
            print("Database name is nil.")
            return nil
        }

        // Get the path to the app's Documents directory
        let fileManager = FileManager.default
        let documentsDirectory = try? fileManager.url(
            for: .documentDirectory, in: .userDomainMask, appropriateFor: nil,
            create: true)
        guard
            let dbPath = documentsDirectory?.appendingPathComponent(dbName).path
        else {
            print("Failed to construct the database path.")
            return nil
        }

        // Open or create the database file at the specified path
        if sqlite3_open(dbPath, &db) == SQLITE_OK {
            print("Successfully opened connection to database at \(dbPath)")
            return db
        } else {
            print("Unable to open database.")
            return nil
        }
    }

    func createTable(createTableString: String?) {
        // 1
        var createTableStatement: OpaquePointer?
        // 2
        if sqlite3_prepare_v2(
            myDB, createTableString, -1, &createTableStatement, nil)
            == SQLITE_OK
        {
            // 3
            if sqlite3_step(createTableStatement) == SQLITE_DONE {
                print("\nContact table created.")
            } else {
                print("\nContact table is not created.")
            }
        } else {
            print("\nCREATE TABLE statement is not prepared.")
        }
        // 4
        sqlite3_finalize(createTableStatement)
    }

    func insert(movie: Movie) {

        var insertStatement: OpaquePointer?
        let insertStatementString =
            "INSERT INTO movies (title, image, rating, releaseYear, genre) VALUES (?, ?, ?, ?, ?);"
        if sqlite3_prepare_v2(
            myDB, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK
        {

            let title: NSString
            let image: NSString

            if movie.title != nil {
                title = movie.title! as NSString
            } else {
                title = "" as NSString
            }
            if movie.image != nil {
                image = movie.image! as NSString
            } else {
                image = "" as NSString
            }
            let rating: Double = Double(movie.rating ?? 0)
            let releaseYear: Int32 = Int32(movie.releaseYear ?? 0)
            let genre: NSString = movie.genre.joined(separator: ",") as NSString

            sqlite3_bind_text(insertStatement, 1, title.utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 2, image.utf8String, -1, nil)
            sqlite3_bind_double(insertStatement, 3, rating)
            sqlite3_bind_int(insertStatement, 4, releaseYear)
            sqlite3_bind_text(insertStatement, 5, genre.utf8String, -1, nil)

            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("\nSuccessfully inserted row.")
            } else {
                print("\nCould not insert row.")
            }
        } else {
            print("\nINSERT statement is not prepared.")
        }
        // 5
        sqlite3_finalize(insertStatement)
    }
    func getAllMovies() -> [Movie] {
        let queryStatementString = "SELECT * FROM movies;"
        var queryStatement: OpaquePointer?
        var movies: [Movie] = []
        if sqlite3_prepare_v2(
            myDB, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK
        {

            while sqlite3_step(queryStatement) == SQLITE_ROW {

                let id = sqlite3_column_int(queryStatement, 0)
                guard let titleDB = sqlite3_column_text(queryStatement, 1)
                else {
                    return []
                }
                let title = String(cString: titleDB)

                guard let imageDB = sqlite3_column_text(queryStatement, 2)
                else {
                    return []
                }
                let image = String(cString: imageDB)

                let rating = sqlite3_column_double(queryStatement, 3)
                let releaseYear = sqlite3_column_int(queryStatement, 4)

                guard let genreDB = sqlite3_column_text(queryStatement, 5)
                else {
                    return []
                }
                let genre = String(cString: genreDB)
                var genreList: [String] = []

                if genre.contains(",") {
                    genreList = genre.split(separator: ",") as! [String]
                } else {
                    genreList.append(genre)
                }
                let movie = Movie(
                    id: Int(id), title: title, image: image, rating: rating,
                    releaseYear: Int(releaseYear), genre: genreList)
                movies.append(movie)
            }

        } else {
            // 6
            let errorMessage = String(cString: sqlite3_errmsg(myDB))
            print("\nQuery is not prepared \(errorMessage)")
        }
        sqlite3_finalize(queryStatement)
        return movies
    }

    func delete(movieId : Int) {
        var deleteStatement: OpaquePointer?
        let deleteStatementString = "DELETE FROM movies WHERE Id = \(movieId);"
        if sqlite3_prepare_v2(
            myDB, deleteStatementString, -1, &deleteStatement, nil) == SQLITE_OK
        {
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print("\nSuccessfully deleted row.")
            } else {
                print("\nCould not delete row.")
            }
        } else {
            print("\nDELETE statement could not be prepared")
        }

        sqlite3_finalize(deleteStatement)
    }

    deinit {
        sqlite3_close(myDB)
    }
}
