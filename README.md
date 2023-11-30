# Squadcast-Data-Analysis-and-Manipulation
Repository for Take-home Assignment of Squadcast Data Analysis and Manipulation

## Assumption 
1. The movies and ratings data from the CSV files (Provided by your side) are cleaned.
2. 'id' is primary key column for movies table.
3. 'movie_id' is foreign key column of ratings table reference to 'id' key column of movies table
4. The movies and ratings data from the CSV files are in denormalized form.
5. seperator - ',' [comma]
6. Quote - '""' [Double inverted comma]
7. Header is present in the csv file.
8. Data types for movies table -->
   id [Integer] :: title [Text] :: year [Integer] :: country [Text] :: genre [Text] :: director [Text] :: minutes [Integer] :: poster [Text]
9. Data types for movies table-->
   rater_id [Integer] :: movie_id [Integer] :: ranting [Integer] :: time [Integer]


