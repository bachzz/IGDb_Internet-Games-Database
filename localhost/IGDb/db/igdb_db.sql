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
\.

--
-- Data for Name: library; Type: TABLE DATA; Schema: igdb; Owner: postgres
--

-- COPY igdb.library (user_id, game_id, category) FROM stdin;
-- 14	1	1
-- 14	2	3
-- 14	3	3
-- 14	4	2
-- 1	1	1
-- 2	1	2
-- 3	2	2
-- \.


--
-- Data for Name: reviews; Type: TABLE DATA; Schema: igdb; Owner: postgres
--

-- COPY igdb.reviews (user_id, game_id, game_review, recommend, review_date) FROM stdin;
-- 2	1	this game is so addictive!!	TRUE	1-1-2019
-- 4	1	I know right?	TRUE	15-1-2019
-- 5	1	No this game sucks. Boring. Waste my time.	FALSE	16-1-2019
-- 14	1	I know right?	TRUE	15-1-2019
-- 14	2	No this game sucks. Boring. Waste my time.	FALSE	16-1-2019
-- \.


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
