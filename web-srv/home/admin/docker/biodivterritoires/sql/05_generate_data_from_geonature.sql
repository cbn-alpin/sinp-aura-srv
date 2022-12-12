
INSERT INTO gn_biodivterritory.l_areas_type_selection (id_type)
	SELECT id_type
	FROM ref_geo.bib_areas_types
	WHERE type_code IN ('COM', 'M1') ;


REFRESH MATERIALIZED VIEW gn_biodivterritory.mv_l_areas_autocomplete ;
REFRESH MATERIALIZED VIEW gn_biodivterritory.mv_territory_general_stats;
REFRESH MATERIALIZED VIEW gn_biodivterritory.mv_area_ntile_limit ;
REFRESH MATERIALIZED VIEW gn_biodivterritory.mv_general_stats ;
