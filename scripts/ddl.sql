CREATE SCHEMA pr;

CREATE TABLE pr.user (
    userid integer NOT NULL PRIMARY KEY,
    name character varying(100) NOT NULL,
    country character varying(100) NOT NULL,
    region character varying(100) NOT NULL,
	datebirth timestamp without time zone NOT NULL,
    starttime timestamp without time zone NOT NULL
);

CREATE TABLE pr.group (
    groupid integer NOT NULL PRIMARY KEY,
    name character varying(100) NOT NULL,
	datestart timestamp without time zone NOT NULL,
    exist bool NOT NULL
);

CREATE TABLE pr.performer (
	perfid integer NOT NULL PRIMARY KEY,
    name character varying(100) NOT NULL,
	country character varying(100) NOT NULL,
	datebirth timestamp without time zone NOT NULL
);

CREATE TABLE pr.genre (
	genreid integer NOT NULL PRIMARY KEY,
	name character varying(100) NOT NULL
);

CREATE TABLE pr.performer_in_group (
	perfid integer NOT NULL,
	groupid integer NOT NULL,
    valid_from timestamp without time zone NOT NULL,
	valid_to timestamp without time zone NOT NULL,
		FOREIGN KEY (perfid) REFERENCES pr.performer(perfid),
		FOREIGN KEY (groupid) REFERENCES pr.group(groupid)
);

CREATE TABLE pr.album (
	albumid integer NOT NULL PRIMARY KEY,
	groupid integer NOT NULL,
    name character varying(100) NOT NULL,
	add_date timestamp without time zone NOT NULL,
	release_date timestamp without time zone NOT NULL,
		FOREIGN KEY (groupid) REFERENCES pr.group(groupid)
);

CREATE TABLE pr.similar_genres (
	first_genre integer NOT NULL,
	second_genre integer NOT NULL,
		FOREIGN KEY (first_genre) REFERENCES pr.genre(genreid),
		FOREIGN KEY (second_genre) REFERENCES pr.genre(genreid)
);

CREATE TABLE pr.song (
	songid integer NOT NULL PRIMARY KEY,
	albumid integer NOT NULL,
	genreid integer NOT NULL,
	name character varying(200) NOT NULL,
	duration integer NOT NULL,
		FOREIGN KEY (albumid) REFERENCES pr.album(albumid),
		FOREIGN KEY (genreid) REFERENCES pr.genre(genreid)
);

CREATE TABLE pr.view (
	viewid integer NOT NULL PRIMARY KEY,
	userid integer NOT NULL,
	songid integer NOT NULL,
	date timestamp without time zone NOT NULL,
	like_exist bool NOT NULL,
		FOREIGN KEY (songid) REFERENCES pr.song(songid),
		FOREIGN KEY (viewid) REFERENCES pr.view(viewid)
);