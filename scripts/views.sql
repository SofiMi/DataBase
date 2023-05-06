/* Views с соединением нескольких таблиц*/

/* Информация о названии альбома и группы для каждой песни.
  (Название песни, название альбома, название группы)
*/

create or replace view songs_info as
select pr.song.name as song, pr.album.name as album, pr.group.name as group
from pr.song
	join pr.album on pr.song.albumid = pr.album.albumid
	join pr.group on pr.album.groupid = pr.group.groupid


/* Дата прослушивания и названия песен из альбома 'Immortalized'
  (Название песни, дата)
*/

create or replace view immortalized_views as
select pr.song.name as name, pr.view.date as date
from pr.view
	join pr.song on pr.song.songid = pr.view.songid
	join pr.album on pr.song.albumid = pr.album.albumid
where pr.album.name = 'Immortalized'


/* Для исполнителей показывает жанры, в которых они исполняют.
   Если один исполнитель пел в разных жанрах, то каждый из них будет
   в новой строке.
*/
create or replace view performers_genre as
with album_genre as (
	select pr.song.albumid, pr.genre.name from pr.song
	join pr.genre on pr.song.genreid = pr.genre.genreid
)
select DISTINCT pr.performer.name as name, album_genre.name as genre
from pr.performer
	join pr.performer_in_group on pr.performer_in_group.perfid = pr.performer.perfid
	join pr.group on pr.performer_in_group.groupid = pr.group.groupid
	join pr.album on pr.album.groupid = pr.group.groupid
	join album_genre on pr.album.albumid = album_genre.albumid


/* Для исполнителей указать последнюю группу, в которой они состояли/состоят.
*/
create or replace view performers_in_group as
with with_date as (
	select pr.performer_in_group.valid_to, pr.performer.name as name, pr.group.name as group_
	from pr.performer_in_group
		join pr.performer on pr.performer_in_group.perfid = pr.performer.perfid
		join pr.group on pr.performer_in_group.groupid = pr.group.groupid
     ), 
	 with_row as (select *, row_number() over (partition by name order by valid_to desc) as rn
				  from with_date)
select name, group_ as group from with_row 
where rn = 1;

/* Views с сокрытием данных*/

/* Представление с информацией о пользователях кроме имени (данные скрыты).
   Может быть необходимо для аналитики групп пользователей, которые используют приложение.
*/
create or replace view users as
select CONCAT(SUBSTRING(name, 1, 1), '...') as name, country, region, datebirth, starttime from pr.user


/* Регион, дата рождения и количество прослушанных песен пользователями, именна которых скрытых.
   Может быть необходимо для аналитики, какие пользователи чаще слушают музыку в данном приложении.
*/
create or replace view users_views as
with song_us as (
	select CONCAT(SUBSTRING(pr.user.name, 1, 1), '...') as name, pr.user.region, pr.user.datebirth, pr.view.songid from pr.user
	join pr.view on pr.view.userid = pr.user.userid
    )
select name, max(region) as region, max(datebirth) as datebirth, count(songid) as count_songs from song_us
group by name