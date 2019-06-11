--
-- Data for Name: games; Type: TABLE DATA; Schema: igdb; Owner: postgres
--

COPY igdb.games (title, genre, publisher, release_date, description, img_url) FROM stdin;
minecraft	adventure	xzy	1-1-2000	creative game for kids	../resources/test/game1.jpg;
minecraft2	adventure	xzy	1-1-2000	creative game for kids	../resources/test/game2.png;
minecraft3	adventure	xzy	1-1-2000	creative game for kids	../resources/test/game3.jpg;
minecraft4	adventure	xzy	1-1-2000	creative game for kids	../resources/test/game1.jpg;
minecraft5	adventure	xzy	1-1-2000	creative game for kids	../resources/test/game2.png;
minecraft6	adventure	xzy	1-1-2000	creative game for kids	../resources/test/game3.jpg;
\.

--
-- Data for Name: library; Type: TABLE DATA; Schema: igdb; Owner: postgres
--

-- COPY igdb.library (user_id, game_id, category) FROM stdin;
-- 14	10	1
-- 14	11	3
-- 14	12	2
-- 14	13	4
-- \.

--
-- Data for Name: reviews; Type: TABLE DATA; Schema: igdb; Owner: postgres
--

COPY igdb.reviews (user_id, game_id, game_review, recommend, review_date) FROM stdin;
14	11	I know right?	TRUE	1-15-2019
14	12	No this game sucks. Boring. Waste my time.	FALSE	1-16-2019
\.



