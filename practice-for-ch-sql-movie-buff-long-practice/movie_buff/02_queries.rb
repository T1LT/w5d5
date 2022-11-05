def eighties_b_movies
  # List all the movies from 1980-1989 with scores falling between 3 and 5
  # (inclusive). Show the id, title, year, and score.
  Movie.select(:id, :title, :yr, :score).where("(yr between 1980 AND 1989)
    AND (score BETWEEN 3 AND 5)")
  
end

def bad_years
  # List the years in which no movie with a rating above 8 was released.
  
  # Movie.find_by_sql(<<-SQL)
  #   SELECT 
  #     DISTINCT(yr) 
  #   FROM 
  #     movies 
  #   WHERE yr IN (
  #     SELECT yr
  #     FROM movies
  #     GROUP BY yr
  #     HAVING MAX(score) < 8
  #   )
  # SQL

  Movie
    .group(:yr)
    .having("MAX(score) < 8").distinct.pluck(:yr)


end

def cast_list(title)
  # List all the actors for a particular movie, given the title.
  # Sort the results by starring order (ord). Show the actor id and name.
  Actor.select(:id, :name).joins(:movies).where("movies.title = (?)", title).order("castings.ord")
  
end

def vanity_projects
  # List the title of all movies in which the director also appeared as the
  # starring actor. Show the movie id, title, and director's name.

  # Note: Directors appear in the 'actors' table.
  Movie
    .select("movies.id, title, actors.name")
    .joins(:actors)
    .where("movies.director_id = actors.id AND castings.ord = 1")
  
end

def most_supportive
  # Find the two actors with the largest number of non-starring roles.
  # Show each actor's id, name, and number of supporting roles.
  # group by:
  # anything in select needs to show up in the group by or be an aggregate
  Casting
    .select("actors.id, actors.name, COUNT('actors.id') as roles")
    .joins(:actor)
    .where("castings.ord != 1")
    .group("actors.id, actors.name")
    .order("roles DESC")
    .limit(2)

  # to get largest non-starring roles 
  # get each actor id and check against castings table
  # and then in the castings table check if ord != 1 and count those
  # order by count
  # Actor.select("actors.id, actors.name, count(castings.ord) as roles")
  #   .joins(:castings)
  #   .where('castings.ord != 1')
  #   .group(:id)
  #   .order('count(castings.ord) desc')
  #   .limit(2)
end