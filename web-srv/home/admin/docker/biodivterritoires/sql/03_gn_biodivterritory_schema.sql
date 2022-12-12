--
-- PostgreSQL database dump
--

-- Dumped from database version 14.5 (Debian 14.5-2.pgdg110+2)
-- Dumped by pg_dump version 14.5 (Ubuntu 14.5-2.pgdg22.04+2)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: gn_biodivterritory; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA gn_biodivterritory;


--
-- Name: SCHEMA gn_biodivterritory; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON SCHEMA gn_biodivterritory IS '[LPO AURA]
Biodiv''Territories app management.';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: bib_datas_types; Type: TABLE; Schema: gn_biodivterritory; Owner: -
--

CREATE TABLE gn_biodivterritory.bib_datas_types (
    id_type integer NOT NULL,
    type_name character varying,
    type_protocol character varying,
    type_desc character varying
);


--
-- Name: TABLE bib_datas_types; Type: COMMENT; Schema: gn_biodivterritory; Owner: -
--

COMMENT ON TABLE gn_biodivterritory.bib_datas_types IS 'Data types dictionary.';


--
-- Name: bib_datas_types_id_type_seq; Type: SEQUENCE; Schema: gn_biodivterritory; Owner: -
--

CREATE SEQUENCE gn_biodivterritory.bib_datas_types_id_type_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: bib_datas_types_id_type_seq; Type: SEQUENCE OWNED BY; Schema: gn_biodivterritory; Owner: -
--

ALTER SEQUENCE gn_biodivterritory.bib_datas_types_id_type_seq OWNED BY gn_biodivterritory.bib_datas_types.id_type;


--
-- Name: bib_dynamic_pages_category; Type: TABLE; Schema: gn_biodivterritory; Owner: -
--

CREATE TABLE gn_biodivterritory.bib_dynamic_pages_category (
    id_category integer NOT NULL,
    category_name character varying,
    category_desc character varying
);


--
-- Name: TABLE bib_dynamic_pages_category; Type: COMMENT; Schema: gn_biodivterritory; Owner: -
--

COMMENT ON TABLE gn_biodivterritory.bib_dynamic_pages_category IS 'Dynamic pages categories dictionary.';


--
-- Name: bib_dynamic_pages_category_id_category_seq; Type: SEQUENCE; Schema: gn_biodivterritory; Owner: -
--

CREATE SEQUENCE gn_biodivterritory.bib_dynamic_pages_category_id_category_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: bib_dynamic_pages_category_id_category_seq; Type: SEQUENCE OWNED BY; Schema: gn_biodivterritory; Owner: -
--

ALTER SEQUENCE gn_biodivterritory.bib_dynamic_pages_category_id_category_seq OWNED BY gn_biodivterritory.bib_dynamic_pages_category.id_category;


--
-- Name: l_areas_type_selection; Type: TABLE; Schema: gn_biodivterritory; Owner: -
--

CREATE TABLE gn_biodivterritory.l_areas_type_selection (
    id_selection integer NOT NULL,
    id_type integer
);


--
-- Name: TABLE l_areas_type_selection; Type: COMMENT; Schema: gn_biodivterritory; Owner: -
--

COMMENT ON TABLE gn_biodivterritory.l_areas_type_selection IS 'List of areas types selected from ref_geo.bib_areas_types.';


--
-- Name: COLUMN l_areas_type_selection.id_type; Type: COMMENT; Schema: gn_biodivterritory; Owner: -
--

COMMENT ON COLUMN gn_biodivterritory.l_areas_type_selection.id_type IS 'reference to area id_type usable for app';


--
-- Name: l_areas_type_selection_id_selection_seq; Type: SEQUENCE; Schema: gn_biodivterritory; Owner: -
--

CREATE SEQUENCE gn_biodivterritory.l_areas_type_selection_id_selection_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: l_areas_type_selection_id_selection_seq; Type: SEQUENCE OWNED BY; Schema: gn_biodivterritory; Owner: -
--

ALTER SEQUENCE gn_biodivterritory.l_areas_type_selection_id_selection_seq OWNED BY gn_biodivterritory.l_areas_type_selection.id_selection;


--
-- Name: t_max_threatened_status; Type: TABLE; Schema: gn_biodivterritory; Owner: -
--

CREATE TABLE gn_biodivterritory.t_max_threatened_status (
    cd_nom integer NOT NULL,
    threatened boolean NOT NULL,
    redlist_statut character varying,
    redlist_context character varying,
    id_source integer
);


--
-- Name: TABLE t_max_threatened_status; Type: COMMENT; Schema: gn_biodivterritory; Owner: -
--

COMMENT ON TABLE gn_biodivterritory.t_max_threatened_status IS 'Threatened species table - with cd_nom and Red List source.';


--
-- Name: COLUMN t_max_threatened_status.cd_nom; Type: COMMENT; Schema: gn_biodivterritory; Owner: -
--

COMMENT ON COLUMN gn_biodivterritory.t_max_threatened_status.cd_nom IS 'Link to taxonomie.taxref';


--
-- Name: COLUMN t_max_threatened_status.id_source; Type: COMMENT; Schema: gn_biodivterritory; Owner: -
--

COMMENT ON COLUMN gn_biodivterritory.t_max_threatened_status.id_source IS 'Link to taxonomie.bib_redlist_source';


--
-- Name: mv_territory_general_stats; Type: MATERIALIZED VIEW; Schema: gn_biodivterritory; Owner: -
--

CREATE MATERIALIZED VIEW gn_biodivterritory.mv_territory_general_stats AS
 SELECT l_areas.id_area,
    bib_areas_types.type_code,
    l_areas.area_code,
    l_areas.area_name,
    count(DISTINCT synthese.id_synthese) AS count_data,
    count(DISTINCT taxref.cd_ref) AS count_taxa,
    count(DISTINCT taxref.cd_ref) FILTER (WHERE (t_max_threatened_status.threatened = true)) AS count_threatened,
    count(DISTINCT synthese.id_synthese) AS count_occtax,
    count(DISTINCT synthese.id_dataset) AS count_dataset,
    count(DISTINCT synthese.date_min) AS count_date,
    count(DISTINCT synthese.observers) AS count_observer,
    max(synthese.date_min) AS last_obs,
    l_areas.geom AS geom_local,
    public.st_transform(l_areas.geom, 4326) AS geom_4326
   FROM ((((((gn_synthese.synthese
     JOIN gn_synthese.cor_area_synthese ON ((synthese.id_synthese = cor_area_synthese.id_synthese)))
     JOIN ref_geo.l_areas ON ((cor_area_synthese.id_area = l_areas.id_area)))
     JOIN gn_biodivterritory.l_areas_type_selection ON ((l_areas_type_selection.id_type = l_areas.id_type)))
     JOIN ref_geo.bib_areas_types ON ((l_areas_type_selection.id_type = bib_areas_types.id_type)))
     JOIN taxonomie.taxref ON ((synthese.cd_nom = taxref.cd_nom)))
     LEFT JOIN gn_biodivterritory.t_max_threatened_status ON ((t_max_threatened_status.cd_nom = taxref.cd_ref)))
  WHERE (((taxref.id_rang)::text ~~ 'ES'::text) AND (taxref.cd_nom = taxref.cd_ref) AND (synthese.id_nomenclature_diffusion_level = ref_nomenclatures.get_id_nomenclature('NIV_PRECIS'::character varying, '5'::character varying)) AND (synthese.id_nomenclature_observation_status <> ref_nomenclatures.get_id_nomenclature('STATUT_OBS'::character varying, 'No'::character varying)) AND (l_areas.id_type IN ( SELECT l_areas_type_selection_1.id_type
           FROM gn_biodivterritory.l_areas_type_selection l_areas_type_selection_1)))
  GROUP BY l_areas.id_area, l_areas.area_code, l_areas.area_name, bib_areas_types.type_code, l_areas.geom
  WITH NO DATA;


--
-- Name: mv_area_ntile_limit; Type: MATERIALIZED VIEW; Schema: gn_biodivterritory; Owner: -
--

CREATE MATERIALIZED VIEW gn_biodivterritory.mv_area_ntile_limit AS
 WITH occtax AS (
         SELECT mv_territory_general_stats.id_area,
            mv_territory_general_stats.type_code,
            mv_territory_general_stats.count_occtax AS count,
            ntile(5) OVER (ORDER BY mv_territory_general_stats.count_occtax) AS ntile
           FROM gn_biodivterritory.mv_territory_general_stats
        ), taxa AS (
         SELECT mv_territory_general_stats.id_area,
            mv_territory_general_stats.type_code,
            mv_territory_general_stats.count_taxa AS count,
            ntile(5) OVER (ORDER BY mv_territory_general_stats.count_taxa) AS ntile
           FROM gn_biodivterritory.mv_territory_general_stats
        ), threatened AS (
         SELECT mv_territory_general_stats.id_area,
            mv_territory_general_stats.type_code,
            mv_territory_general_stats.count_taxa AS count,
            ntile(5) OVER (ORDER BY mv_territory_general_stats.count_threatened) AS ntile
           FROM gn_biodivterritory.mv_territory_general_stats
        ), observer AS (
         SELECT mv_territory_general_stats.id_area,
            mv_territory_general_stats.type_code,
            mv_territory_general_stats.count_observer AS count,
            ntile(5) OVER (ORDER BY mv_territory_general_stats.count_observer) AS ntile
           FROM gn_biodivterritory.mv_territory_general_stats
        ), date AS (
         SELECT mv_territory_general_stats.id_area,
            mv_territory_general_stats.type_code,
            mv_territory_general_stats.count_date AS count,
            ntile(5) OVER (ORDER BY mv_territory_general_stats.count_date) AS ntile
           FROM gn_biodivterritory.mv_territory_general_stats
        ), u AS (
         SELECT 'occtax'::text AS type,
            min(occtax.count) AS min,
            max(occtax.count) AS max,
            occtax.ntile
           FROM occtax
          GROUP BY occtax.ntile
        UNION
         SELECT 'taxa'::text AS text,
            min(taxa.count) AS min,
            max(taxa.count) AS max,
            taxa.ntile
           FROM taxa
          GROUP BY taxa.ntile
        UNION
         SELECT 'threatened'::text AS text,
            min(taxa.count) AS min,
            max(taxa.count) AS max,
            taxa.ntile
           FROM taxa
          GROUP BY taxa.ntile
        UNION
         SELECT 'observer'::text AS text,
            min(observer.count) AS min,
            max(observer.count) AS max,
            observer.ntile
           FROM observer
          GROUP BY observer.ntile
        UNION
         SELECT 'date'::text AS text,
            min(date.count) AS min,
            max(date.count) AS max,
            date.ntile
           FROM date
          GROUP BY date.ntile
        )
 SELECT row_number() OVER () AS id,
    u.type,
    u.min,
    u.max,
    u.ntile
   FROM u
  ORDER BY u.type, u.ntile
  WITH NO DATA;


--
-- Name: mv_general_stats; Type: MATERIALIZED VIEW; Schema: gn_biodivterritory; Owner: -
--

CREATE MATERIALIZED VIEW gn_biodivterritory.mv_general_stats AS
 WITH count_occtax AS (
         SELECT count(*) AS count
           FROM ( SELECT DISTINCT synthese.id_synthese
                   FROM gn_synthese.synthese) t
        ), count_observer AS (
         SELECT count(*) AS count
           FROM ( SELECT DISTINCT synthese.observers
                   FROM gn_synthese.synthese) t
        ), count_taxa AS (
         SELECT count(*) AS count
           FROM ( SELECT DISTINCT taxref.cd_ref
                   FROM (gn_synthese.synthese
                     JOIN taxonomie.taxref ON (((synthese.cd_nom = taxref.cd_nom) AND ((taxref.id_rang)::text = 'ES'::text))))) t
        ), count_dataset AS (
         SELECT count(*) AS count
           FROM ( SELECT DISTINCT synthese.id_dataset
                   FROM gn_synthese.synthese) t
        )
 SELECT row_number() OVER () AS id,
    count_occtax.count AS count_occtax,
    count_observer.count AS count_observer,
    count_taxa.count AS count_taxa,
    count_dataset.count AS count_dataset
   FROM count_occtax,
    count_observer,
    count_dataset,
    count_taxa
  WITH NO DATA;


--
-- Name: mv_l_areas_autocomplete; Type: MATERIALIZED VIEW; Schema: gn_biodivterritory; Owner: -
--

CREATE MATERIALIZED VIEW gn_biodivterritory.mv_l_areas_autocomplete AS
 SELECT DISTINCT l_areas.id_area AS id,
    bib_areas_types.type_name,
    lower(public.unaccent((l_areas.area_name)::text)) AS search_area_name,
    bib_areas_types.type_desc,
    bib_areas_types.type_code,
    l_areas.area_name,
    l_areas.area_code
   FROM (((ref_geo.bib_areas_types
     LEFT JOIN ref_geo.l_areas ON ((l_areas.id_type = bib_areas_types.id_type)))
     JOIN gn_synthese.cor_area_synthese USING (id_area))
     JOIN gn_biodivterritory.l_areas_type_selection ON ((l_areas.id_type = l_areas_type_selection.id_type)))
  WHERE (cor_area_synthese.id_area IS NOT NULL)
  WITH NO DATA;


--
-- Name: t_dynamic_pages; Type: TABLE; Schema: gn_biodivterritory; Owner: -
--

CREATE TABLE gn_biodivterritory.t_dynamic_pages (
    id_page integer NOT NULL,
    id_category integer,
    title character varying,
    link_name character varying,
    navbar_link boolean,
    navbar_link_order integer,
    url character varying,
    short_desc character varying,
    ts_create timestamp without time zone,
    ts_update timestamp without time zone,
    creator character varying,
    is_active boolean,
    content text
);


--
-- Name: TABLE t_dynamic_pages; Type: COMMENT; Schema: gn_biodivterritory; Owner: -
--

COMMENT ON TABLE gn_biodivterritory.t_dynamic_pages IS 'Dynamic pages table - with category.';


--
-- Name: COLUMN t_dynamic_pages.id_category; Type: COMMENT; Schema: gn_biodivterritory; Owner: -
--

COMMENT ON COLUMN gn_biodivterritory.t_dynamic_pages.id_category IS 'Link to gn_biodivterritory.bib_dynamic_pages_category';


--
-- Name: t_dynamic_pages_id_page_seq; Type: SEQUENCE; Schema: gn_biodivterritory; Owner: -
--

CREATE SEQUENCE gn_biodivterritory.t_dynamic_pages_id_page_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: t_dynamic_pages_id_page_seq; Type: SEQUENCE OWNED BY; Schema: gn_biodivterritory; Owner: -
--

ALTER SEQUENCE gn_biodivterritory.t_dynamic_pages_id_page_seq OWNED BY gn_biodivterritory.t_dynamic_pages.id_page;


--
-- Name: t_max_threatened_status_20221116; Type: TABLE; Schema: gn_biodivterritory; Owner: -
--

CREATE TABLE gn_biodivterritory.t_max_threatened_status_20221116 (
    cd_nom integer,
    threatened boolean,
    redlist_statut character varying,
    redlist_context character varying,
    id_source integer
);


--
-- Name: t_max_threatened_status_cd_nom_seq; Type: SEQUENCE; Schema: gn_biodivterritory; Owner: -
--

CREATE SEQUENCE gn_biodivterritory.t_max_threatened_status_cd_nom_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: t_max_threatened_status_cd_nom_seq; Type: SEQUENCE OWNED BY; Schema: gn_biodivterritory; Owner: -
--

ALTER SEQUENCE gn_biodivterritory.t_max_threatened_status_cd_nom_seq OWNED BY gn_biodivterritory.t_max_threatened_status.cd_nom;


--
-- Name: t_released_datas; Type: TABLE; Schema: gn_biodivterritory; Owner: -
--

CREATE TABLE gn_biodivterritory.t_released_datas (
    id_data_release integer NOT NULL,
    id_type integer,
    data_name character varying,
    data_desc text,
    data_url character varying
);


--
-- Name: COLUMN t_released_datas.id_type; Type: COMMENT; Schema: gn_biodivterritory; Owner: -
--

COMMENT ON COLUMN gn_biodivterritory.t_released_datas.id_type IS 'Link to gn_biodivterritory.bib_datas_types';


--
-- Name: t_released_datas_id_data_release_seq; Type: SEQUENCE; Schema: gn_biodivterritory; Owner: -
--

CREATE SEQUENCE gn_biodivterritory.t_released_datas_id_data_release_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: t_released_datas_id_data_release_seq; Type: SEQUENCE OWNED BY; Schema: gn_biodivterritory; Owner: -
--

ALTER SEQUENCE gn_biodivterritory.t_released_datas_id_data_release_seq OWNED BY gn_biodivterritory.t_released_datas.id_data_release;


--
-- Name: bib_datas_types id_type; Type: DEFAULT; Schema: gn_biodivterritory; Owner: -
--

ALTER TABLE ONLY gn_biodivterritory.bib_datas_types ALTER COLUMN id_type SET DEFAULT nextval('gn_biodivterritory.bib_datas_types_id_type_seq'::regclass);


--
-- Name: bib_dynamic_pages_category id_category; Type: DEFAULT; Schema: gn_biodivterritory; Owner: -
--

ALTER TABLE ONLY gn_biodivterritory.bib_dynamic_pages_category ALTER COLUMN id_category SET DEFAULT nextval('gn_biodivterritory.bib_dynamic_pages_category_id_category_seq'::regclass);


--
-- Name: l_areas_type_selection id_selection; Type: DEFAULT; Schema: gn_biodivterritory; Owner: -
--

ALTER TABLE ONLY gn_biodivterritory.l_areas_type_selection ALTER COLUMN id_selection SET DEFAULT nextval('gn_biodivterritory.l_areas_type_selection_id_selection_seq'::regclass);


--
-- Name: t_dynamic_pages id_page; Type: DEFAULT; Schema: gn_biodivterritory; Owner: -
--

ALTER TABLE ONLY gn_biodivterritory.t_dynamic_pages ALTER COLUMN id_page SET DEFAULT nextval('gn_biodivterritory.t_dynamic_pages_id_page_seq'::regclass);


--
-- Name: t_max_threatened_status cd_nom; Type: DEFAULT; Schema: gn_biodivterritory; Owner: -
--

ALTER TABLE ONLY gn_biodivterritory.t_max_threatened_status ALTER COLUMN cd_nom SET DEFAULT nextval('gn_biodivterritory.t_max_threatened_status_cd_nom_seq'::regclass);


--
-- Name: t_released_datas id_data_release; Type: DEFAULT; Schema: gn_biodivterritory; Owner: -
--

ALTER TABLE ONLY gn_biodivterritory.t_released_datas ALTER COLUMN id_data_release SET DEFAULT nextval('gn_biodivterritory.t_released_datas_id_data_release_seq'::regclass);



--
-- Name: bib_datas_types bib_datas_types_pkey; Type: CONSTRAINT; Schema: gn_biodivterritory; Owner: -; Tablespace: indexes
--

ALTER TABLE ONLY gn_biodivterritory.bib_datas_types
    ADD CONSTRAINT bib_datas_types_pkey PRIMARY KEY (id_type);


--
-- Name: bib_dynamic_pages_category bib_dynamic_pages_category_pkey; Type: CONSTRAINT; Schema: gn_biodivterritory; Owner: -; Tablespace: indexes
--

ALTER TABLE ONLY gn_biodivterritory.bib_dynamic_pages_category
    ADD CONSTRAINT bib_dynamic_pages_category_pkey PRIMARY KEY (id_category);


--
-- Name: l_areas_type_selection l_areas_type_selection_pkey; Type: CONSTRAINT; Schema: gn_biodivterritory; Owner: -; Tablespace: indexes
--

ALTER TABLE ONLY gn_biodivterritory.l_areas_type_selection
    ADD CONSTRAINT l_areas_type_selection_pkey PRIMARY KEY (id_selection);


--
-- Name: t_dynamic_pages t_dynamic_pages_link_name_key; Type: CONSTRAINT; Schema: gn_biodivterritory; Owner: -; Tablespace: indexes
--

ALTER TABLE ONLY gn_biodivterritory.t_dynamic_pages
    ADD CONSTRAINT t_dynamic_pages_link_name_key UNIQUE (link_name);


--
-- Name: t_dynamic_pages t_dynamic_pages_pkey; Type: CONSTRAINT; Schema: gn_biodivterritory; Owner: -; Tablespace: indexes
--

ALTER TABLE ONLY gn_biodivterritory.t_dynamic_pages
    ADD CONSTRAINT t_dynamic_pages_pkey PRIMARY KEY (id_page);


--
-- Name: t_dynamic_pages t_dynamic_pages_url_key; Type: CONSTRAINT; Schema: gn_biodivterritory; Owner: -; Tablespace: indexes
--

ALTER TABLE ONLY gn_biodivterritory.t_dynamic_pages
    ADD CONSTRAINT t_dynamic_pages_url_key UNIQUE (url);


--
-- Name: t_max_threatened_status t_max_threatened_status_pkey; Type: CONSTRAINT; Schema: gn_biodivterritory; Owner: -; Tablespace: indexes
--

ALTER TABLE ONLY gn_biodivterritory.t_max_threatened_status
    ADD CONSTRAINT t_max_threatened_status_pkey PRIMARY KEY (cd_nom);


--
-- Name: t_released_datas t_released_datas_pkey; Type: CONSTRAINT; Schema: gn_biodivterritory; Owner: -; Tablespace: indexes
--

ALTER TABLE ONLY gn_biodivterritory.t_released_datas
    ADD CONSTRAINT t_released_datas_pkey PRIMARY KEY (id_data_release);



--
-- Name: l_areas_type_selection_id_type_idx; Type: INDEX; Schema: gn_biodivterritory; Owner: -
--

CREATE INDEX l_areas_type_selection_id_type_idx ON gn_biodivterritory.l_areas_type_selection USING btree (id_type);



--
-- Name: mv_territory_general_stats_area_code_idx; Type: INDEX; Schema: gn_biodivterritory; Owner: -; Tablespace: indexes
--

CREATE INDEX mv_territory_general_stats_area_code_idx ON gn_biodivterritory.mv_territory_general_stats USING btree (area_code);


--
-- Name: mv_territory_general_stats_area_name_idx; Type: INDEX; Schema: gn_biodivterritory; Owner: -; Tablespace: indexes
--

CREATE INDEX mv_territory_general_stats_area_name_idx ON gn_biodivterritory.mv_territory_general_stats USING btree (area_name);


--
-- Name: mv_territory_general_stats_geom_4326_idx; Type: INDEX; Schema: gn_biodivterritory; Owner: -; Tablespace: indexes
--

CREATE INDEX mv_territory_general_stats_geom_4326_idx ON gn_biodivterritory.mv_territory_general_stats USING gist (geom_4326);


--
-- Name: mv_territory_general_stats_geom_local_idx; Type: INDEX; Schema: gn_biodivterritory; Owner: -; Tablespace: indexes
--

CREATE INDEX mv_territory_general_stats_geom_local_idx ON gn_biodivterritory.mv_territory_general_stats USING gist (geom_local);


--
-- Name: mv_territory_general_stats_id_area_idx; Type: INDEX; Schema: gn_biodivterritory; Owner: -; Tablespace: indexes
--

CREATE UNIQUE INDEX mv_territory_general_stats_id_area_idx ON gn_biodivterritory.mv_territory_general_stats USING btree (id_area);


--
-- Name: mv_territory_general_stats_type_code_idx; Type: INDEX; Schema: gn_biodivterritory; Owner: -; Tablespace: indexes
--

CREATE INDEX mv_territory_general_stats_type_code_idx ON gn_biodivterritory.mv_territory_general_stats USING btree (type_code);


--
-- Name: l_areas_type_selection l_areas_type_selection_id_type_fkey; Type: FK CONSTRAINT; Schema: gn_biodivterritory; Owner: -
--

ALTER TABLE ONLY gn_biodivterritory.l_areas_type_selection
    ADD CONSTRAINT l_areas_type_selection_id_type_fkey FOREIGN KEY (id_type) REFERENCES ref_geo.bib_areas_types(id_type);


--
-- Name: t_dynamic_pages t_dynamic_pages_id_category_fkey; Type: FK CONSTRAINT; Schema: gn_biodivterritory; Owner: -
--

ALTER TABLE ONLY gn_biodivterritory.t_dynamic_pages
    ADD CONSTRAINT t_dynamic_pages_id_category_fkey FOREIGN KEY (id_category) REFERENCES gn_biodivterritory.bib_dynamic_pages_category(id_category);


--
-- Name: t_max_threatened_status t_max_threatened_status_id_source_fkey; Type: FK CONSTRAINT; Schema: gn_biodivterritory; Owner: -
--

ALTER TABLE ONLY gn_biodivterritory.t_max_threatened_status
    ADD CONSTRAINT t_max_threatened_status_id_source_fkey FOREIGN KEY (id_source) REFERENCES taxonomie.bib_c_redlist_source(id_source);


--
-- Name: t_released_datas t_released_datas_id_type_fkey; Type: FK CONSTRAINT; Schema: gn_biodivterritory; Owner: -
--

ALTER TABLE ONLY gn_biodivterritory.t_released_datas
    ADD CONSTRAINT t_released_datas_id_type_fkey FOREIGN KEY (id_type) REFERENCES gn_biodivterritory.bib_datas_types(id_type);


--
-- PostgreSQL database dump complete
--

