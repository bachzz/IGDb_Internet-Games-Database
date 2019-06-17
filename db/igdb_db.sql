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
SET datestyle = "ISO, DMY";


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
    title character varying,
    genre character varying,
    publisher character varying,
    release_date date,
    description character varying,
    img_url character varying,
    avg_score float default 0
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
    name character varying,
    email character varying,
    password character varying,
    avatar character varying default '../resources/avatars/default.png'
);


ALTER TABLE igdb.users OWNER TO postgres;

--
-- Name: game_view_store; Type: View; Schema: -; Owner: postgres
--
CREATE VIEW igdb.game_view_store AS 
	SELECT g.*, (SELECT COUNT(*) FROM igdb.library l WHERE l.game_id = g.game_id)  as total_added FROM igdb.games g;




--trigger for calculating avg_score

CREATE or REPLACE function igdb.tg_af_insert_review() returns trigger as 
$$
DECLARE 
    pos_review float := 0;
    total_review float := 0;
BEGIN
    SELECT INTO pos_review count(*) FROM igdb.reviews
    WHERE game_id = NEW.game_id and recommend = 'true';
    SELECT INTO total_review count(*) FROM igdb.reviews WHERE game_id = NEW.game_id;
    UPDATE igdb.games 
        SET avg_score = ( 10 * pos_review ) / total_review
        WHERE game_id = NEW.game_id;
    RETURN NEW;
END;
$$
language plpgsql;


create trigger af_insert_review
    after insert on igdb.reviews
    for each row
    when (NEW.review_id is not null)
    execute procedure igdb.tg_af_insert_review();

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
Metal Gear Solid V: The Phantom Pain	Action	Konami	1/9/2015	Ushering in a new era for the METAL GEAR franchise with cutting-edge technology powered by the Fox Engine, METAL GEAR SOLID V: The Phantom Pain, will provide players a first-rate gaming experience as they are offered tactical freedom to carry out open-world missions.	https://steamcdn-a.akamaihd.net/steam/apps/287700/header.jpg?t=1535525516;https://steamcdn-a.akamaihd.net/steam/apps/287700/ss_258e5c725ba2da8a2fc2ee779ae75ba4b0aac0c6.600x338.jpg?t=1535525516;https://steamcdn-a.akamaihd.net/steam/apps/287700/ss_d4c1b17dad6eeeef8e1ade44a66d8e644afcc4e6.600x338.jpg?t=1535525516;https://steamcdn-a.akamaihd.net/steam/apps/287700/ss_969065fca2ad4538c2e7ed5d8bbd91cbd060cf47.600x338.jpg?t=1535525516;https://steamcdn-a.akamaihd.net/steam/apps/287700/ss_9c92ce8b9809a3f0b5b2316b7146684eabab07d3.600x338.jpg?t=1535525516;https://steamcdn-a.akamaihd.net/steam/apps/287700/ss_208e1d631754733bf659f6d454121de773ca34ba.600x338.jpg?t=1535525516;https://steamcdn-a.akamaihd.net/steam/apps/287700/ss_8d3e8949591899054dc0ae7e56dc04ddab5ba7b5.600x338.jpg?t=1535525516;
Nier: Automata	Action	Platinum Games	23/2/2017	NieR: Automata tells the story of androids 2B, 9S and A2 and their battle to reclaim the machine-driven dystopia overrun by powerful machines.	https://steamcdn-a.akamaihd.net/steam/apps/524220/header.jpg?t=1556006070;https://steamcdn-a.akamaihd.net/steam/apps/524220/ss_d0314b4c134329a483b5e43af951f60274abc66b.600x338.jpg?t=1556006070;https://steamcdn-a.akamaihd.net/steam/apps/524220/ss_8b29f7e1ce9a8b9313dc3eb50dbe76a4cf94eef9.600x338.jpg?t=1556006070;https://steamcdn-a.akamaihd.net/steam/apps/524220/ss_2c265df38c3d2d393d74ee8e74d79bdafa16b143.600x338.jpg?t=1556006070;https://steamcdn-a.akamaihd.net/steam/apps/524220/ss_831e0e7c9d514393b711e9ed1d6796042521a80c.600x338.jpg?t=1556006070;https://steamcdn-a.akamaihd.net/steam/apps/524220/ss_e926e3b5d440b4f244525745c7100edc2d717b85.600x338.jpg?t=1556006070;https://steamcdn-a.akamaihd.net/steam/apps/524220/ss_c538e630c5cc224124104cc42ec6220ab90b5852.600x338.jpg?t=1556006070;
Final Fantasy VI	RPG	Square Enix	2/4/1994	The War of Magi left little but ashes and misery in its wake. Even magic itself had vanished from the world. Now, a thousand years later, humankind has remade the world through the power of iron, gunpowder, steam engines, and other machines and technologies.	https://hb.imgix.net/3f2f967fd80a006e59a23c5b5c076a1965ca2d98.jpg?auto=compress,format&fit=crop&h=353&w=616&s=84bfc273d014a2e02f10bfb4564001c4;https://lh3.ggpht.com/e-z2y2kn4AuJ_EbQvc0Lddv38kuEnwR1QfUCT1SHUpffRIGtgeUWU2ld-M-g8kgbLlQ=w1920-h937-rw;https://lh3.ggpht.com/_gauRsVZ7H8XjUfOpy3X1Afkh3r5Qft9eCDW7AANe3Nzv948REq8Yn8XC5FpfSjbMw=w1920-h937-rw;https://lh3.ggpht.com/LD8lCVt0GI3WZHrQL4ewIjd5u7PmVfg2oFrnaJ06Ghg_dTS8TLOqW3oc_-EDW-fnGrQ=w1920-h937-rw;https://lh3.ggpht.com/hrkvA39YrMLqaMY7Hu9Hw00MN5pic1Lq0NGuaXFqCr3C8S173quLA4CnA5pUoBybGJn1=w1920-h937-rw;
Super Smash Brothers Ultimate	Fighting	Nintendo	7/12/2018	The biggest Super Smash Bros. game ever!	https://s3.dexerto.com/thumbnails/_thumbnailLarge/nintendo-switch-super-smash-bros-ultimate-dlc-characters-leaked-surprising-nintendo-direct.jpg;https://timedotcom.files.wordpress.com/2018/12/super-smash-bros-ultimate-review.jpg?quality=85;https://www.syfy.com/sites/syfy/files/styles/1200x680/public/2018/12/supersmashbrosultimatemain.jpg;https://static1.squarespace.com/static/56d5457d8259b57a20245e80/t/5c230c88cd8366c207907c55/1545800882440/Super+Smash+bros+ultimate-smash;
Mario Maker 2	Platformer	Nintendo	28/6/2019	Super Mario Maker 2 is an upcoming side-scrolling platform game and game creation system developed and published by Nintendo for the Nintendo Switch.	https://cdn02.nintendo-europe.com/media/images/10_share_images/games_15/nintendo_switch_4/H2x1_NSwitch_SuperMarioMaker2_image1600w.jpg;https://o.aolcdn.com/images/dims?quality=85&image_uri=https%3A%2F%2Fo.aolcdn.com%2Fimages%2Fdims%3Fcrop%3D1920%252C1080%252C0%252C0%26quality%3D85%26format%3Djpg%26resize%3D1600%252C900%26image_uri%3Dhttps%253A%252F%252Fs.yimg.com%252Fos%252Fcreatr-uploaded-images%252F2019-05%252F2e7f4b40-7764-11e9-afcd-b3fa259ab160%26client%3Da1acac3e1b3290917d92%26signature%3D9659deffba091b10ff61e74f2af51f296ae9b6d2&client=amp-blogside-v2&signature=073d6e8c191e504651ba55a6cf407ffa241b3466;https://s1.gaming-cdn.com/images/products/4485/screenshot/super-mario-maker-2-switch-wallpaper-1.jpg;https://www.dualshockers.com/wp-content/uploads/2019/05/papermario.jpg;https://www.slashgear.com/wp-content/uploads/2019/05/mariooooo-1280x720.jpg;
Dynasty Warriors 8	Action	Koei Tecmo	28/2/2013	Dynasty Warriors 8: Xtreme Legends introduces entirely new levels of fun to the refreshing gameplay vanquishing swarms of enemies with mighty warriors found in Dynasty Warriors 8.	https://steamcdn-a.akamaihd.net/steam/apps/278080/header.jpg?t=1550179201;https://steamcdn-a.akamaihd.net/steam/apps/278080/ss_0404b64be85ab151bb466d601775498aebdf49ef.600x338.jpg?t=1550179201;https://steamcdn-a.akamaihd.net/steam/apps/278080/ss_bfecc04b01651395ea2d1ecb92478bb294e60f1b.1920x1080.jpg?t=1550179201;https://steamcdn-a.akamaihd.net/steam/apps/278080/ss_4688b24539e71f4ec08a6bb913310742b92b45d4.1920x1080.jpg?t=1550179201;https://steamcdn-a.akamaihd.net/steam/apps/278080/ss_6874b06b3f56effa23510e8af4fb866ee3e7266e.1920x1080.jpg?t=1550179201;https://steamcdn-a.akamaihd.net/steam/apps/278080/ss_d27cae3618580db1ec275e3767d5a0e74aeac954.1920x1080.jpg?t=1550179201;
Sekiro: Shadows Die Twice	From Software	Action	22/3/2019	Carve your own clever path to vengeance in an all-new adventure from developer FromSoftware, creators of Bloodborne and the Dark Souls series. Take Revenge. Restore your honor. Kill Ingeniously.	https://steamcdn-a.akamaihd.net/steam/apps/814380/header.jpg?t=1558657225;https://steamcdn-a.akamaihd.net/steam/apps/814380/ss_fb360495e610e44538d38b8b792e1efdf5a730c0.600x338.jpg?t=1558657225;https://steamcdn-a.akamaihd.net/steam/apps/814380/ss_285c1a69bda8182e5c52598d59259f1681b42e5c.600x338.jpg?t=1558657225;https://steamcdn-a.akamaihd.net/steam/apps/814380/ss_552bf9e99b3682d75c01ca4a55ba426e85f3b621.600x338.jpg?t=1558657225;https://steamcdn-a.akamaihd.net/steam/apps/814380/ss_4f21e0652a1a89f0c4fabbd3eae91a1defd23b71.600x338.jpg?t=1558657225;https://steamcdn-a.akamaihd.net/steam/apps/814380/ss_1667ceb9268d0be45d786feecfd8baf28eda9271.600x338.jpg?t=1558657225;
Dark Souls III	Action	From Software	24/3/2016	Dark Souls continues to push the boundaries with the latest, ambitious chapter in the critically-acclaimed and genre-defining series. Prepare yourself and Embrace The Darkness!	https://steamcdn-a.akamaihd.net/steam/apps/374320/header.jpg?t=1553251330;https://steamcdn-a.akamaihd.net/steam/apps/374320/ss_5efd318b85a3917d1c6e717f4cb813b47547cd6f.600x338.jpg?t=1553251330;https://steamcdn-a.akamaihd.net/steam/apps/374320/ss_fe1dc6761a9004aa39c2e6e62181593b7263edf9.600x338.jpg?t=1553251330;https://steamcdn-a.akamaihd.net/steam/apps/374320/ss_27397db724cfd5648655c1056ff5d184147a4c50.600x338.jpg?t=1553251330;https://steamcdn-a.akamaihd.net/steam/apps/374320/ss_27397db724cfd5648655c1056ff5d184147a4c50.600x338.jpg?t=1553251330;https://steamcdn-a.akamaihd.net/steam/apps/374320/ss_975ca4966b9b627f8d9bb0d2c9b6743dfceac6da.600x338.jpg?t=1553251330;
Animal Crossing New Leaf	Casual	Nintendo	8/11/2012	The charming community-building franchise returns for with Animal Crossing: New Leaf.	https://cdn02.nintendo-europe.com/media/images/10_share_images/games_15/nintendo_3ds_25/H2x1_3DS_AnimalCrossingNewLeaf_WelcomeAmiibo.jpg;https://images.igdb.com/igdb/image/upload/t_original/lhuv65udj1opuzueaobj.jpg;https://images.igdb.com/igdb/image/upload/t_original/p6n6ahcrcjjcx8iw6guw.jpg;https://images.igdb.com/igdb/image/upload/t_original/ffpktqsv5kzxktyzpplj.jpg;https://images.igdb.com/igdb/image/upload/t_original/gombdtxpqqgugjr6o6g7.jpg
Risk of Rain 2	Shooter	Hopoo Games	28/3/2019	The classic multiplayer roguelike, Risk of Rain, returns with an extra dimension and more challenging action.	https://steamcdn-a.akamaihd.net/steam/apps/632360/header.jpg?t=1558455404;https://steamcdn-a.akamaihd.net/steam/apps/632360/ss_76082d1683ec86903a7f071181c89ccaf78b857d.600x338.jpg?t=1558455404;https://steamcdn-a.akamaihd.net/steam/apps/632360/ss_ebf09ff83af59cbf2735862d99085f43cf3515cc.600x338.jpg?t=1558455404;https://steamcdn-a.akamaihd.net/steam/apps/632360/ss_85548e86c50ff654c6a49235ea686a956f8ee9ec.600x338.jpg?t=1558455404;https://steamcdn-a.akamaihd.net/steam/apps/632360/ss_5d45a9bd9c2185cf67ab6b72651abcf0019261e1.600x338.jpg?t=1558455404;https://steamcdn-a.akamaihd.net/steam/apps/632360/ss_725d301ba2651921825d23f714a0c103877e03b3.600x338.jpg?t=1558455404;
Enter the Gungeon	Shooter	Devolver	5/4/2016	Enter the Gungeon is a bullet hell dungeon crawler following a band of misfits seeking to shoot, loot, dodge roll and table-flip their way to personal absolution by reaching the legendary Gungeon’s ultimate treasure: the gun that can kill the past.	https://steamcdn-a.akamaihd.net/steam/apps/311690/header.jpg?t=1559393107;https://steamcdn-a.akamaihd.net/steam/apps/311690/ss_9d3f304b18e8cd1cf6ac4a886bec474e0b677800.600x338.jpg?t=1559393107;https://steamcdn-a.akamaihd.net/steam/apps/311690/ss_9d3f304b18e8cd1cf6ac4a886bec474e0b677800.600x338.jpg?t=1559393107;https://steamcdn-a.akamaihd.net/steam/apps/311690/ss_de49a9579b13337e98719d39df0f5bc46b9fe886.600x338.jpg?t=1559393107;https://steamcdn-a.akamaihd.net/steam/apps/311690/ss_ecdf8986898c7d866d419943eb7c7cbef42754bd.600x338.jpg?t=1559393107;https://steamcdn-a.akamaihd.net/steam/apps/311690/ss_0893ef2bd93d4e9e2138006424d088523a5daecd.600x338.jpg?t=1559393107;
Stardew Valley	Casual	ChuckleFish	26/2/1016	You've inherited your grandfather's old farm plot in Stardew Valley. Armed with hand-me-down tools and a few coins, you set out to begin your new life. Can you learn to live off the land and turn these overgrown fields into a thriving home?	https://steamcdn-a.akamaihd.net/steam/apps/413150/header.jpg?t=1560555132;https://steamcdn-a.akamaihd.net/steam/apps/413150/ss_b887651a93b0525739049eb4194f633de2df75be.600x338.jpg?t=1560555132;https://steamcdn-a.akamaihd.net/steam/apps/413150/ss_9ac899fe2cda15d48b0549bba77ef8c4a090a71c.600x338.jpg?t=1560555132;https://steamcdn-a.akamaihd.net/steam/apps/413150/ss_4fa0866709ede3753fdf2745349b528d5e8c4054.600x338.jpg?t=1560555132;https://steamcdn-a.akamaihd.net/steam/apps/413150/ss_d836f0a5b0447fb6a2bdb0a6ac5f954949d3c41e.600x338.jpg?t=1560555132;https://steamcdn-a.akamaihd.net/steam/apps/413150/ss_a3ddf22cda3bd722df77dbdd58dbec393906b654.600x338.jpg?t=1560555132;
Forza Horizon 4	Racing	Microsoft Studio	2/10/2018	Live the Horizon Life when you play Forza Horizon 4. Experience a shared world with dynamic seasons. Explore beautiful scenery, collect over 450 cars and become a Horizon Superstar in historic Britain.	https://steam.cryotank.net/wp-content/gallery/forzahorizon4/Forza-Horizon-4-05-HD.png;http://compass.xboxlive.com/assets/fd/2d/fd2d6947-478f-4544-ae6e-7390474672f4.jpg?n=ForzaHorizon4_E3PressKit_WM_01_ForestTrucks.jpg;http://compass.xboxlive.com/assets/1e/fb/1efbd5c1-48b0-4177-a315-d36ca736fb8d.jpg?n=ForzaHorizon4_E3PressKit_WM_02_SennaAutumn.jpg;http://compass.xboxlive.com/assets/dd/9f/dd9f5de5-ce64-49c1-8393-1784ab146a50.jpg?n=ForzaHorizon4_E3PressKit_WM_03_SnowyTrucks.jpg;http://compass.xboxlive.com/assets/29/ad/29adc13c-2e6c-49c6-9a39-bcaecfd5a159.jpg?n=ForzaHorizon4_E3PressKit_WM_05_SteeringWheelBeauty.jpg;http://compass.xboxlive.com/assets/4d/e1/4de11c70-c185-4396-b11b-13b0ec5e9c77.jpg?n=ForzaHorizon4_E3PressKit_WM_06_BeachBums.jpg;http://compass.xboxlive.com/assets/ed/ec/edecbd5e-4a92-4811-8a84-0fdc6e4baae3.jpg?n=ForzaHorizon4_E3PressKit_WM_07_SennaRear.jpg;
Valkyria Chronicles 4	RPG	Sega	21/3/2018	A Continent Engulfed in the Bitter Flames of War! Commander Claude Wallace and his childhood friends set out to fight in a desperate war, but bone-chilling blizzards, waves of imperial soldiers, and the godlike powers of the Valkyria stand between them and victory.	https://steamcdn-a.akamaihd.net/steam/apps/790820/header.jpg?t=1557999433;https://steamcdn-a.akamaihd.net/steam/apps/790820/ss_7f426c69d4f27dff1e19aea7560c89bc27421104.600x338.jpg?t=1557999433;https://steamcdn-a.akamaihd.net/steam/apps/790820/ss_c1bf93575c5ac6b39d6a7c99f830245b55b3ed8d.600x338.jpg?t=1557999433;https://steamcdn-a.akamaihd.net/steam/apps/790820/ss_20a063ed7ed1cb36b877b0532cc3f2f306ab3ad5.600x338.jpg?t=1557999433;https://steamcdn-a.akamaihd.net/steam/apps/790820/ss_eb0780f959ba11021d961e04fa30a878c656dfc1.600x338.jpg?t=1557999433;https://steamcdn-a.akamaihd.net/steam/apps/790820/ss_1c4e49ff56e3b13e722022c2a4300cdfa296dd1d.600x338.jpg?t=1557999433;
Celeste	Platformer	Matt Makes Games	25/1/2018	Help Madeline survive her inner demons on her journey to the top of Celeste Mountain, in this super-tight platformer from the creators of TowerFall. Brave hundreds of hand-crafted challenges, uncover devious secrets, and piece together the mystery of the mountain.	https://steamcdn-a.akamaihd.net/steam/apps/504230/header.jpg?t=1547237854;https://steamcdn-a.akamaihd.net/steam/apps/504230/ss_03bfe6bd5ddac7f747c8d2aa1a4f82cfd53c6dcb.600x338.jpg?t=1547237854;https://steamcdn-a.akamaihd.net/steam/apps/504230/ss_4b0f0222341b64a37114033aca9994551f27c161.600x338.jpg?t=1547237854;https://steamcdn-a.akamaihd.net/steam/apps/504230/ss_1012b11ad364ad6c138a25a654108de28de56c5f.600x338.jpg?t=1547237854;https://steamcdn-a.akamaihd.net/steam/apps/504230/ss_832ef0f27c3d6efdaa4b5d1cc896dce0999bc9e8.600x338.jpg?t=1547237854;https://steamcdn-a.akamaihd.net/steam/apps/504230/ss_a110fe2f50c5828af4b1ff4e7c1ca773a1a7e5aa.600x338.jpg?t=1547237854;https://steamcdn-a.akamaihd.net/steam/apps/504230/ss_152d7e5459c7d6d676ab837abe4355907757ae2d.600x338.jpg?t=1547237854;
Don’t Starve Together	Survival	Klei Entertainment	21/4/2016	Don't Starve Together is the standalone multiplayer expansion of the uncompromising survival game Don't Starve.	https://steamcdn-a.akamaihd.net/steam/apps/322330/header_alt_assets_5.jpg?t=1559867048;https://steamcdn-a.akamaihd.net/steam/apps/322330/ss_11dc14670f703a99884bbe479205727a3776d7b3.600x338.jpg?t=1559867048;https://steamcdn-a.akamaihd.net/steam/apps/322330/ss_9268a2ab850c1ebe9cab8c1caad57abb20a33560.600x338.jpg?t=1559867048;https://steamcdn-a.akamaihd.net/steam/apps/322330/ss_f59438f653e4e9a423777793bb366c94c59acc56.600x338.jpg?t=1559867048;https://steamcdn-a.akamaihd.net/steam/apps/322330/ss_87091f2ec581c20e1a941a70bb80355419a1f6ba.600x338.jpg?t=1559867048;
Life Is Strange	Visual Novel	Square Enix	31/1/2015	Life is Strange is an award-winning and critically acclaimed episodic adventure game that allows the player to rewind time and affect the past, present and future.	https://steamcdn-a.akamaihd.net/steam/apps/319630/header.jpg?t=1549968253;https://steamcdn-a.akamaihd.net/steam/apps/319630/ss_2abb901703c73f9230d0ad42846c29d263825807.600x338.jpg?t=1549968253;https://steamcdn-a.akamaihd.net/steam/apps/319630/ss_f071f2da3d45953de69f00e05c6e333954ecdf26.600x338.jpg?t=1549968253;https://steamcdn-a.akamaihd.net/steam/apps/319630/ss_8df8236403f5aad45eeedd33d2bd545e45435b39.600x338.jpg?t=1549968253;https://steamcdn-a.akamaihd.net/steam/apps/319630/ss_351f0026c4ca89eef429a095750814aaf6b5ebc0.600x338.jpg?t=1549968253;https://steamcdn-a.akamaihd.net/steam/apps/319630/ss_a856ba29b6a4eeb12cea337d6804d3a177c86e1c.600x338.jpg?t=1549968253;https://steamcdn-a.akamaihd.net/steam/apps/319630/ss_bd2379094bf433c9376ba5047ab54c3a601b74ef.600x338.jpg?t=1549968253;
League of Legends	MOBA	Riot Games	27/10/2009	Whether you're playing Solo or Co-op with friends, League of Legends is a highly competitive, fast paced action-strategy game designed for those who crave a hard fought victory.	https://esports-betting-tips.com/wp-content/uploads/2018/10/League-of-Legends-Image-1200x675.jpg;https://i.imgur.com/ojEg8lY.jpg;https://sfx.thelazy.net/static/media/presetscreenshots/lol2.png;https://sfx.thelazy.net/static/media/medthumb/LeagueReshaded.png;
Fire Emblem Awakening	RPG	Intelligent Systems	19/4/2012	Two sleeping dragons—one a sacred ally of mankind, the other its sworn destroyer. Two heroes marked with the symbols of the dragons. Their meeting heralds the dragons' awakening—and the world's ending.	https://hb.imgix.net/e7903a82c21e541ec15ddb9fd7508095206b71de.jpg?auto=compress,format&fit=crop&h=353&w=616&s=6ad9c3c822a0382425caf922b273d0db;https://www.nintendo.com/content/dam/noa/en_US/games/3ds/f/fire-emblem-awakening-3ds/screenshot-gallery/3DS_FEA_GemDemo_010813_02.jpg;https://www.nintendo.com/content/dam/noa/en_US/games/3ds/f/fire-emblem-awakening-3ds/screenshot-gallery/3DS_FEA_GemDemo_010813_01.jpg;http://nerdreactor.com/wp-content/uploads/2013/01/fire-emblem-awakening-screenshot-2.jpg;https://cdn2.expertreviews.co.uk/sites/expertreviews/files/images/dir_392/er_photo_196132.png?itok=DxxakVtj;https://i.pinimg.com/originals/bd/d0/89/bdd0899b8f329d0abaff083b96817ea8.jpg;
Devil May Cry V	Action	Capcom	8/3/2019	The ultimate Devil Hunter is back in style, in the game action fans have been waiting for.	https://steamcdn-a.akamaihd.net/steam/apps/601150/header.jpg?t=1557194314;https://steamcdn-a.akamaihd.net/steam/apps/601150/ss_4410bada2565843dae693b03ac3a50256ff5dd66.600x338.jpg?t=1557194314;https://steamcdn-a.akamaihd.net/steam/apps/601150/ss_4ce180ed8979a51c72de51f985e9e9ba13500508.600x338.jpg?t=1557194314;https://steamcdn-a.akamaihd.net/steam/apps/601150/ss_e2be70565f94a7f6c392cccddce08c67f2f87612.600x338.jpg?t=1557194314;https://steamcdn-a.akamaihd.net/steam/apps/601150/ss_d1e0b403f593f17ad195c5382a7788d71c6f406a.600x338.jpg?t=1557194314;https://steamcdn-a.akamaihd.net/steam/apps/601150/ss_f669d4627db07e61b87728d94d72bc1eabfd0349.600x338.jpg?t=1557194314;
Super Mario Odyssey	Platformer	Nintendo	27/10/2017	Use amazing new abilities—like the power to capture and control objects, animals, and enemies—to collect Power Moons so you can power up the Odyssey airship and save Princess Peach from Bowser's wedding plans!	https://17kgroup.it/wp-content/uploads/2017/08/H2x1_NSwitch_SuperMarioOdyssey-696x348.jpg;https://www.nintendo.com/content/dam/noa/en_US/games/switch/s/super-mario-odyssey-switch/screenshot-gallery/Switch_SuperMarioOdyssey_01.jpg;https://www.nintendo.com/content/dam/noa/en_US/games/switch/s/super-mario-odyssey-switch/screenshot-gallery/Switch_SuperMarioOdyssey_02.jpg;https://i.imgur.com/wL7kij4.jpg;https://cdn.pressstart.com.au/wp-content/uploads/2017/10/Super-Mario-Odyssey.png;
Grand Theft Auto V	Action	Rockstars	14/4/2015	Los Santos is a city of bright lights, long nights and dirty secrets, and they don’t come brighter, longer or dirtier than in GTA Online: After Hours. The party starts now.	https://steamcdn-a.akamaihd.net/steam/apps/271590/header.jpg?t=1544815097;https://steamcdn-a.akamaihd.net/steam/apps/271590/ss_32aa18ab3175e3002217862dd5917646d298ab6b.600x338.jpg?t=1544815097;https://steamcdn-a.akamaihd.net/steam/apps/271590/ss_da39c16db175f6973770bae6b91d411251763152.600x338.jpg?t=1544815097;https://steamcdn-a.akamaihd.net/steam/apps/271590/ss_bd5db78286be0a7c6b2c62519099a9e27e6b06f3.600x338.jpg?t=1544815097;https://steamcdn-a.akamaihd.net/steam/apps/271590/ss_b1a1cb7959d6a0e6fcb2d06ebf97a66c9055cef3.600x338.jpg?t=1544815097;https://steamcdn-a.akamaihd.net/steam/apps/271590/ss_bc5fc79d3366c837372327717249a4887aa46d63.600x338.jpg?t=1544815097;https://steamcdn-a.akamaihd.net/steam/apps/271590/ss_bd944debbec9936769f6dfb39ee456ca605615e3.600x338.jpg?t=1544815097;
The Witcher 3: Wild Hunt	RPG	CD Projekt: RED	18/5/2015	As war rages on throughout the Northern Realms, you take on the greatest contract of your life — tracking down the Child of Prophecy, a living weapon that can alter the shape of the world.	https://steamcdn-a.akamaihd.net/steam/apps/292030/header.jpg?t=1550078557;https://steamcdn-a.akamaihd.net/steam/apps/292030/ss_107600c1337accc09104f7a8aa7f275f23cad096.600x338.jpg?t=1550078557;https://steamcdn-a.akamaihd.net/steam/apps/292030/ss_64eb760f9a2b67f6731a71cce3a8fb684b9af267.600x338.jpg?t=1550078557;https://steamcdn-a.akamaihd.net/steam/apps/292030/ss_eda99e7f705a113d04ab2a7a36068f3e7b343d17.600x338.jpg?t=1550078557;https://steamcdn-a.akamaihd.net/steam/apps/292030/ss_dc33eb233555c13fce939ccaac667bc54e3c4a27.600x338.jpg?t=1550078557;https://steamcdn-a.akamaihd.net/steam/apps/292030/ss_908485cbb1401b1ebf42e3d21a860ddc53517b08.600x338.jpg?t=1550078557;
Minecraft	Survival	Mojang	17/5/2009	Explore infinite worlds and build everything from the simplest of homes to the grandest of castles. Play in creative mode with unlimited resources or mine deep into the world in survival mode, crafting weapons and armor to fend off dangerous mobs.	https://cdn.gamerant.com/wp-content/uploads/minecraft-movie-release-date-1.jpg.optimal.jpg;http://i.imgur.com/LS1wETl.jpg;https://i.imgur.com/jt3hKqB.jpg;https://i.imgur.com/yKdjGvw.png;https://i.imgur.com/Fd9HB2N.png;https://i.imgur.com/2QGUpt4.png;
Monster Hunter: World	Action	CAPCOM	9/8/2018	Welcome to a new world! In Monster Hunter: World, the latest installment in the series, you can enjoy the ultimate hunting experience, using everything at your disposal to hunt monsters in a new world teeming with surprises and excitement.	https://steamcdn-a.akamaihd.net/steam/apps/582010/header.jpg?t=1554771889;https://steamcdn-a.akamaihd.net/steam/apps/582010/ss_a262c53b8629de7c6547933dc0b49d31f4e1b1f1.600x338.jpg?t=1554771889;https://steamcdn-a.akamaihd.net/steam/apps/582010/ss_0dfb20f6f09c196bfc317bd517dc430ed6e6a2a4.600x338.jpg?t=1554771889;https://steamcdn-a.akamaihd.net/steam/apps/582010/ss_25902a9ae6977d6d10ebff20b87e8739e51c5b8b.600x338.jpg?t=1554771889;https://steamcdn-a.akamaihd.net/steam/apps/582010/ss_681cc5358ec55a997aee9f757ffe8b418dc79a32.600x338.jpg?t=1554771889;https://steamcdn-a.akamaihd.net/steam/apps/582010/ss_ce69dc57e6e442c73d874f1b701f2e4af405fb19.600x338.jpg?t=1554771889;https://steamcdn-a.akamaihd.net/steam/apps/582010/ss_6d26868b45c20bf4dd5f75f31264aca08ce17217.600x338.jpg?t=1554771889;
The Legend of Zelda: Breath of The Wild	RPG	Nintendo	3/3/2017	Forget everything you know about The Legend of Zelda games. Step into a world of discovery, exploration, and adventure in The Legend of Zelda: Breath of the Wild, a boundary-breaking new game in the acclaimed series. Travel across vast fields, through forests, and to mountain peaks as you discover what has become of the kingdom of Hyrule In this stunning Open-Air Adventure. Now on Nintendo Switch, your journey is freer and more open than ever. Take your system anywhere, and adventure as Link any way you like.	https://i.ytimg.com/vi/s0gj8yrLaXE/maxresdefault.jpg;https://www.nintendo.com/content/dam/noa/en_US/games/switch/t/the-legend-of-zelda-breath-of-the-wild-switch/screenshot-gallery/Switch_TLOZ-BOTW_01.jpg;https://www.nintendo.com/content/dam/noa/en_US/games/switch/t/the-legend-of-zelda-breath-of-the-wild-switch/screenshot-gallery/Switch_TLOZ-BOTW_02.jpg;https://www.nintendo.com/content/dam/noa/en_US/games/switch/t/the-legend-of-zelda-breath-of-the-wild-switch/screenshot-gallery/Switch_TLOZ-BOTW_03.jpg;https://www.nintendo.com/content/dam/noa/en_US/games/switch/t/the-legend-of-zelda-breath-of-the-wild-switch/screenshot-gallery/Switch_TLOZ-BOTW_04.jpg;https://www.nintendo.com/content/dam/noa/en_US/games/switch/t/the-legend-of-zelda-breath-of-the-wild-switch/screenshot-gallery/Switch_TLOZ-BOTW_05.jpg;
Persona 5	RPG	ATLUS	15/9/2016	Beneath the veneer of typical urban high school life, a group of teenagers mask their mysterious alter egos, their "phantom thief" side. Who are they? Why are they dressed as such? What are their motives? And... why are they being pursued? A picaresque coming-of-age story, Persona 5 brings a new twist to the RPG genre.	https://i0.wp.com/thelootgaming.com/wp-content/uploads/2017/09/promo324068006.jpg?resize=820%2C461&ssl=1;https://www.playerattack.com/imagery/2017/04/Persona-5-Screenshots-1-1.jpg;https://i1.wp.com/www.playerattack.com/imagery/2017/04/03.jpg;https://gematsu.com/wp-content/uploads/2016/09/Persona-5-Compare_09-07-16_003.jpg;https://gematsu.com/wp-content/uploads/2016/09/Persona-5-Compare_09-07-16_005.jpg;
God of War	Action	Santa Monica Studio	20/4/2018	"It is a new beginning for Kratos. Living as a man, outside the shadow of the gods, he seeks solitude in the unfamiliar lands of Norse mythology. With new purpose and his son at his side, Kratos must fight for survival as powerful forces threaten to disrupt the new life he has created..."	http://www.powerpyx.com/wp-content/uploads/god-of-war-2018-wallpaper-1024x576.jpg;https://c-6rtwjumjzx7877x24x78yfynhx2elfrjx78utyx2ehtr.g00.gamespot.com/g00/3_c-6bbb.lfrjx78uty.htr_/c-6RTWJUMJZX77x24myyux78x3ax2fx2fx78yfynh.lfrjx78uty.htrx2fzuqtfix78x2fx78hfqj_x78zujwx2f6001x2f60013393x2f8810718-53_6075480092.oulx3fn65h.rfwpx3dnrflj_$/$/$/$/$/$;https://c-6rtwjumjzx7877x24x78yfynhx2elfrjx78utyx2ehtr.g00.gamespot.com/g00/3_c-6bbb.lfrjx78uty.htr_/c-6RTWJUMJZX77x24myyux78x3ax2fx2fx78yfynh.lfrjx78uty.htrx2fzuqtfix78x2fx78hfqj_x78zujwx2f6001x2f60013393x2f8810711-58_6075480099.oulx3fn65h.rfwpx3dnrflj_$/$/$/$/$/$;https://c-6rtwjumjzx7877x24x78yfynhx2elfrjx78utyx2ehtr.g00.gamespot.com/g00/3_c-6bbb.lfrjx78uty.htr_/c-6RTWJUMJZX77x24myyux78x3ax2fx2fx78yfynh.lfrjx78uty.htrx2fzuqtfix78x2fx78hfqj_x78zujwx2f6001x2f60013393x2f8810712-59_6075480083.oulx3fn65h.rfwpx3dnrflj_$/$/$/$/$/$;https://c-6rtwjumjzx7877x24x78yfynhx2elfrjx78utyx2ehtr.g00.gamespot.com/g00/3_c-6bbb.lfrjx78uty.htr_/c-6RTWJUMJZX77x24myyux78x3ax2fx2fx78yfynh.lfrjx78uty.htrx2fzuqtfix78x2fx78hfqj_x78zujwx2f6001x2f60013393x2f8810713-51_6075480090.oulx3fn65h.rfwpx3dnrflj_$/$/$/$/$/$;https://c-6rtwjumjzx7877x24x78yfynhx2elfrjx78utyx2ehtr.g00.gamespot.com/g00/3_c-6bbb.lfrjx78uty.htr_/c-6RTWJUMJZX77x24myyux78x3ax2fx2fx78yfynh.lfrjx78uty.htrx2fzuqtfix78x2fx78hfqj_x78zujwx2f6001x2f60013393x2f8810714-65_6075480081.oulx3fn65h.rfwpx3dnrflj_$/$/$/$/$/$;
Final Fantasy VII	RPG	Square Enix	4/7/2013	In Midgar, a city controlled by the mega-conglomerate Shinra Inc., the No. 1 Mako Reactor has been blown up by a rebel group, AVALANCHE.AVALANCHE was secretly formed to wage a rebellion against Shinra Inc., an organisation which is absorbing Mako energy, destroying the natural resources of the planet.	https://steamcdn-a.akamaihd.net/steam/apps/39140/header.jpg?t=1549381969;https://steamcdn-a.akamaihd.net/steam/apps/39140/ss_19e001c38309a504ff39ebd557eccfff5ed1c3be.600x338.jpg?t=1549381969;https://steamcdn-a.akamaihd.net/steam/apps/39140/ss_3b111bf8ad9bdd95b55cdcda4d3ee9b70b15dca1.600x338.jpg?t=1549381969;https://steamcdn-a.akamaihd.net/steam/apps/39140/ss_0bbe443526a52664aecece47e229d17ca68d1e5a.600x338.jpg?t=1549381969;https://steamcdn-a.akamaihd.net/steam/apps/39140/ss_66be6e5bf8944148fe2e1fe7aa5d4c41e6e0f9e0.600x338.jpg?t=1549381969;https://steamcdn-a.akamaihd.net/steam/apps/39140/ss_771d87fca66c40ffabf10d479a595ce9f47550e5.600x338.jpg?t=1549381969;
Grim Dawn	RPG	Crate Entertainment	26/2/2016	Enter an apocalyptic fantasy world where humanity is on the brink of extinction, iron is valued above gold and trust is hard earned. This ARPG features complex character development, hundreds of unique items, crafting and quests with choice & consequence.	https://steamcdn-a.akamaihd.net/steam/apps/219990/header.jpg?t=1558653211;https://steamcdn-a.akamaihd.net/steam/apps/219990/ss_b8f592942c1de25498f9d8f402f73bad56f7266a.600x338.jpg?t=1558653211;https://steamcdn-a.akamaihd.net/steam/apps/219990/ss_f1e31d26e04beccfe25b9cbf012814b7902bf824.600x338.jpg?t=1558653211;https://steamcdn-a.akamaihd.net/steam/apps/219990/ss_82059cbede2d7dec0943eca1bff97ae47de53b3f.600x338.jpg?t=1558653211;https://steamcdn-a.akamaihd.net/steam/apps/219990/ss_c0fac5e6e3a9d9e03db1790adeb340b93ec21cf6.600x338.jpg?t=1558653211;https://steamcdn-a.akamaihd.net/steam/apps/219990/ss_4b231ab9d3b44f5a3a2ff115b04b7f85e4620cb2.600x338.jpg?t=1558653211;https://steamcdn-a.akamaihd.net/steam/apps/219990/ss_96f4f77e4fd848a3facb481023a79e6c9a580ed0.600x338.jpg?t=1558653211;https://steamcdn-a.akamaihd.net/steam/apps/219990/ss_b61112739bc67a2ea2a419ad968cd91dce5ed61a.600x338.jpg?t=1558653211;
Ori and the Blind Forest	Platformer	Microsoft Studio	11/3/2015	“Ori and the Blind Forest” tells the tale of a young orphan destined for heroics, through a visually stunning action-platformer crafted by Moon Studios for PC.	https://steamcdn-a.akamaihd.net/steam/apps/261570/header.jpg?t=1557766332;https://steamcdn-a.akamaihd.net/steam/apps/261570/ss_c617379b9d195eed0342f3ecf86898513e702b96.600x338.jpg?t=1557766332;https://steamcdn-a.akamaihd.net/steam/apps/261570/ss_a4dbe240c363fe04e39a13c9bd78c88c026f3c50.600x338.jpg?t=1557766332;https://steamcdn-a.akamaihd.net/steam/apps/261570/ss_38552fb1001c03b5ccce2e3979270b2ecfd944c2.600x338.jpg?t=1557766332;https://steamcdn-a.akamaihd.net/steam/apps/261570/ss_85f66e8586a70b4fea5602a9d82ef2bf42c633b6.600x338.jpg?t=1557766332;https://steamcdn-a.akamaihd.net/steam/apps/261570/ss_3b56520665b8fe3bba8df7e4cd239273c7156ab1.600x338.jpg?t=1557766332;https://steamcdn-a.akamaihd.net/steam/apps/261570/ss_9b1e2d00b8582547070a8aab136372f75ffb4024.600x338.jpg?t=1557766332;
Borderlands 2	RPG	Gearbox Software	20/9/2012	The Ultimate Vault Hunter’s Upgrade lets you get the most out of the Borderlands 2 experience.	https://steamcdn-a.akamaihd.net/steam/apps/49520/header.jpg?t=1560182929;https://steamcdn-a.akamaihd.net/steam/apps/49520/ss_6734eaa79dcd0fe53971fbd50d20b5d0d45f4809.600x338.jpg?t=1560182929;https://steamcdn-a.akamaihd.net/steam/apps/49520/ss_2f27a18562fbf4a91943c3968b35db5ac1caf5ad.600x338.jpg?t=1560182929;https://steamcdn-a.akamaihd.net/steam/apps/49520/ss_c20610ab476bfe99172df77fe84f579d91e45a2b.600x338.jpg?t=1560182929;https://steamcdn-a.akamaihd.net/steam/apps/49520/ss_da8b3279d4ff979b99b3a417d21a097600729266.600x338.jpg?t=1560182929;https://steamcdn-a.akamaihd.net/steam/apps/49520/ss_3d8370934170622af4fcc8a3975f7be480b3d815.600x338.jpg?t=1560182929;
Divinity: Original Sin 2	RPG	Larian Studio	14/9/2017	The eagerly anticipated sequel to the award-winning RPG. Gather your party. Master deep, tactical combat. Join up to 3 other players - but know that only one of you will have the chance to become a God.	https://steamcdn-a.akamaihd.net/steam/apps/435150/header.jpg?t=1557496137;https://steamcdn-a.akamaihd.net/steam/apps/435150/ss_34a428cdd26113e8645b77331d9fc82fcc50a4a2.600x338.jpg?t=1557496137;https://steamcdn-a.akamaihd.net/steam/apps/435150/ss_b59e5889726cab2cf01a93d0c0d192d25928952a.600x338.jpg?t=1557496137;https://steamcdn-a.akamaihd.net/steam/apps/435150/ss_d3badb07717f13ef3316928c513f8c4c7f7b50b1.600x338.jpg?t=1557496137;https://steamcdn-a.akamaihd.net/steam/apps/435150/ss_d51d3ccb39019124c45bf851bbe6a76e2461fab3.600x338.jpg?t=1557496137;https://steamcdn-a.akamaihd.net/steam/apps/435150/ss_5034004fa3690a17da2c266bc577e8aa54e2f3ef.600x338.jpg?t=1557496137;
Counter Strike: Global Offensive	Shooting	Valve	22/8/2012	Counter-Strike: Global Offensive (CS: GO) expands upon the team-based action gameplay that it pioneered when it was launched 19 years ago. CS: GO features new maps, characters, weapons, and game modes, and delivers updated versions of the classic CS content (de_dust2, etc.).	https://steamcdn-a.akamaihd.net/steam/apps/730/header.jpg?t=1554409309;https://steamcdn-a.akamaihd.net/steam/apps/730/ss_9d0735a5fbe523fd39f2c69c047019843c326cea.600x338.jpg?t=1554409309;https://steamcdn-a.akamaihd.net/steam/apps/730/ss_9d889bec419cf38910ccf72dd80f9260227408ee.600x338.jpg?t=1554409309;https://steamcdn-a.akamaihd.net/steam/apps/730/ss_ccc4ce6edd4c454b6ce7b0757e633b63aa93921d.600x338.jpg?t=1554409309;https://steamcdn-a.akamaihd.net/steam/apps/730/ss_9db552fd461722f1569e3292d8f2ea654c8ffdef.600x338.jpg?t=1554409309;https://steamcdn-a.akamaihd.net/steam/apps/730/ss_74c1a0264ceaf57e5fb51d978205045223b48a18.600x338.jpg?t=1554409309;
Dota 2	MOBA	Valve	9/7/2013	Every day, millions of players worldwide enter battle as one of over a hundred Dota heroes. And no matter if it's their 10th hour of play or 1,000th, there's always something new to discover. With regular updates that ensure a constant evolution of gameplay, features, and heroes, Dota 2 has taken on a life of its own.	https://steamcdn-a.akamaihd.net/steam/apps/570/header.jpg?t=1557267263;https://steamcdn-a.akamaihd.net/steam/apps/570/ss_86d675fdc73ba10462abb8f5ece7791c5047072c.600x338.jpg?t=1557267263;https://steamcdn-a.akamaihd.net/steam/apps/570/ss_ad8eee787704745ccdecdfde3a5cd2733704898d.600x338.jpg?t=1557267263;https://steamcdn-a.akamaihd.net/steam/apps/570/ss_7ab506679d42bfc0c0e40639887176494e0466d9.600x338.jpg?t=1557267263;https://steamcdn-a.akamaihd.net/steam/apps/570/ss_c9118375a2400278590f29a3537769c986ef6e39.600x338.jpg?t=1557267263;https://steamcdn-a.akamaihd.net/steam/apps/570/ss_b33a65678dc71cc98df4890e22a89601ee56a918.600x338.jpg?t=1557267263;
Overwatch	Shooting	Blizzard Entertainment	24/5/2016	The world needs heroes. Join over 40 million players* as you take your place in the world of Overwatch. Choose your hero from a diverse cast of soldiers, scientists, adventurers, and oddities. Bend time, defy physics, and unleash an array of extraordinary powers and weapons. Engage your enemies in iconic locations from around the globe in the ultimate team-based shooter.	https://media.alienwarearena.com/media/overwatch-logo-hd-wallpaper.jpg;http://i.imgur.com/iTMIHVe.jpg;https://dotesports-media.nyc3.cdn.digitaloceanspaces.com/wp-content/uploads/2018/08/11193332/ae1311cf-83a5-4196-b3b2-d1357ab8d51a.jpg;https://cdn.vox-cdn.com/thumbor/74vKYzqf8aiCocSnL-UogoCxNag=/1000x0/filters:no_upscale()/cdn.vox-cdn.com/uploads/chorus_asset/file/2438892/overwatch-bastion-screenshot-001_1920.0.jpg;https://cdn.vox-cdn.com/thumbor/YQVWvEzsIlipdAcW4Wg60iND_Fg=/1000x0/filters:no_upscale()/cdn.vox-cdn.com/uploads/chorus_asset/file/2438902/overwatch-hanamura-screenshot-001_1920.0.jpg;
Diablo 3	RPG	Blizzard Entertainment	15/5/2012	Diablo III is a dungeon crawler hack-and-slash action role-playing game developed and published by Blizzard Entertainment as the third installment in the Diablo franchise.	https://bnetproduct-a.akamaihd.net//fff/155c60a0322ae5402f8cbae3c4108297-diablo-III-base-1000x700.png;http://i.imgur.com/gRCJE.jpg;https://i.imgur.com/k4rDFpF.jpg;https://i.imgur.com/FHykBBM.jpg;https://i.imgur.com/3rjfE06.jpg;
The Elder Scroll V: Skyrim	RPG	Todd Howard Production	28/10/2016	Winner of more than 200 Game of the Year Awards, Skyrim Special Edition brings the epic fantasy to life in stunning detail. The Special Edition includes the critically acclaimed game and add-ons with all-new features like remastered art and effects, volumetric god rays, dynamic depth of field, screen-space reflections, and more.	https://steamcdn-a.akamaihd.net/steam/apps/489830/header.jpg?t=1533676854;https://steamcdn-a.akamaihd.net/steam/apps/489830/ss_73c1a0bb7e1720c8a1847186c3ddd837d3ca7a8d.600x338.jpg?t=1533676854;https://steamcdn-a.akamaihd.net/steam/apps/489830/ss_d64b646612ab1402bdda8e400672aa0dbcb352ea.600x338.jpg?t=1533676854;https://steamcdn-a.akamaihd.net/steam/apps/489830/ss_b6bb6f79278505b3f48567f08c21f7a0eb171c68.600x338.jpg?t=1533676854;https://steamcdn-a.akamaihd.net/steam/apps/489830/ss_921ccea650df936a0b14ebd5dd4ecc73c1d2a12d.600x338.jpg?t=1533676854;https://steamcdn-a.akamaihd.net/steam/apps/489830/ss_8c7ecd394afb581b9b2137a3de04433f78fdf4ea.600x338.jpg?t=1533676854;
Hyperdimension Neptunia: Re;Birth 1	RPG	Idea Factory!	28/1/2015	Packed with fast-paced, turn-based RPG action, fourth-wall-breaking, trope-demolishing dialogue, and more item, weapon, and costume customization than you can shake a Lvl. 1 Stick at, Gamindustri is a world set on turning the concept of the JRPG on its head!	https://steamcdn-a.akamaihd.net/steam/apps/282900/header.jpg?t=1536110675;https://steamcdn-a.akamaihd.net/steam/apps/282900/ss_0005eccfe5b67faba998ccd99c2427f817a1a639.600x338.jpg?t=1536110675;https://steamcdn-a.akamaihd.net/steam/apps/282900/ss_e0e6cdc76c7b9b8fb4e7d377068946869962f962.600x338.jpg?t=1536110675;https://steamcdn-a.akamaihd.net/steam/apps/282900/ss_9612688cb838c01d3d894f8e4b6bf2b16170ae3f.600x338.jpg?t=1536110675;https://steamcdn-a.akamaihd.net/steam/apps/282900/ss_5c870de97ffeebc58ea69a5879324982737e1c58.600x338.jpg?t=1536110675;https://steamcdn-a.akamaihd.net/steam/apps/282900/ss_dedef8470c1f15aa2173e002b65e534347c7ef49.600x338.jpg?t=1536110675;
Neptunia Shooter	Shooting	Idea Factory!	22/5/2019	Armed to the teeth, players begin as Neptune in an unworldly 8-bit space dimension ravaged by creatures who burst endless waves of bullets. Shoot, dodge, and defeat the boss in six unique bullet-hell worlds.	https://steamcdn-a.akamaihd.net/steam/apps/1037590/header.jpg?t=1558491029;https://steamcdn-a.akamaihd.net/steam/apps/1037590/ss_29d5c8816ba187f1e4afa0ce28696b2532a3bbe5.600x338.jpg?t=1558491029;https://steamcdn-a.akamaihd.net/steam/apps/1037590/ss_ffe845c567c1e0ef1ac381f43bb8526e8e9c12cc.600x338.jpg?t=1558491029;https://steamcdn-a.akamaihd.net/steam/apps/1037590/ss_4bce378a0b290d5ed713f699dbe8a909ffce804d.600x338.jpg?t=1558491029;https://steamcdn-a.akamaihd.net/steam/apps/1037590/ss_3c7a4a657928f4c9d379e7c53f71bf05cb09a327.600x338.jpg?t=1558491029;https://steamcdn-a.akamaihd.net/steam/apps/1037590/ss_10eca95ca028471128b2b58a5ec7716e26116a9d.600x338.jpg?t=1558491029;
Nekopara Vol.1	Visual Novel	NEKO WORKs	30/12/2014	What's NEKOPARA? Why, it's a cat paradise! Kashou Minaduki, the son of a long line of Japanese confection makers moved out to open his own shop "La Soleil" as a patisserie.	https://steamcdn-a.akamaihd.net/steam/apps/333600/header.jpg?t=1558382831;https://steamcdn-a.akamaihd.net/steam/apps/333600/ss_a41e06f39ef50377dd1a04398578f5018de5d064.600x338.jpg?t=1558382831;https://steamcdn-a.akamaihd.net/steam/apps/333600/ss_3433d14f96ebcd1b3cd7d3c1d79170eecdeb0577.600x338.jpg?t=1558382831;https://steamcdn-a.akamaihd.net/steam/apps/333600/ss_8d26d27426fdfe46b252cb21bcdcbde64c44fb3d.600x338.jpg?t=1558382831;https://steamcdn-a.akamaihd.net/steam/apps/333600/ss_4bfd66ccc83135641d5aba3a72227bd4d533333e.600x338.jpg?t=1558382831;
God Eater 3	Action	Bandai Namco Entertainment	8/2/2019	Set in a post-apocalyptic setting, it’s up to your special team of God Eaters to take down god-like monsters devastating the world. With an epic story, unique characters, and all new God Arcs and Aragami, the latest evolution in ACTION is here!	https://steamcdn-a.akamaihd.net/steam/apps/899440/header.jpg?t=1551445626;https://steamcdn-a.akamaihd.net/steam/apps/899440/ss_cb48c68d3b4127d32e75e4f840eb0fe14c3db927.600x338.jpg?t=1551445626;https://steamcdn-a.akamaihd.net/steam/apps/899440/ss_75fd69c74ccd3a264ec26e9fded37aa18f603f1c.600x338.jpg?t=1551445626;https://steamcdn-a.akamaihd.net/steam/apps/899440/ss_554b2b37dc5b98810396f964e87bcd591cad43ef.600x338.jpg?t=1551445626;https://steamcdn-a.akamaihd.net/steam/apps/899440/ss_aa42d78691ad5e515741fe04adea460e54beb6fa.600x338.jpg?t=1551445626;https://steamcdn-a.akamaihd.net/steam/apps/899440/ss_22e417d51c71a50b2a17ad2badf283bc74fc5e00.600x338.jpg?t=1551445626;
Overcooked 2	Casual	Team17 Digital	7/8/2018	Overcooked returns with a brand-new helping of chaotic cooking action! Journey back to the Onion Kingdom and assemble your team of chefs in classic couch co-op or online play for up to four players. Hold onto your aprons… it’s time to save the world again!	https://steamcdn-a.akamaihd.net/steam/apps/728880/header.jpg?t=1560524797;https://steamcdn-a.akamaihd.net/steam/apps/728880/ss_4ad737de5e5439217ce0f0d9bd381fe0e251b87a.600x338.jpg?t=1560524797;https://steamcdn-a.akamaihd.net/steam/apps/728880/ss_a5ac93e93140fce2e9682742ca145d009f1ad089.600x338.jpg?t=1560524797;https://steamcdn-a.akamaihd.net/steam/apps/728880/ss_96cc7ae855d3fde9f5b1c6c21d0ab347116d9747.600x338.jpg?t=1560524797;https://steamcdn-a.akamaihd.net/steam/apps/728880/ss_43d3b0c28fe56c8de79a9be8e97afa7d40dddf96.600x338.jpg?t=1560524797;
Portal 2	Puzzle	Valve	19/4/2011	The "Perpetual Testing Initiative" has been expanded to allow you to design co-op puzzles for you and your friends!	https://steamcdn-a.akamaihd.net/steam/apps/620/header.jpg?t=1512411524;https://steamcdn-a.akamaihd.net/steam/apps/620/ss_f3f6787d74739d3b2ec8a484b5c994b3d31ef325.600x338.jpg?t=1512411524;https://steamcdn-a.akamaihd.net/steam/apps/620/ss_6a4f5afdaa98402de9cf0b59fed27bab3256a6f4.600x338.jpg?t=1512411524;https://steamcdn-a.akamaihd.net/steam/apps/620/ss_3d13161104a04603a0524536770c5f74626db4c0.600x338.jpg?t=1512411524;https://steamcdn-a.akamaihd.net/steam/apps/620/ss_8a772608d29ffd56ac013d2ac7c4388b96e87a21.600x338.jpg?t=1512411524;https://steamcdn-a.akamaihd.net/steam/apps/620/ss_358127df30a766a1516ad139083c2bcec3fe0975.600x338.jpg?t=1512411524;
Half-life 2	Shooting	Valve	16/11/2004	1998. HALF-LIFE sends a shock through the game industry with its combination of pounding action and continuous, immersive storytelling. Valve's debut title wins more than 50 game-of-the-year awards on its way to being named "Best PC Game Ever" by PC Gamer, and launches a franchise with more than eight million retail units sold worldwide.	https://steamcdn-a.akamaihd.net/steam/apps/220/header.jpg?t=1541802014;https://steamcdn-a.akamaihd.net/steam/apps/220/0000001864.600x338.jpg?t=1541802014;https://steamcdn-a.akamaihd.net/steam/apps/220/0000001865.600x338.jpg?t=1541802014;https://steamcdn-a.akamaihd.net/steam/apps/220/0000001866.600x338.jpg?t=1541802014;https://steamcdn-a.akamaihd.net/steam/apps/220/0000001867.600x338.jpg?t=1541802014;https://steamcdn-a.akamaihd.net/steam/apps/220/0000001872.600x338.jpg?t=1541802014;
Resident Evil 2 Remake	Horror	CAPCOM	25/1/2019	A deadly virus engulfs the residents of Raccoon City in September of 1998, plunging the city into chaos as flesh eating zombies roam the streets for survivors. An unparalleled adrenaline rush, gripping storyline, and unimaginable horrors await you. Witness the return of Resident Evil 2.	https://steamcdn-a.akamaihd.net/steam/apps/883710/ss_1392581cd29817e44099cf05416b70ffb159c58b.600x338.jpg?t=1556224097;https://steamcdn-a.akamaihd.net/steam/apps/883710/ss_cb998634747b70bbcf2dba34a2aef34808d039bf.600x338.jpg?t=1556224097;https://steamcdn-a.akamaihd.net/steam/apps/883710/ss_cd289d2e809b3fcb236a4f193a43a16787c6bc87.600x338.jpg?t=1556224097;https://steamcdn-a.akamaihd.net/steam/apps/883710/ss_bfbd61cde09efcfa36f6bc0b976b1ce5fda77bfe.600x338.jpg?t=1556224097;https://steamcdn-a.akamaihd.net/steam/apps/883710/ss_2a5d36713b40b27d1b8ed68ddcbf408af76ec1a1.600x338.jpg?t=1556224097;https://steamcdn-a.akamaihd.net/steam/apps/883710/ss_3d6d32d7e17c139e81a6fc64954ef35c73e5478d.600x338.jpg?t=1556224097;
Dead Cells	Action	Motion Twin	7/8/2018	Dead Cells is a rogue-lite, metroidvania inspired, action-platformer. You'll explore a sprawling, ever-changing castle... assuming you’re able to fight your way past its keepers in 2D souls-lite combat. No checkpoints. Kill, die, learn, repeat.	https://steamcdn-a.akamaihd.net/steam/apps/588650/header.jpg?t=1553880029;https://steamcdn-a.akamaihd.net/steam/apps/588650/ss_21c61aca6a66745a2abb3f72b93553398fc7fe32.600x338.jpg?t=1553880029;https://steamcdn-a.akamaihd.net/steam/apps/588650/ss_b7cf2ca21fe3648c53f808b80393cc727815dcc5.600x338.jpg?t=1553880029;https://steamcdn-a.akamaihd.net/steam/apps/588650/ss_a109be71f065e166ff33ba43853fba0a0d4753d1.600x338.jpg?t=1553880029;https://steamcdn-a.akamaihd.net/steam/apps/588650/ss_e87e72a247918d8493892e035d5e1b4b84470d2f.600x338.jpg?t=1553880029;https://steamcdn-a.akamaihd.net/steam/apps/588650/ss_6f305b9603c17d31ddcbda4c73add319bf910a41.600x338.jpg?t=1553880029;
Sid Meier’s Civilization VI	Strategy	Firaxis Games	21/10/2016	Civilization VI offers new ways to interact with your world, expand your empire across the map, advance your culture, and compete against history’s greatest leaders to build a civilization that will stand the test of time. Play as one of 20 historical leaders including Roosevelt (America) and Victoria (England).	https://steamcdn-a.akamaihd.net/steam/apps/289070/header.jpg?t=1557332910;https://steamcdn-a.akamaihd.net/steam/apps/289070/ss_36c63ebeb006b246cb740fdafeb41bb20e3b330d.600x338.jpg?t=1557332910;https://steamcdn-a.akamaihd.net/steam/apps/289070/ss_cf53258cb8c4d283e52cf8dce3edf8656f83adc6.600x338.jpg?t=1557332910;https://steamcdn-a.akamaihd.net/steam/apps/289070/ss_f501156a69223131ee8b12452f3003698334e964.600x338.jpg?t=1557332910;https://steamcdn-a.akamaihd.net/steam/apps/289070/ss_2be9153a2633e671c283e2dbcec64e2e4543f66f.600x338.jpg?t=1557332910;https://steamcdn-a.akamaihd.net/steam/apps/289070/ss_a4b07a0fbdd09e35b5ec3a4726239b884f1f1f7d.600x338.jpg?t=1557332910;
Street Fighter V	Fighting	CAPCOM	16/2/2016	Experience the intensity of head-to-head battles with Street Fighter® V! Choose from 16 iconic characters, then battle against friends online or offline with a robust variety of match options.	https://steamcdn-a.akamaihd.net/steam/apps/310950/header.jpg?t=1556045737;https://steamcdn-a.akamaihd.net/steam/apps/310950/ss_1c9dbb6fa56b2adec0834cbd63aa68aecc87c3ab.600x338.jpg?t=1556045737;https://steamcdn-a.akamaihd.net/steam/apps/310950/ss_fe970e8ee0ef82da8f10625e1f5a685981571272.600x338.jpg?t=1556045737;https://steamcdn-a.akamaihd.net/steam/apps/310950/ss_44953932f4c215298b938e7e92964b925a347706.600x338.jpg?t=1556045737;https://steamcdn-a.akamaihd.net/steam/apps/310950/ss_7bff51db77820f6d8a401a12ad6a43d07aae7dd1.600x338.jpg?t=1556045737;
Tekken 7	Fighting	Bandai Namco Entertainment	2/6/2017	Discover the epic conclusion of the long-time clan warfare between members of the Mishima family. Powered by Unreal Engine 4, the legendary fighting game franchise fights back with stunning story-driven cinematic battles and intense duels that can be enjoyed with friends and rivals	https://steamcdn-a.akamaihd.net/steam/apps/389730/header.jpg?t=1553250048;https://steamcdn-a.akamaihd.net/steam/apps/389730/ss_d92a558644ad60ae5814fc4d2bbaebc5abf62fa3.600x338.jpg?t=1553250048;https://steamcdn-a.akamaihd.net/steam/apps/389730/ss_40faa5ba39563cb899f1ab2ddd2afbf8b451d52f.600x338.jpg?t=1553250048;https://steamcdn-a.akamaihd.net/steam/apps/389730/ss_ed3246605518907954918eb06e90705249be77d6.600x338.jpg?t=1553250048;
\.

--
-- Data for Name: library; Type: TABLE DATA; Schema: igdb; Owner: postgres
--

COPY igdb.library (user_id, game_id, category) FROM stdin;
14	1	1
14	2	2
14	3	3
14	4	4
14	30	1
14	31	2
14	32	3
14	33	4
14	34	1
14	35	2
14	36	3
14	37	4
\.


--
-- Data for Name: reviews; Type: TABLE DATA; Schema: igdb; Owner: postgres
--

COPY igdb.reviews (user_id, game_id, game_review, recommend, review_date, upvote, downvote) FROM stdin;
14	1	this game is so addictive!!	TRUE	1-1-2019	30	1
14	30	I know right?	TRUE	15-1-2019	0	100
14	31	No this game sucks. Boring. Waste my time.	FALSE	16-1-2019	11	3
14	32	I know right?	TRUE	15-1-2019	0	7
14	37	No this game sucks. Boring. Waste my time.	FALSE	16-1-2019	9	3
1	24	This is the best survival game I have ever played	TRUE	24-2-2018	20	3
2	24	This game ruined my friendship	FALSE	10-3-2016	90	1
3	24	Give me back my diadmonds!	FALSE	3-6-2019	1	90
4	24	I just killed every villager in a village and burned all their houses	TRUE	3-4-2019	0	100
5	24	Underwater combat sucks	FALSE	4-4-2019	0	60
6	24	Bow POWER 5 OP AF!	TRUE	5-5-2019	100	0
7	24	How can I get down from this?? SOYBOY???	FALSE	17-6-2019	0	999
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
