-- Suppression de toutes les données de Flavia associées à la source ""
-- Si la table `gn2pg_flavia.data_json` existe, les triggers sont déclenchés.
-- Usage: psql -h "localhost" -U "<db-owner-name>" -d "<db-name>" -f <path-to-this-sql-file>
-- Ex.: psql -h "localhost" -U "geonatadmin" -d "geonature2db" -f ~/data/flavia/data/sql/update/001_*

BEGIN ;


\echo '-------------------------------------------------------------------------------'
\echo 'OBSERVATIONS SYNTHESE'

\echo 'Deletion in cor_area_synthese'
DELETE FROM gn_synthese.cor_area_synthese AS cas
USING gn_synthese.synthese AS sy,
    gn_synthese.t_sources AS so
WHERE cas.id_synthese = sy.id_synthese
    AND sy.id_source = so.id_source
    AND so.name_source = 'flavia' ;

\echo 'Deletion in synthese'
DELETE FROM gn_synthese.synthese AS sy
USING gn_synthese.t_sources AS so
WHERE sy.id_source = so.id_source
    AND so.name_source = 'flavia' ;


\echo '-------------------------------------------------------------------------------'
\echo 'DATASETS'

\echo 'Deletion in cor_dataset_actor'
DELETE FROM gn_meta.cor_dataset_actor AS act
WHERE NOT EXISTS (
	SELECT TRUE
	FROM gn_synthese.synthese AS sy
	WHERE sy.id_dataset = act.id_dataset
) ;

\echo 'Deletion in cor_dataset_territory'
DELETE FROM gn_meta.cor_dataset_territory AS te
WHERE NOT EXISTS (
	SELECT TRUE
	FROM gn_synthese.synthese AS sy
	WHERE sy.id_dataset = te.id_dataset
) ;

\echo 'Deletion in cor_dataset_protocol'
DELETE FROM gn_meta.cor_dataset_protocol AS pro
WHERE NOT EXISTS (
	SELECT TRUE
	FROM gn_synthese.synthese AS sy
	WHERE sy.id_dataset = pro.id_dataset
) ;

\echo 'Deletion in t_datasets'
DELETE FROM gn_meta.t_datasets AS da
WHERE NOT EXISTS (
	SELECT TRUE
	FROM gn_synthese.synthese AS sy
	WHERE sy.id_dataset = da.id_dataset
) ;


\echo '-------------------------------------------------------------------------------'
\echo 'ACQUISITION FRAMEWORKS'

\echo 'Deletion in cor_acquisition_framework_actor'
DELETE FROM gn_meta.cor_acquisition_framework_actor AS act
USING gn_meta.t_acquisition_frameworks AS af
WHERE act.id_acquisition_framework = af.id_acquisition_framework
    AND NOT EXISTS (
        SELECT TRUE
        FROM  gn_meta.t_acquisition_frameworks AS afp
        WHERE afp.acquisition_framework_parent_id = af.id_acquisition_framework
    )
    AND NOT EXISTS (
        SELECT TRUE
        FROM gn_meta.t_datasets AS da
        WHERE da.id_acquisition_framework = af.id_acquisition_framework
    ) ;

\echo 'Deletion in cor_acquisition_framework_objectif'
DELETE FROM gn_meta.cor_acquisition_framework_objectif AS obj
USING gn_meta.t_acquisition_frameworks AS af
WHERE obj.id_acquisition_framework = af.id_acquisition_framework
    AND NOT EXISTS (
        SELECT TRUE
        FROM  gn_meta.t_acquisition_frameworks AS afp
        WHERE afp.acquisition_framework_parent_id = af.id_acquisition_framework
    )
    AND NOT EXISTS (
        SELECT TRUE
        FROM gn_meta.t_datasets AS da
        WHERE da.id_acquisition_framework = af.id_acquisition_framework
    ) ;

\echo 'Deletion in cor_acquisition_framework_publication'
DELETE FROM gn_meta.cor_acquisition_framework_publication AS pub
USING gn_meta.t_acquisition_frameworks AS af
WHERE pub.id_acquisition_framework = af.id_acquisition_framework
    AND NOT EXISTS (
        SELECT TRUE
        FROM  gn_meta.t_acquisition_frameworks AS afp
        WHERE afp.acquisition_framework_parent_id = af.id_acquisition_framework
    )
    AND NOT EXISTS (
        SELECT TRUE
        FROM gn_meta.t_datasets AS da
        WHERE da.id_acquisition_framework = af.id_acquisition_framework
    ) ;

\echo 'Deletion in cor_acquisition_framework_voletsinp'
DELETE FROM gn_meta.cor_acquisition_framework_voletsinp AS vol
USING gn_meta.t_acquisition_frameworks AS af
WHERE vol.id_acquisition_framework = af.id_acquisition_framework
    AND NOT EXISTS (
        SELECT TRUE
        FROM  gn_meta.t_acquisition_frameworks AS afp
        WHERE afp.acquisition_framework_parent_id = af.id_acquisition_framework
    )
    AND NOT EXISTS (
        SELECT TRUE
        FROM gn_meta.t_datasets AS da
        WHERE da.id_acquisition_framework = af.id_acquisition_framework
    ) ;

\echo 'Deletion in t_acquisition_frameworks'
DELETE FROM gn_meta.t_acquisition_frameworks AS af
WHERE NOT EXISTS (
        SELECT TRUE
        FROM  gn_meta.t_acquisition_frameworks AS afp
        WHERE afp.acquisition_framework_parent_id = af.id_acquisition_framework
    )
    AND NOT EXISTS (
        SELECT TRUE
        FROM gn_meta.t_datasets AS da
        WHERE da.id_acquisition_framework = af.id_acquisition_framework
    ) ;


\echo '-------------------------------------------------------------------------------'
\echo 'ACQUISITION FRAMEWORKS - PARENTS'

\echo 'Deletion in cor_acquisition_framework_actor for parents AF'
DELETE FROM gn_meta.cor_acquisition_framework_actor AS act
USING gn_meta.t_acquisition_frameworks AS af
WHERE act.id_acquisition_framework = af.id_acquisition_framework
    AND NOT EXISTS (
        SELECT TRUE
        FROM  gn_meta.t_acquisition_frameworks AS afp
        WHERE afp.acquisition_framework_parent_id = af.id_acquisition_framework
    )
    AND af.is_parent = TRUE
    AND NOT EXISTS (
        SELECT TRUE
        FROM gn_meta.t_datasets AS da
        WHERE da.id_acquisition_framework = af.id_acquisition_framework
    ) ;

\echo 'Deletion in cor_acquisition_framework_objectif for parents AF'
DELETE FROM gn_meta.cor_acquisition_framework_objectif AS obj
USING gn_meta.t_acquisition_frameworks AS af
WHERE obj.id_acquisition_framework = af.id_acquisition_framework
    AND NOT EXISTS (
        SELECT TRUE
        FROM  gn_meta.t_acquisition_frameworks AS afp
        WHERE afp.acquisition_framework_parent_id = af.id_acquisition_framework
    )
    AND af.is_parent = TRUE
    AND NOT EXISTS (
        SELECT TRUE
        FROM gn_meta.t_datasets AS da
        WHERE da.id_acquisition_framework = af.id_acquisition_framework
    ) ;

\echo 'Deletion in cor_acquisition_framework_publication for parents AF'
DELETE FROM gn_meta.cor_acquisition_framework_publication AS pub
USING gn_meta.t_acquisition_frameworks AS af
WHERE pub.id_acquisition_framework = af.id_acquisition_framework
    AND NOT EXISTS (
        SELECT TRUE
        FROM  gn_meta.t_acquisition_frameworks AS afp
        WHERE afp.acquisition_framework_parent_id = af.id_acquisition_framework
    )
    AND af.is_parent = TRUE
    AND NOT EXISTS (
        SELECT TRUE
        FROM gn_meta.t_datasets AS da
        WHERE da.id_acquisition_framework = af.id_acquisition_framework
    ) ;

\echo 'Deletion in cor_acquisition_framework_voletsinp for parents AF'
DELETE FROM gn_meta.cor_acquisition_framework_voletsinp AS vol
USING gn_meta.t_acquisition_frameworks AS af
WHERE vol.id_acquisition_framework = af.id_acquisition_framework
    AND NOT EXISTS (
        SELECT TRUE
        FROM  gn_meta.t_acquisition_frameworks AS afp
        WHERE afp.acquisition_framework_parent_id = af.id_acquisition_framework
    )
    AND af.is_parent = TRUE
    AND NOT EXISTS (
        SELECT TRUE
        FROM gn_meta.t_datasets AS da
        WHERE da.id_acquisition_framework = af.id_acquisition_framework
    ) ;

\echo 'Deletion in t_acquisition_frameworks for parents AF'
DELETE FROM gn_meta.t_acquisition_frameworks AS af
WHERE NOT EXISTS (
        SELECT TRUE
        FROM  gn_meta.t_acquisition_frameworks AS afp
        WHERE afp.acquisition_framework_parent_id = af.id_acquisition_framework
    )
    AND af.is_parent = TRUE
    AND NOT EXISTS (
        SELECT TRUE
        FROM gn_meta.t_datasets AS da
        WHERE da.id_acquisition_framework = af.id_acquisition_framework
    ) ;


\echo '-------------------------------------------------------------------------------'
\echo 'USERS & ORGANISMS'

\echo 'Deletion in cor_roles'
DELETE FROM utilisateurs.cor_roles AS cr
USING utilisateurs.t_roles AS r
WHERE cr.id_role_utilisateur = r.id_role
    AND r.champs_addi ->> 'source' = 'flavia'
    AND r.champs_addi ->> 'module' = 'gn2pg' ;

\echo 'Deletion in t_roles'
DELETE FROM utilisateurs.t_roles AS r
WHERE champs_addi ->> 'source' = 'flavia'
    AND champs_addi ->> 'module' = 'gn2pg'
    AND NOT EXISTS (
        SELECT TRUE
        FROM utilisateurs.cor_roles AS cr
        WHERE cr.id_role_utilisateur = r.id_role
    )
    AND NOT EXISTS (
        SELECT TRUE
        FROM utilisateurs.cor_role_liste AS crl
        WHERE crl.id_role = r.id_role
    )
    AND NOT EXISTS (
        SELECT TRUE
        FROM gn_commons.t_validations AS v
        WHERE v.id_validator = r.id_role
    )
    AND NOT EXISTS (
        SELECT TRUE
        FROM gn_commons.t_places AS p
        WHERE p.id_role = r.id_role
    )
    AND NOT EXISTS (
        SELECT TRUE
        FROM gn_meta.t_acquisition_frameworks AS af
        WHERE af.id_digitizer = r.id_role
    )
    AND NOT EXISTS (
        SELECT TRUE
        FROM gn_meta.cor_acquisition_framework_actor AS afa
        WHERE afa.id_role = r.id_role
    )
    AND NOT EXISTS (
        SELECT TRUE
        FROM gn_meta.t_datasets AS da
        WHERE da.id_digitizer = r.id_role
    )
    AND NOT EXISTS (
        SELECT TRUE
        FROM gn_meta.cor_dataset_actor AS da
        WHERE da.id_role = r.id_role
    )
    AND NOT EXISTS (
        SELECT TRUE
        FROM gn_permissions.cor_role_action_filter_module_object AS rafmo
        WHERE rafmo.id_role = r.id_role
    )
    AND NOT EXISTS (
        SELECT TRUE
        FROM gn_synthese.synthese AS sy
        WHERE sy.id_digitiser = r.id_role
    )
    AND NOT EXISTS (
        SELECT TRUE
        FROM gn_synthese.cor_observer_synthese AS cos
        WHERE cos.id_role = r.id_role
    )
    AND NOT EXISTS (
        SELECT TRUE
        FROM gn_monitoring.t_base_sites AS bs
        WHERE bs.id_inventor = r.id_role
    )
    AND NOT EXISTS (
        SELECT TRUE
        FROM gn_monitoring.t_base_sites AS bs
        WHERE bs.id_digitiser = r.id_role
    )
    AND NOT EXISTS (
        SELECT TRUE
        FROM gn_monitoring.t_base_visits AS bv
        WHERE bv.id_digitiser = r.id_role
    )
    AND NOT EXISTS (
        SELECT TRUE
        FROM gn_monitoring.cor_visit_observer AS cvo
        WHERE cvo.id_role = r.id_role
    )
;

\echo 'Deletion in bib_organismes'
DELETE FROM utilisateurs.bib_organismes AS o
WHERE NOT EXISTS (
        SELECT TRUE
        FROM utilisateurs.t_roles AS r
        WHERE r.id_organisme = o.id_organisme
    )
    AND NOT EXISTS (
        SELECT TRUE
        FROM gn_meta.cor_dataset_actor AS cda
        WHERE cda.id_organism = o.id_organisme
    )
    AND NOT EXISTS (
        SELECT TRUE
        FROM gn_meta.cor_acquisition_framework_actor AS cafa
        WHERE cafa.id_organism = o.id_organisme
    )
    AND NOT EXISTS (
        SELECT TRUE
        FROM utilisateurs.bib_organismes AS op
        WHERE op.id_parent = o.id_organisme
    )
    AND NOT EXISTS (
        SELECT TRUE
        FROM gn_commons.t_parameters AS p
        WHERE p.id_organism = o.id_organisme
    )
    AND NOT EXISTS (
        SELECT TRUE
        FROM ref_nomenclatures.defaults_nomenclatures_value AS dnv
        WHERE dnv.id_organism = o.id_organisme
    )
    AND NOT EXISTS (
        SELECT TRUE
        FROM gn_synthese.defaults_nomenclatures_value AS dnv
        WHERE dnv.id_organism = o.id_organisme
    )
    AND NOT EXISTS (
        SELECT TRUE
        FROM utilisateurs.temp_users AS tu
        WHERE tu.id_organisme = o.id_organisme
    ) ;


\echo '-------------------------------------------------------------------------------'
\echo 'GN2PG'

\echo 'Clean data_json'
TRUNCATE gn2pg_flavia.data_json ;

\echo 'Clean download_log'
TRUNCATE gn2pg_flavia.download_log ;

\echo 'Clean error_log'
TRUNCATE gn2pg_flavia.error_log ;

\echo 'Clean increment_log'
TRUNCATE gn2pg_flavia.increment_log ;

\echo 'Remove tmp_fix_obs_to_delete'
DROP TABLE IF EXISTS gn2pg_flavia.tmp_fix_obs_to_delete ;


\echo '----------------------------------------------------------------------------'
\echo 'COMMIT if all is ok:'
COMMIT;
