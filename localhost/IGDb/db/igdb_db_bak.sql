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
    "UserID" integer NOT NULL
);


ALTER TABLE igdb.ban_list OWNER TO postgres;

--
-- Name: games; Type: TABLE; Schema: igdb; Owner: postgres
--

CREATE TABLE igdb.games (
    "ID" integer NOT NULL,
    "Title" character varying(30),
    "Genre" character varying(30),
    "Publisher" character varying(30),
    "Release date" date,
    "Game cover" character varying,
    "img-url" character varying
);


ALTER TABLE igdb.games OWNER TO postgres;

--
-- Name: library; Type: TABLE; Schema: igdb; Owner: postgres
--

CREATE TABLE igdb.library (
    "UserID" integer NOT NULL,
    "GameID" integer NOT NULL
);


ALTER TABLE igdb.library OWNER TO postgres;

--
-- Name: reviews; Type: TABLE; Schema: igdb; Owner: postgres
--

CREATE TABLE igdb.reviews (
    "UserID" integer NOT NULL,
    "GameID" integer NOT NULL,
    "GameReview" character varying,
    "GameScore" integer,
    "ReviewDate" date
);


ALTER TABLE igdb.reviews OWNER TO postgres;

--
-- Name: users; Type: TABLE; Schema: igdb; Owner: postgres
--

CREATE TABLE igdb.users (
    "Name" character varying(30),
    "Email" character varying(30),
    "Password" character varying(30),
    "ID" integer NOT NULL
);


ALTER TABLE igdb.users OWNER TO postgres;

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

ALTER SEQUENCE igdb."users_ID_seq" OWNED BY igdb.users."ID";


--
-- Name: ID; Type: DEFAULT; Schema: igdb; Owner: postgres
--

ALTER TABLE ONLY igdb.users ALTER COLUMN "ID" SET DEFAULT nextval('igdb."users_ID_seq"'::regclass);


--
-- Data for Name: ban_list; Type: TABLE DATA; Schema: igdb; Owner: postgres
--

COPY igdb.ban_list ("UserID") FROM stdin;
\.


--
-- Data for Name: games; Type: TABLE DATA; Schema: igdb; Owner: postgres
--

COPY igdb.games ("ID", "Title", "Genre", "Publisher", "Release date", "Game cover", "img-url") FROM stdin;
\.


--
-- Data for Name: library; Type: TABLE DATA; Schema: igdb; Owner: postgres
--

COPY igdb.library ("UserID", "GameID") FROM stdin;
\.


--
-- Data for Name: reviews; Type: TABLE DATA; Schema: igdb; Owner: postgres
--

COPY igdb.reviews ("UserID", "GameID", "GameReview", "GameScore", "ReviewDate") FROM stdin;
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: igdb; Owner: postgres
--

COPY igdb.users ("Name", "Email", "Password", "ID") FROM stdin;
\.


--
-- Name: users_ID_seq; Type: SEQUENCE SET; Schema: igdb; Owner: postgres
--

SELECT pg_catalog.setval('igdb."users_ID_seq"', 1, false);


--
-- Name: games_pkey; Type: CONSTRAINT; Schema: igdb; Owner: postgres
--

ALTER TABLE ONLY igdb.games
    ADD CONSTRAINT games_pkey PRIMARY KEY ("ID");


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: igdb; Owner: postgres
--

ALTER TABLE ONLY igdb.users
    ADD CONSTRAINT users_pkey PRIMARY KEY ("ID");


--
-- Name: banList_userID_fkey; Type: FK CONSTRAINT; Schema: igdb; Owner: postgres
--

ALTER TABLE ONLY igdb.ban_list
    ADD CONSTRAINT "banList_userID_fkey" FOREIGN KEY ("UserID") REFERENCES igdb.users("ID");


--
-- Name: gameid-fkey; Type: FK CONSTRAINT; Schema: igdb; Owner: postgres
--

ALTER TABLE ONLY igdb.library
    ADD CONSTRAINT "gameid-fkey" FOREIGN KEY ("GameID") REFERENCES igdb.games("ID");


--
-- Name: gameid-fkey; Type: FK CONSTRAINT; Schema: igdb; Owner: postgres
--

ALTER TABLE ONLY igdb.reviews
    ADD CONSTRAINT "gameid-fkey" FOREIGN KEY ("GameID") REFERENCES igdb.games("ID");


--
-- Name: library_UserID_fkey; Type: FK CONSTRAINT; Schema: igdb; Owner: postgres
--

ALTER TABLE ONLY igdb.library
    ADD CONSTRAINT "library_UserID_fkey" FOREIGN KEY ("UserID") REFERENCES igdb.users("ID");


--
-- Name: reviews_userID_fkey; Type: FK CONSTRAINT; Schema: igdb; Owner: postgres
--

ALTER TABLE ONLY igdb.reviews
    ADD CONSTRAINT "reviews_userID_fkey" FOREIGN KEY ("UserID") REFERENCES igdb.users("ID");


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

