/* SELECT */
/* 1) Узнаем количество пользователей.*/
select count(userid) as count from pr.user;

/* 2) Вывести пользователей из России.*/
select name from pr.user
where country = 'Pocсия'
order by name;

/* 3) Вывести исполнителей группы 'The Beatles'.*/
select name from pr.performer
where perfid in (select perfid from pr.performer_in_group
				 where groupid in (select groupid from pr.group
								   where name = 'The Beatles'
								  )
				)
order by name;

/* 4) Вывести песни из альбома 'Immortalized'.*/
select name from pr.song
where albumid in (select albumid from pr.album
				  where name = 'Immortalized'
				)
order by name;

/* 5) Вывести группы, которые еще выступают.*/
select name from pr.group
where exist
order by name;

/* 6) Вывести жанры, похожие на рок.*/
with similar_g as (select second_genre from pr.similar_genres
				 	where first_genre in (select genreid from pr.genre
										  where name = 'рок'
										  )
				  )
select name from similar_g
left join pr.genre
on similar_g.second_genre = pr.genre.genreid;

/* 7) Вывести названия групп, которые появлись после 1990 года*/
select name from pr.group
where datestart > timestamp '1990-01-01 00:00:00';


/* 8) Вывести названия альбомов, которые были выпущены между 1970 и 1990 годами. */
select name from pr.album
where release_date between timestamp '1970-01-01 00:00:00' and timestamp '1990-01-01 00:00:00';

/* 9) Вывести информацию об исполнителе 'Джордж Харрисон' */
select * from pr.performer
where name = 'Джордж Харрисон';

/* 10) Узнать, кто написал песню 'Smells Like Teen Spirit'*/
select name from pr.group
where groupid in (select groupid from pr.album
				          where albumid in (
					  				  select albumid from pr.song
					  				  where name = 'Smells Like Teen Spirit'
				  				                 )
				         );



/*UPDATE*/
/*1*/
update pr.user
set name = 'Александра Гордеева'
where userid = 1;

/*2*/
update pr.user
set country = 'Россия'
where userid = 7 or userid = 10;

/*3*/
update pr.user
set datebirth = '2000-01-01 00:00:00'
where datebirth > '2000-01-01 00:00:00';

/*4*/
update pr.user
set datebirth = '1975-01-01 00:00:00'
where datebirth between '1975-01-01 00:00:00' and '2000-01-01 00:00:00';

/*5*/
update pr.user
set country = 'Российская Федерация'
where country = 'Россия';

/*6*/
update pr.user
set userid = 20
where name = 'Александра Гордеева';

/*7*/
update pr.user
set country = 'Not Found'
where length(country) > 50;

/*8*/
update pr.similar_genres
set first_genre = 1, second_genre = 2
where first_genre = 8 and second_genre = 9;

/*9*/
update pr.similar_genres
set second_genre = 3
where first_genre = 9;

/*10*/
update pr.album
set name = 'Good name'
where name = 'Bad name';


/*DELETE*/
delete from pr.user where userid between 18 and 20; /*1*/
delete from pr.user where datebirth < '1935-01-01 00:00:00'; /*2*/
delete from pr.user where datebirth > '2020-01-01 00:00:00'; /*3*/
delete from pr.user where country = 'Not Found'; /*4*/
delete from pr.user where length(country) < 5; /*5*/
delete from pr.song where duration < 60; /*6*/
delete from pr.song where genreid = 18; /*7*/
delete from pr.album where add_date < release_date; /*8*/
delete from pr.similar_genres where first_genre = 1 and second_genre = 2; /*9*/
delete from pr.performer_in_group where valid_from > valid_to /*10*/