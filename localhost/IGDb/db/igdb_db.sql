--
-- PostgreSQL database dump
--

-- Dumped from database version 9.5.14
-- Dumped by pg_dump version 9.5.14

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: igdb; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA igdb;


ALTER SCHEMA igdb OWNER TO postgres;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: ban_list; Type: TABLE; Schema: igdb; Owner: postgres
--

CREATE TABLE igdb.ban_list (
    user_id integer NOT NULL
);


ALTER TABLE igdb.ban_list OWNER TO postgres;

--
-- Name: games; Type: TABLE; Schema: igdb; Owner: postgres
--

CREATE TABLE igdb.games (
    game_id serial,
    title character varying(30),
    genre character varying(30),
    publisher character varying(30),
    release_date date,
    description character varying,
    img_url character varying,
    avg_score integer default 0
);


ALTER TABLE igdb.games OWNER TO postgres;

--
-- Name: library; Type: TABLE; Schema: igdb; Owner: postgres
--

CREATE TABLE igdb.library (
    user_id integer NOT NULL,
    game_id integer NOT NULL,
    category integer NOT NULL,
    unique (user_id, game_id)
);


ALTER TABLE igdb.library OWNER TO postgres;

--
-- Name: reviews; Type: TABLE; Schema: igdb; Owner: postgres
--

CREATE TABLE igdb.reviews (
    review_id serial,
    user_id integer NOT NULL,
    game_id integer NOT NULL,
    game_review character varying,
    recommend boolean NOT NULL,
    review_date date,
		upvote integer default 0,
		downvote integer default 0
);


ALTER TABLE igdb.reviews OWNER TO postgres;

--
-- Name: users; Type: TABLE; Schema: igdb; Owner: postgres
--

CREATE TABLE igdb.users (
    user_id serial,
    name character varying(30),
    email character varying(30),
    password character varying(30),
    avatar character varying default '../resources/avatars/default.png'
);


ALTER TABLE igdb.users OWNER TO postgres;

--
-- Name: game_view_store; Type: View; Schema: -; Owner: postgres
--
CREATE VIEW igdb.game_view_store AS 
	SELECT g.*, (SELECT COUNT(*) FROM igdb.library l WHERE l.game_id = g.game_id)  as total_added FROM igdb.games g;

--
-- Name: users_ID_seq; Type: SEQUENCE; Schema: igdb; Owner: postgres
--

CREATE SEQUENCE igdb."users_ID_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE igdb."users_ID_seq" OWNER TO postgres;

--
-- Name: users_ID_seq; Type: SEQUENCE OWNED BY; Schema: igdb; Owner: postgres
--

ALTER SEQUENCE igdb."users_ID_seq" OWNED BY igdb.users.user_id;


--
-- Name: id; Type: DEFAULT; Schema: igdb; Owner: postgres
--

ALTER TABLE ONLY igdb.users ALTER COLUMN user_id SET DEFAULT nextval('igdb."users_ID_seq"'::regclass);


--
-- Data for Name: ban_list; Type: TABLE DATA; Schema: igdb; Owner: postgres
--

COPY igdb.ban_list (user_id) FROM stdin;
\.


--
-- Data for Name: games; Type: TABLE DATA; Schema: igdb; Owner: postgres
--

COPY igdb.games (title, genre, publisher, release_date, description, img_url) FROM stdin;
minecraft	adventure	xzy	5-2-2000	creative game for kids	../resources/test/game1.jpg;
minecraft2	adventure	xzy	2-3-2000	creative game for kids	../resources/test/game2.png;
minecraft3	adventure	xzy	4-4-2000	creative game for kids	../resources/test/game3.jpg;
minecraft4	adventure	xzy	3-5-2000	creative game for kids	../resources/test/game1.jpg;
minecraft5	adventure	xzy	1-6-2000	creative game for kids	../resources/test/game2.png;
minecraft6	adventure	xzy	1-7-2000	creative game for kids	../resources/test/game3.jpg;
\.


--
-- Data for Name: library; Type: TABLE DATA; Schema: igdb; Owner: postgres
--

COPY igdb.library (user_id, game_id, category) FROM stdin;
14	1	1
14	2	3
14	3	3
14	4	2
1	1	1
2	1	2
3	2	2
\.


--
-- Data for Name: reviews; Type: TABLE DATA; Schema: igdb; Owner: postgres
--

COPY igdb.reviews (user_id, game_id, game_review, recommend, review_date) FROM stdin;
2	1	this game is so addictive!!	TRUE	1-1-2019
4	1	I know right?	TRUE	1-15-2019
5	1	No this game sucks. Boring. Waste my time.	FALSE	1-16-2019
14	1	I know right?	TRUE	1-15-2019
14	2	No this game sucks. Boring. Waste my time.	FALSE	1-16-2019
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: igdb; Owner: postgres
--

COPY igdb.users (name, email, password) FROM stdin;
Admin	admin@gmail.com	fl4g_1s_H3Re
User1	user1@gmail.com	User1P4SS
User2	user2@gmail.com	User2P4SS
User3	user3@gmail.com	User3P4SS
User4	user4@gmail.com	User4P4SS
User5	user5@gmail.com	User5P4SS
User6	user6@gmail.com	User6P4SS
User7	user7@gmail.com	User7P4SS
User8	user8@gmail.com	User8P4SS
User9	user9@gmail.com	User9P4SS
User10	user10@gmail.com	User10P4SS
User11	user11@gmail.com	user11
User12	user12@gmail.com	User12P4SS
test1	test1@gmail.com	123
\.


--
-- Name: users_ID_seq; Type: SEQUENCE SET; Schema: igdb; Owner: postgres
--

SELECT pg_catalog.setval('igdb."users_ID_seq"', 17, true);


--
-- Name: games_pkey; Type: CONSTRAINT; Schema: igdb; Owner: postgres
--

ALTER TABLE ONLY igdb.games
    ADD CONSTRAINT games_pkey PRIMARY KEY (game_id);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: igdb; Owner: postgres
--

ALTER TABLE ONLY igdb.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (user_id);

--
-- Name: reviews_pkey; Type: CONSTRAINT; Schema: igdb; Owner: postgres
--

ALTER TABLE ONLY igdb.reviews
    ADD CONSTRAINT reviews_pkey PRIMARY KEY (review_id);

--
-- Name: banList_userID_fkey; Type: FK CONSTRAINT; Schema: igdb; Owner: postgres
--

ALTER TABLE ONLY igdb.ban_list
    ADD CONSTRAINT "banList_userID_fkey" FOREIGN KEY (user_id) REFERENCES igdb.users(user_id);


--
-- Name: gameid-fkey; Type: FK CONSTRAINT; Schema: igdb; Owner: postgres
--

ALTER TABLE ONLY igdb.library
    ADD CONSTRAINT "gameid-fkey" FOREIGN KEY (game_id) REFERENCES igdb.games(game_id);


--
-- Name: gameid-fkey; Type: FK CONSTRAINT; Schema: igdb; Owner: postgres
--

ALTER TABLE ONLY igdb.reviews
    ADD CONSTRAINT "gameid-fkey" FOREIGN KEY (game_id) REFERENCES igdb.games(game_id);


--
-- Name: library_UserID_fkey; Type: FK CONSTRAINT; Schema: igdb; Owner: postgres
--

ALTER TABLE ONLY igdb.library
    ADD CONSTRAINT "library_UserID_fkey" FOREIGN KEY (user_id) REFERENCES igdb.users(user_id);


--
-- Name: reviews_userID_fkey; Type: FK CONSTRAINT; Schema: igdb; Owner: postgres
--

ALTER TABLE ONLY igdb.reviews
    ADD CONSTRAINT "reviews_userID_fkey" FOREIGN KEY (user_id) REFERENCES igdb.users(user_id);


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;

--
-- PostgreSQL database dump complete
--
