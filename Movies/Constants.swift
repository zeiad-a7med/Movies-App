//
//  Constants.swift
//  Movies
//
//  Created by Zeiad on 14/01/2025.
//

let DBName : String = "movies.sqlite"
let DBMoviesTableCreationQuery = """
create table movies(
id INTEGER primary key AUTOINCREMENT not null,
title text,
image text,
rating real,
releaseYear int,
genre text
)
"""
