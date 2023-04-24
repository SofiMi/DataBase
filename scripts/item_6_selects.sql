/* Осмысленные select-запросы */
/* 
1) Вывести первых 5 подключившихся пользователей. Отсортировать по времени подключения, а в случае равенства - по имени.
*/
with rank_ as ( select name, starttime, rank() OVER (order by starttime) as rank
				from pr.user
			  )
select * from rank_
where rank < 6
order by rank, name;

/* 
2) Вывести для каждого пользователя, сколько песен он прослушал, а также их общую длительность (в секундах).
Отсортировать пользователей по убыванию количества прослушанных песен, имени.
*/

with views_with_duration as (
								select userid, viewid, duration
	  								from pr.view
								left join pr.song
	   							on pr.view.songid = pr.song.songid
							),
	 count_songs as (
					 			select userid, count(viewid) as count_songs, sum(duration) as duration
	                 				from views_with_duration
					 			group by userid
					)
select rank() over (order by count_songs desc),
	   name, count_songs, duration
from pr.user
right join count_songs
on pr.user.userid = count_songs.userid
order by rank, name;

/*
3) Вывести названия песен и их продолжительность,
название и общую длительность альбома,
процент, который составляет песня от альбома.
*/

select pr.song.name as name_song, pr.album.name as name_album, duration as duration_songs,
	   sum(duration) over (PARTITION BY pr.song.albumid) as duration_album,
	   duration * 100 / sum(duration) over (PARTITION BY pr.song.albumid) as procent
from pr.song
left join pr.album
on pr.song.albumid = pr.album.albumid;

/*
4) Вывести информацию о пользователях, которые слушают более 2 (бд маленькая) различных исполнителей.
Отсортировать по id.
*/

with views_with_album as (	select userid, pr.view.songid, albumid as albumid from pr.view
						  	left join pr.song
						  	on pr.view.songid = pr.song.songid
						 ),
	views_with_group as (	select distinct userid, groupid as groupid from views_with_album
						  	left join pr.album
						  	on pr.album.albumid = views_with_album.albumid
						 ),
	count_groups as 	( select userid, count(groupid) as count
							from views_with_group
							group by userid
							having count(groupid) > 2
						)

select count_groups.userid as id, name, country, region, datebirth, starttime
from count_groups
left join pr.user
on count_groups.userid = pr.user.userid
order by id

/*
5) Вывести для альбомов общую длительность прослушиваний песен из них.
Для каждого из них также вывести также песню с наибольшей продолжительностью прослушиваний.
*/

with views_with_duration as (
								select pr.view.songid as songid, albumid, duration
	  								from pr.view
								left join pr.song
	   							on pr.view.songid = pr.song.songid
							),
	group_by_songs as (
								select songid, max(albumid) as albumid, sum(duration) as duration
									from views_with_duration
								group by songid
					  	)
select distinct name,
		sum(duration) over (partition by group_by_songs.albumid) as sum_durations,
		first_value(duration) over
			(partition by group_by_songs.albumid order by duration desc) as song_max_duration
from group_by_songs
left join pr.album
on pr.album.albumid = group_by_songs.albumid
order by sum_durations desc;


/*
6) Вывести рекомендации пользователю с id = 1 по следующему алгоритму
  - найти песни, которым пользователь поставил лайк
  - определить жанры, к которомым относятся песни
  - вывести все песни, с жанрами похожими на те, что получены выше
	- отсортировать их по популярности (количеству прослушиваний) и названию
*/
with user_like as (
					select songid from pr.view
					where userid = 1 and likes = True
				  ),
	user_new_songs as (
					select songid, name from pr.song
					where genreid in (
									 select distinct second_genre from pr.similar_genres
									 where first_genre in ( select genreid from user_like
										   					left join pr.song
										  					on user_like.songid = pr.song.songid
										 				  )
					  				)
					),
	count_views as (
					select songid, count(*) as count
					from pr.view
		  			group by songid
				   ), 
	user_new_songs_count as (
					select user_new_songs.songid, name, count
					from user_new_songs
					right join count_views
		 			on user_new_songs.songid = count_views.songid
	)
select name, count from user_new_songs_count
order by count desc, name