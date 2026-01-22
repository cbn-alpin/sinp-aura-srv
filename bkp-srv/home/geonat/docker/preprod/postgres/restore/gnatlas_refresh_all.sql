-- Refresh all Atlas Materialized views

-- Enable timing
\timing

BEGIN ;

-- TAXO

\echo '----------------------------------------------------------------'
\echo 'Refreshing atlas.vm_taxref:'
REFRESH MATERIALIZED VIEW CONCURRENTLY atlas.vm_taxref;

-- GEO

\echo '----------------------------------------------------------------'
\echo 'Refreshing atlas.t_layer_territoire:'
REFRESH MATERIALIZED VIEW atlas.t_layer_territoire;

\echo '----------------------------------------------------------------'
\echo 'Refreshing atlas.vm_subdivided_area:'
REFRESH MATERIALIZED VIEW atlas.vm_subdivided_area;

\echo '----------------------------------------------------------------'
\echo 'Refreshing atlas.l_communes:'
REFRESH MATERIALIZED VIEW atlas.l_communes;

\echo '----------------------------------------------------------------'
\echo 'Refreshing atlas.vm_communes:'
REFRESH MATERIALIZED VIEW atlas.vm_communes;

-- DATA

\echo '----------------------------------------------------------------'
\echo 'Refreshing synthese.vm_cor_synthese_area:'
REFRESH MATERIALIZED VIEW CONCURRENTLY synthese.vm_cor_synthese_area;

\echo '----------------------------------------------------------------'
\echo 'Refreshing atlas.vm_observations:'
REFRESH MATERIALIZED VIEW atlas.vm_observations;

\echo '----------------------------------------------------------------'
\echo 'Refreshing atlas.vm_observations_mailles:'
REFRESH MATERIALIZED VIEW atlas.vm_observations_mailles;

\echo '----------------------------------------------------------------'
\echo 'Refreshing atlas.vm_cor_taxon_organism:'
REFRESH MATERIALIZED VIEW atlas.vm_cor_taxon_organism;

\echo '----------------------------------------------------------------'
\echo 'Refreshing atlas.vm_mois:'
REFRESH MATERIALIZED VIEW atlas.vm_mois;

\echo '----------------------------------------------------------------'
\echo 'Refreshing atlas.vm_altitudes:'
REFRESH MATERIALIZED VIEW atlas.vm_altitudes;

\echo '----------------------------------------------------------------'
\echo 'Refreshing atlas.vm_taxons:'
REFRESH MATERIALIZED VIEW atlas.vm_taxons;

\echo '----------------------------------------------------------------'
\echo 'Refreshing atlas.vm_taxon_attribute:'
REFRESH MATERIALIZED VIEW atlas.vm_taxon_attribute;

\echo '----------------------------------------------------------------'
\echo 'Refreshing atlas.vm_search_taxon:'
REFRESH MATERIALIZED VIEW atlas.vm_search_taxon;

\echo '----------------------------------------------------------------'
\echo 'Refreshing atlas.vm_medias:'
REFRESH MATERIALIZED VIEW atlas.vm_medias;

\echo '----------------------------------------------------------------'
\echo 'Refreshing atlas.vm_taxons_plus_observes:'
REFRESH MATERIALIZED VIEW atlas.vm_taxons_plus_observes;

\echo '----------------------------------------------------------------'
\echo 'COMMIT if all is ok:'
COMMIT;   
