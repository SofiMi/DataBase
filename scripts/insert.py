import psycopg2

def insert(first, second):
  record_to_insert = (first, second)
  cursor.execute(postgres_insert_query, record_to_insert)
  connection.commit()
  count = cursor.rowcount
  print(f"Insert value ({first}, {second})")

try:
    connection = psycopg2.connect(user="postgres",
                                  password="postgres",
                                  host="127.0.0.1",
                                  port="5432",
                                  database="pg_db")
    cursor = connection.cursor()
    postgres_insert_query = """ insert into pr.similar_genres (first_genre, second_genre) values (%s, %s)"""

    for i in range(1, 27):
      insert(i, i)
    
    components = [[4, 13, 14, 15, 16, 17, 18], [19, 20, 21, 22, 23, 24, 25]]

    for component in components:
      for i in component:
        for j in component:
          if (i != j):
            insert(i, j)
          

except (Exception, psycopg2.Error) as error:
    print("Failed to insert record into table", error)

finally:
    # closing database connection.
    if connection:
        cursor.close()
        connection.close()
        print("PostgreSQL connection is closed")