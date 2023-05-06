/* 
  Подсчитывает количество просмотров в указанный промежуток времени.
  В случае невозможного промежутка выбрасывает исключение.
*/
create or replace function number_of_views_in_period(start_time timestamp, end_time timestamp) 
 returns bigint as $$
DECLARE 
 count_views integer;
 begin	
	if start_time > end_time then
        raise exception 'Некорректный ввод данных: start_time должен быть не больше end_time!';
    end if;
	
	select count(viewid) into strict count_views from pr.view
	where date between start_time and end_time;
 
 return count_views;
 end;
$$ language plpgsql;

/*
  По имени человека возвращает пользовался ли он приложением за последние 7 дней. 
*/
create or replace function used_or_not(user_name character varying(100)) 
 returns bool as $$
 DECLARE 
 count_line integer;
 count_views bigint;
 begin
    select count(pr.user.userid) INTO STRICT count_line from pr.user
    where pr.user.name = user_name;
	
	if count_line = 0 then
        raise exception 'Такого пользователя не существует!';
    end if;
	
	select count(viewid) into strict count_views from pr.view
	where date > date(now()) - INTERVAL '7 days';
 return count_views > 0;
 end;
$$ language plpgsql;