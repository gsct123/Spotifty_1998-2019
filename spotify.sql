CREATE TABLE public.info (
    artist VARCHAR(255),
    song VARCHAR(255),
    duration_ms INT,
    explicit BOOLEAN,
    year INT,
    popularity INT,
    danceability FLOAT,
    energy FLOAT,
    key INT,
    loudness FLOAT,
    mode INT,
    speechiness FLOAT,
    acousticness FLOAT,
    instrumental FLOAT,
    liveness FLOAT,
    valence FLOAT,
    tempo FLOAT,
    genre VARCHAR(255)
);

-- General exploration
SELECT * FROM info

--Average duration of songs
SELECT AVG(duration_ms) AS avg_duration 
FROM info;

--Maximum and minimum popularity
SELECT MAX(popularity) AS max_popularity, MIN(popularity) AS min_popularity FROM public.info;

--Average danceability, energy, loudness, etc.
SELECT AVG(danceability) AS avg_danceability, AVG(energy) AS avg_energy, AVG(loudness) AS avg_loudness
FROM info;

-- Top 20 song by popularity 
SELECT song, popularity 
FROM info 
ORDER BY popularity DESC 
LIMIT 20;

-- Top 20 artist by popularity 
SELECT artist, popularity
FROM (
SELECT artist, popularity,
ROW_NUMBER() OVER (PARTITION BY artist ORDER BY popularity DESC) AS rnk
FROM info
) AS RankedInfo
WHERE rnk = 1
ORDER BY popularity DESC
LIMIT 20; 


-- Explicit % 
SELECT explicit, COUNT(*) AS count
FROM info 
GROUP BY explicit; 
--Most songs are suitable for children

-- popularity count 
SELECT popularity, COUNT(*) AS occurrence_count
FROM info
GROUP BY popularity
ORDER BY popularity ASC; 
-- 123 songs have 0 popularity 
-- Most songs have a popularity between 57 - 79


-- danceability count 
SELECT danceability, COUNT(*) AS occurrence_count
FROM info
GROUP BY danceability
ORDER BY danceability ASC;

-- Which year has the most popular song released in 
SELECT year, AVG(popularity) AS avg_popularity
FROM info
GROUP BY year
ORDER BY year;
-- Peak avh popularity was 70% in 2018


-- Which genre is most common 
SELECT genre, COUNT(*) AS genre_count
FROM info
GROUP BY genre
ORDER BY genre_count DESC; 
-- Pop, Hip-Hop, R&B, Dance/ELectronic is the most common in this dataset 

-- Which top 10 genre are popular 
SELECT genre, AVG(popularity) AS avg_popularity
FROM public.info
GROUP BY genre
ORDER BY avg_popularity DESC
LIMIT 10;

-- Top 10 artist with the highest avg popularity
SELECT artist, AVG(popularity) AS avg_popularity
FROM info
GROUP BY artist
ORDER BY avg_popularity DESC
LIMIT 10;

-- Which top 10 songs/genre are the most danceable 
SELECT artist, song, danceability, genre
FROM info
ORDER BY danceability DESC
LIMIT 10;
-- Pop, hip-hop, Dance/Electronic and R&B are the most danceable genre

-- Which top 10 songs/genre are the most speechiness 
SELECT artist, song, speechiness, genre
FROM info
ORDER BY speechiness DESC
LIMIT 10;
-- Pop, hip-hop and R&B are the most speechiness genre


-- Which genre has the loudest music on avg
SELECT genre, AVG(loudness) AS average_loudness, COUNT(*) AS song_count
FROM info
GROUP BY genre
ORDER BY average_loudness DESC;

-- Which genre's songs tend to be performed live 
SELECT genre, AVG(liveness) AS avg_liveness
FROM info
GROUP BY genre
ORDER BY avg_liveness DESC;


-- Which genre of music tend to be upbeat and positive 
SELECT genre,AVG(valence) AS avg_valence, AVG(energy) AS avg_energy
FROM info
GROUP BY genre
ORDER BY avg_valence, avg_energy;

-- Artist Popularity Over Time
SELECT artist, year, AVG(popularity) AS avg_popularity
FROM info
GROUP BY artist, year
ORDER BY artist, year;

-- Artist with the most songs released 
SELECT artist, COUNT(*) AS songs_released 
FROM info
GROUP BY artist
ORDER BY songs_released DESC;

-- Which artist is the popular for each year and what was their best song
WITH ranked_artists AS (
SELECT artist,song,popularity,year,
ROW_NUMBER() OVER (PARTITION BY year ORDER BY popularity DESC) AS rank
FROM info)
SELECT artist, song AS most_popular_song, popularity, year
FROM ranked_artists
WHERE rank = 1;

-- Get the most popular genre for each year
WITH ranked_genres AS (
SELECT genre,popularity,year,
ROW_NUMBER() OVER (PARTITION BY year ORDER BY popularity DESC) AS rank
FROM info
)
SELECT genre, popularity,year
FROM ranked_genres
WHERE rank = 1;

-- How many explicit and non-explicit songs were relased each year 
SELECT 
    year,
    SUM(CASE WHEN explicit = TRUE THEN 1 ELSE 0 END) AS explicit_songs,
    SUM(CASE WHEN explicit = FALSE THEN 1 ELSE 0 END) AS non_explicit_songs
FROM info
GROUP BY year
ORDER BY year;