
-- Creating the movies table in public schema by defining the proper column name, its datatype and constraints

CREATE TABLE "public".movies
(id INT PRIMARY KEY,
title TEXT,
year INT,
country TEXT,
genre TEXT,
director TEXT,
minutes INT,
poster TEXT
);

--Ingested data manually from the movies.csv file. 

--Checking the movies table properly created and data from the movies.csv file added successfully.
SELECT * FROM movies;

-- Creating the ratings table in public schema by defining the proper column name, its datatype and constraints
CREATE TABLE "public".ratings
(rater_id INT,
movie_id INT REFERENCES movies(id),
rating INT,
time INT
);

--Ingested data manually from the ratings.csv file. 

--Checking the ratings table properly created and data from the ratings.csv file added successfully.
SELECT * FROM ratings;




-- Top 5 Movie Titles based on Duration

SELECT title, minutes
FROM movies 
ORDER BY minutes DESC
LIMIT 5;
--Explanation --> Sorted the table by decreasing the order of duration of movies and setting the limit up to 5 


-- Top 5 Movie Titles based on Year of Release
SELECT title, year
FROM movies 
ORDER BY year DESC
LIMIT 5;
--Explanation --> Sorted the table by decreasing the order of year of movies and setting the limit up to 5 


-- Top 5 Movie Titles based on Average rating (consider movies with minimum 5 ratings)
SELECT title, ROUND(AVG(rating),2) AS Average_rating
FROM movies As m
LEFT JOIN ratings AS r
ON m.id = r.movie_id
WHERE rating >= 5
GROUP BY title
ORDER BY AVG(rating) DESC
LIMIT 5;
--Explanation --> Join the movies table and rating table based on the primary and foreign keys, using WHERE clouse condition on 'movies with minimum 5 ratings' then using the GROUP BY clause to get a avarage of ratings based on the title. Then Sorted the table by decreasing the order of the avarage of ratings and setting the limit up to 5 


-- Top 5 Movie Titles based on Number of ratings given
SELECT title, COUNT(rating) AS No_of_ratings
FROM movies As m
LEFT JOIN ratings AS r
ON m.id = r.movie_id
GROUP BY title
ORDER BY COUNT(rating) DESC
LIMIT 5;
--Explanation --> Join the movies table and rating table based on the primary and foreign keys, using the GROUP BY clause to get a total count of ratings based on the title. Then Sorted the table by decreasing the order of the total count of ratings and setting the limit up to 5

-- Number of Unique Raters:
SELECT COUNT(DISTINCT rater_id) AS No_of_unique_raters FROM ratings;
--Explanation --> Select the distinct count of rater_id from the ratings table

-- Top 5 Rater IDs based on Most movies rated
SELECT rater_id, count(movie_id) AS count_of_movies
FROM ratings
GROUP BY rater_id
ORDER BY count(movie_id) DESC
LIMIT 5;
--Explanation --> using the GROUP BY clause to get a total count_of_movies based on the rater_id. Then Sorted the table by decreasing the order of a total count_of_movies and setting the limit up to 5


-- Top 5 Rater IDs based on Highest Average rating given (consider raters with min 5 ratings)
SELECT rater_id, ROUND(AVG(rating),2) AS avarage_rating
FROM ratings
WHERE rating >= 5
GROUP BY rater_id
ORDER BY AVG(rating) DESC
LIMIT 5;
--Explanation --> Using WHERE clouse condition on 'movies with minimum 5 ratings' then using the GROUP BY clause to get a avarage_rating based on the rater_id. Then Sorted the table by decreasing the order of a avarage_rating and setting the limit up to 5


-- Top Rated Movie by Director 'Michael Bay'
SELECT title, COUNT(rating) AS No_of_ratings
FROM  movies
LEFT JOIN ratings
ON movie_id = id
WHERE director LIKE '%Michael Bay%'
GROUP BY title
ORDER BY COUNT(rating) DESC
LIMIT 1;
--Explanation --> Join the movies table and rating table based on the primary and foreign keys, Using WHERE clouse condition that director column contain 'Michael Bay', then using the GROUP BY clause to get a No_of_ratings based on the title. Then Sorted the table by decreasing the order of a No_of_ratings and setting the limit up to 1


-- Top Rated Movie by 'Comedy'
SELECT title, COUNT(rating) AS No_of_ratings
FROM  movies
LEFT JOIN ratings
ON movie_id = id
WHERE genre LIKE '%Comedy%' 
GROUP BY title
ORDER BY COUNT(rating) DESC
LIMIT 1;
--Explanation --> Join the movies table and rating table based on the primary and foreign keys, Using WHERE clouse condition that genre column contain 'Action', then using the GROUP BY clause to get a No_of_ratings based on the title. Then Sorted the table by decreasing the order of a No_of_ratings and setting the limit up to 1


-- Top Rated Movie In the year 2013
SELECT title, COUNT(rating) AS No_of_ratings
FROM  movies
LEFT JOIN ratings
ON movie_id = id
WHERE year = 2013 
GROUP BY title
ORDER BY COUNT(rating) DESC
LIMIT 1;
--Explanation --> Join the movies table and rating table based on the primary and foreign keys, Using WHERE clouse condition that year = 2013, then using the GROUP BY clause to get a No_of_ratings based on the title. Then Sorted the table by decreasing the order of a No_of_ratings and setting the limit up to 1


-- Top Rated Movie In India (consider movies with a minimum of 5 ratings).
SELECT title, COUNT(rating) AS No_of_ratings
FROM  movies
LEFT JOIN ratings
ON movie_id = id
WHERE country LIKE '%India%'  AND rating >= 5
GROUP BY title
ORDER BY COUNT(rating) DESC
LIMIT 1;
--Explanation --> Join the movies table and rating table based on the primary and foreign keys, Using WHERE clouse condition that country column contain 'India' with a minimum of 5 ratings, then using the GROUP BY clause to get a No_of_ratings based on the title. Then Sorted the table by decreasing the order of a No_of_ratings and setting the limit up to 1


--Favorite Movie Genre of Rater ID 1040 (defined as the genre of the movie the rater has rated most often).
SELECT  genre , COUNT(rating) AS No_of_ratings
FROM ratings 
LEFT JOIN movies
ON id = movie_id
WHERE rater_id = 1040 
GROUP BY  genre
ORDER BY COUNT(rating) DESC
LIMIT 1;
--Explanation --> Join the movies table and rating table based on the primary and foreign keys, Using WHERE clause condition rater_id = 1040, then using the GROUP BY clause to get a No_of_ratings based on the genre. Then Sorted the table by decreasing the order of a No_of_ratings and setting the limit up to 1


--The highest average rating for a movie genre given by the rater with ID 1040 (consider genres with a minimum of 5 ratings).
SELECT  genre , ROUND(AVG(rating),2) AS avarage_rating
FROM ratings 
LEFT JOIN movies
ON id = movie_id
WHERE rater_id = 1040 AND rating >= 5
GROUP BY  genre
ORDER BY AVG(rating) DESC
LIMIT 1;
--Explanation --> Join the movies table and rating table based on the primary and foreign keys, Using WHERE clause condition rater_id = 1040  with a minimum of 5 ratings, then using the GROUP BY clause to get a avarage_rating based on the genre. Then Sorted the table by decreasing the order of a avarage_rating and setting the limit up to 1


--The year with the second-highest number of action movies from the USA that received an average rating of 6.5 or higher and had a runtime of less than 120 minutes.
WITH rank_table AS
(SELECT year, ROUND(AVG(rating),2) AS Average_rating, 
 DENSE_RANK() OVER(ORDER BY AVG(rating)DESC) AS rank
FROM ratings
LEFT JOIN movies
ON id = movie_id
WHERE genre LIKE '%Action%'AND country LIKE '%USA%' AND minutes < 120
GROUP BY year
HAVING AVG(rating) >= 6.5)

SELECT year, Average_rating FROM rank_table
WHERE rank = 2
/* Explanation --> First create a temporary table 'rank_table'.
Join the movies table and rating table based on the primary and foreign keys, 
Using the WHERE clause condition genre contains 'Action' and the country contains 'USA' and minutes < 120, 
then using the GROUP BY clause to get a avarage_rating based on the year.
used window function DENSE_RANK() to get dense rank column over average rating in descending order.

Then query 'rank_table' using WHERE clouse condition rank = 2 (i.e second-highest number)
*/



--the number of movies that have received at least five reviews with a rating of 7 or higher.
WITH high_rating_movie AS
(SELECT movie_id, COUNT(rater_id) AS no_of_raters
FROM movies
LEFT JOIN ratings
ON id = movie_id
WHERE rating >= 7
GROUP BY movie_id
HAVING COUNT(rater_id) >= 5)

SELECT COUNT(movie_id) AS No_of_movie FROM high_rating_movie

/* Explanation --> First create a temporary table 'high_rating_movie'.
Join the movies table and rating table based on the primary and foreign keys, 
Using WHERE clause condition rating >= 7, 
then using the GROUP BY clause to get a no_of_raters based on the movie_id.
Then used the HAVING clause to filter out the aggregate function such that at least 5 no of raters (number of movies that have received at least five reviews)

Then query 'high_rating_movie' to get the total number of movies by counting movied_id













