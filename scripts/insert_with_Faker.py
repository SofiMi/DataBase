import psycopg2
from faker import Faker
from random import randrange

def insert(userid, name, country, region, datebirth, starttime):
  postgres_insert_query = """insert into pr.user (userid, name, country, region, datebirth, starttime) values (%s, %s, %s, %s, %s, %s)"""
  record_to_insert = (userid, name, country, region, datebirth, starttime)
  cursor.execute(postgres_insert_query, record_to_insert)
  connection.commit()
  count = cursor.rowcount
  print(f"Insert value ({userid}, {name}, {country}, {region}, {datebirth}, {starttime})")

if __name__ == '__main__':
  faker_insert = Faker('ru_RU')
  Faker.seed(40)

  try:
    connection = psycopg2.connect(user="postgres",
                                  password="postgres",
                                  host="127.0.0.1",
                                  port="5432",
                                  database="pg_db")
    cursor = connection.cursor()

    print(randrange(10))

    # Faker выдает очень много различных стран и регионов
    # это неудобно для аналитики
    # поэтому выделим несколько классов сами
    country_list = ['Азербайджан', 'Армения', 'Беларусь', 'Казахстан', 'Молдова', 'Россия']
    region_list = [['Бабекский', 'Джульфинский', 'Кенгерлинский', 'Нахичевань', 'Ордубадский'],
                   ['Армавирский', 'Ширакский', 'Арагацотнский', 'Гехаркуникский', 'Котайкский', 'Вайоцдзорский'],
                   ['Брестская', 'Витебская', 'Гомельская', 'Гродненская', 'Минская', 'Могилёвская'],
                   ['Акмолинская', 'Алматинская', 'Актюбинская', 'Восточно-Казахстанская', 'Атырауская', 'Жамбылская'],
                   ['АТО Гагаузия', 'Глодянский район', 'Дрокиевский район', 'Единецкий район', 'Кагульский район', 'Каларашский район'],
                   ['Московская область', 'Краснодарский край','Санкт-Петербург', 'Свердловская область', 'Ростовская область']
                  ]

    for i in range(20, 2000):
      name = faker_insert.name()
      datebirth = faker_insert.date_time_between(start_date='-50y', end_date='-10y')
      starttime = faker_insert.date_time_between(start_date='-1y', end_date='now')

      rand_int = randrange(len(country_list))
      country = country_list[rand_int]
      region = region_list[rand_int][randrange(len(region_list[rand_int]))]
      insert(i, name, country, region, datebirth, starttime)
    
  except (Exception, psycopg2.Error) as error:
    print("Failed to insert record into table", error)

  finally:
    # closing database connection.
    if connection:
        cursor.close()
        connection.close()
        print("PostgreSQL connection is closed")