--
-- PostgreSQL database dump
--
-- Dumped from database version 14.5 (Debian 14.5-2.pgdg110+2)
-- Dumped by pg_dump version 14.5 (Ubuntu 14.5-2.pgdg22.04+2)
SET statement_timeout = 0;

SET lock_timeout = 0;

SET idle_in_transaction_session_timeout = 0;

SET client_encoding = 'UTF8';

SET standard_conforming_strings = ON;

SELECT
    pg_catalog.set_config('search_path', '', FALSE);

SET check_function_bodies = FALSE;

SET xmloption = content;

SET client_min_messages = warning;

SET row_security = OFF;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: bib_c_redlist_categories; Type: TABLE; Schema: taxonomie; Owner: -
--
CREATE TABLE taxonomie.bib_c_redlist_categories (
    code_category character varying NOT NULL,
    threatened boolean,
    sup_category character varying,
    priority_order integer,
    name_fr character varying,
    desc_fr character varying
);

--
-- Name: TABLE bib_c_redlist_categories; Type: COMMENT; Schema: taxonomie; Owner: -
--
COMMENT ON TABLE taxonomie.bib_c_redlist_categories IS 'Liste des catégories de statuts de liste rouge';

--
-- Name: bib_c_redlist_source; Type: TABLE; Schema: taxonomie; Owner: -
--
CREATE TABLE taxonomie.bib_c_redlist_source (
    id_source integer NOT NULL,
    name_source character varying,
    desc_source character varying,
    url_source character varying,
    context character varying,
    area_name character varying,
    area_code character varying,
    area_type character varying,
    priority integer,
    version character varying,
    enable boolean
);

--
-- Name: TABLE bib_c_redlist_source; Type: COMMENT; Schema: taxonomie; Owner: -
--
COMMENT ON TABLE taxonomie.bib_c_redlist_source IS 'Red List sources dictionnary.';

--
-- Name: COLUMN bib_c_redlist_source.version; Type: COMMENT; Schema: taxonomie; Owner: -
--
COMMENT ON COLUMN taxonomie.bib_c_redlist_source.version IS 'Version de la liste (année, numéro de version)';

--
-- Name: COLUMN bib_c_redlist_source.enable; Type: COMMENT; Schema: taxonomie; Owner: -
--
COMMENT ON COLUMN taxonomie.bib_c_redlist_source.enable IS 'Source active';

--
-- Name: t_c_redlist; Type: TABLE; Schema: taxonomie; Owner: -
--
CREATE TABLE taxonomie.t_c_redlist (
    id_redlist integer NOT NULL,
    status_order integer,
    cd_nom integer,
    cd_ref integer,
    category character varying,
    criteria character varying,
    id_source integer
);

--
-- Name: TABLE t_c_redlist; Type: COMMENT; Schema: taxonomie; Owner: -
--
COMMENT ON TABLE taxonomie.t_c_redlist IS 'Liste des sources de statuts de liste rouge';

--
-- Name: COLUMN t_c_redlist.cd_nom; Type: COMMENT; Schema: taxonomie; Owner: -
--
COMMENT ON COLUMN taxonomie.t_c_redlist.cd_nom IS 'Link to taxonomie.taxref';

--
-- Name: COLUMN t_c_redlist.category; Type: COMMENT; Schema: taxonomie; Owner: -
--
COMMENT ON COLUMN taxonomie.t_c_redlist.category IS 'Link to bib_redlist_categories';

--
-- Name: COLUMN t_c_redlist.id_source; Type: COMMENT; Schema: taxonomie; Owner: -
--
COMMENT ON COLUMN taxonomie.t_c_redlist.id_source IS 'Link to bib_redlist_source';

--
-- Name: bib_redlist_source_id_source_seq; Type: SEQUENCE; Schema: taxonomie; Owner: -
--
CREATE SEQUENCE taxonomie.bib_redlist_source_id_source_seq
    AS integer START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

--
-- Name: bib_redlist_source_id_source_seq; Type: SEQUENCE OWNED BY; Schema: taxonomie; Owner: -
--
ALTER SEQUENCE taxonomie.bib_redlist_source_id_source_seq OWNED BY taxonomie.bib_c_redlist_source.id_source;

--
-- Name: cor_c_redlist_source_area; Type: TABLE; Schema: taxonomie; Owner: -
--
CREATE TABLE taxonomie.cor_c_redlist_source_area (
    id_cor_redlist_source_area integer NOT NULL,
    id_area integer,
    id_source integer
);

--
-- Name: TABLE cor_c_redlist_source_area; Type: COMMENT; Schema: taxonomie; Owner: -
--
COMMENT ON TABLE taxonomie.cor_c_redlist_source_area IS 'Correlation between RedList sources (bib_redlist_source) and areas (ref_geo.l_areas) : defines where Red List sources apply.';

--
-- Name: COLUMN cor_c_redlist_source_area.id_area; Type: COMMENT; Schema: taxonomie; Owner: -
--
COMMENT ON COLUMN taxonomie.cor_c_redlist_source_area.id_area IS 'Link to ref_geo.l_areas';

--
-- Name: COLUMN cor_c_redlist_source_area.id_source; Type: COMMENT; Schema: taxonomie; Owner: -
--
COMMENT ON COLUMN taxonomie.cor_c_redlist_source_area.id_source IS 'Link to bib_redlist_source';

--
-- Name: cor_redlist_source_area_id_cor_redlist_source_area_seq; Type: SEQUENCE; Schema: taxonomie; Owner: -
--
CREATE SEQUENCE taxonomie.cor_redlist_source_area_id_cor_redlist_source_area_seq
    AS integer START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

--
-- Name: cor_redlist_source_area_id_cor_redlist_source_area_seq; Type: SEQUENCE OWNED BY; Schema: taxonomie; Owner: -
--
ALTER SEQUENCE taxonomie.cor_redlist_source_area_id_cor_redlist_source_area_seq OWNED BY taxonomie.cor_c_redlist_source_area.id_cor_redlist_source_area;

--
-- Name: t_redlist_id_redlist_seq; Type: SEQUENCE; Schema: taxonomie; Owner: -
--
CREATE SEQUENCE taxonomie.t_redlist_id_redlist_seq
    AS integer START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

--
-- Name: t_redlist_id_redlist_seq; Type: SEQUENCE OWNED BY; Schema: taxonomie; Owner: -
--
ALTER SEQUENCE taxonomie.t_redlist_id_redlist_seq OWNED BY taxonomie.t_c_redlist.id_redlist;

--
-- Name: bib_c_redlist_source id_source; Type: DEFAULT; Schema: taxonomie; Owner: -
--
ALTER TABLE ONLY taxonomie.bib_c_redlist_source
    ALTER COLUMN id_source SET DEFAULT nextval('taxonomie.bib_redlist_source_id_source_seq'::regclass);

--
-- Name: cor_c_redlist_source_area id_cor_redlist_source_area; Type: DEFAULT; Schema: taxonomie; Owner: -
--
ALTER TABLE ONLY taxonomie.cor_c_redlist_source_area
    ALTER COLUMN id_cor_redlist_source_area SET DEFAULT nextval('taxonomie.cor_redlist_source_area_id_cor_redlist_source_area_seq'::regclass);

--
-- Name: t_c_redlist id_redlist; Type: DEFAULT; Schema: taxonomie; Owner: -
--
ALTER TABLE ONLY taxonomie.t_c_redlist
    ALTER COLUMN id_redlist SET DEFAULT nextval('taxonomie.t_redlist_id_redlist_seq'::regclass);

SET default_tablespace = '';

--
-- Name: bib_c_redlist_categories bib_redlist_categories_pkey; Type: CONSTRAINT; Schema: taxonomie; Owner: -; Tablespace: indexes
--
ALTER TABLE ONLY taxonomie.bib_c_redlist_categories
    ADD CONSTRAINT bib_redlist_categories_pkey PRIMARY KEY (code_category);

--
-- Name: bib_c_redlist_source bib_redlist_source_pkey; Type: CONSTRAINT; Schema: taxonomie; Owner: -; Tablespace: indexes
--
ALTER TABLE ONLY taxonomie.bib_c_redlist_source
    ADD CONSTRAINT bib_redlist_source_pkey PRIMARY KEY (id_source);

--
-- Name: cor_c_redlist_source_area cor_redlist_source_area_pkey; Type: CONSTRAINT; Schema: taxonomie; Owner: -; Tablespace: indexes
--
ALTER TABLE ONLY taxonomie.cor_c_redlist_source_area
    ADD CONSTRAINT cor_redlist_source_area_pkey PRIMARY KEY (id_cor_redlist_source_area);

--
-- Name: t_c_redlist t_redlist_pkey; Type: CONSTRAINT; Schema: taxonomie; Owner: -; Tablespace: indexes
--
ALTER TABLE ONLY taxonomie.t_c_redlist
    ADD CONSTRAINT t_redlist_pkey PRIMARY KEY (id_redlist);

--
-- Name: cor_c_redlist_source_area cor_redlist_source_area_id_area_fkey; Type: FK CONSTRAINT; Schema: taxonomie; Owner: -
--
ALTER TABLE ONLY taxonomie.cor_c_redlist_source_area
    ADD CONSTRAINT cor_redlist_source_area_id_area_fkey FOREIGN KEY (id_area) REFERENCES ref_geo.l_areas (id_area);

--
-- Name: cor_c_redlist_source_area cor_redlist_source_area_id_source_fkey; Type: FK CONSTRAINT; Schema: taxonomie; Owner: -
--
ALTER TABLE ONLY taxonomie.cor_c_redlist_source_area
    ADD CONSTRAINT cor_redlist_source_area_id_source_fkey FOREIGN KEY (id_source) REFERENCES taxonomie.bib_c_redlist_source (id_source);

--
-- Name: t_c_redlist fk_id_source; Type: FK CONSTRAINT; Schema: taxonomie; Owner: -
--
ALTER TABLE ONLY taxonomie.t_c_redlist
    ADD CONSTRAINT fk_id_source FOREIGN KEY (id_source) REFERENCES taxonomie.bib_c_redlist_source (id_source);

--
-- PostgreSQL database dump complete
--
