-- List each pair of actors that have worked together.
WITH cte_pairs_of_actors as
 (SELECT 
        fa.actor_id, 
        a.first_name, 
        a.last_name, 
        fa.film_id, 
        f.title
    FROM sakila.actor a 
    INNER JOIN sakila.film_actor fa ON a.actor_id = fa.actor_id
    INNER JOIN sakila.film f ON fa.film_id = f.film_id
    )
SELECT 
CONCAT(A.first_name, ' ', A.last_name) AS actor1,
CONCAT(B.first_name, ' ', B.last_name) AS actor2,
A.title
FROM cte_pairs_of_actors A
INNER JOIN cte_pairs_of_actors B
ON A.film_id = B.film_id
AND A.actor_id < B.actor_id
ORDER BY A.title;


-- For each film, list actor that has acted in more films.
WITH cte_prolific_actors as
 (SELECT 
        f.title,
        fa.film_id,
        concat(a.first_name, ' ', a.last_name) AS actor_name 
	FROM sakila.actor a 
    INNER JOIN sakila.film_actor fa ON a.actor_id = fa.actor_id
    INNER JOIN sakila.film f ON fa.film_id = f.film_id)
SELECT distinct film_id, title, actor_name, film_count
FROM (
	SELECT *, max(film_count) over (partition by title) as max_film_count
	FROM (
		SELECT *, count(film_id) over (partition by actor_name) as film_count 
		FROM cte_prolific_actors
		ORDER BY film_count) sub1) sub2
WHERE film_count = max_film_count;
