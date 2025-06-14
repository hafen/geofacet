.valid_grids <- c("us_state_grid1", "us_state_grid2", "eu_grid1", "aus_grid1",
  "sa_prov_grid1", "gb_london_boroughs_grid", "nhs_scot_grid", "india_grid1",
  "india_grid2", "argentina_grid1", "br_states_grid1", "sea_grid1",
  "mys_grid1", "fr_regions_grid1", "de_states_grid1", "us_or_counties_grid1",
  "us_wa_counties_grid1", "us_in_counties_grid1",
  "us_in_central_counties_grid1", "se_counties_grid1",
  "sf_bay_area_counties_grid1", "ua_region_grid1", "mx_state_grid1",
  "mx_state_grid2", "scotland_local_authority_grid1",
  "us_state_without_DC_grid1", "italy_grid1", "italy_grid2",
  "be_province_grid1", "us_state_grid3", "jp_prefs_grid1", "ng_state_grid1",
  "bd_upazila_grid1", "spain_prov_grid1", "ch_cantons_grid1",
  "ch_cantons_grid2", "china_prov_grid1", "world_86countries_grid",
  "se_counties_grid2", "uk_regions1", "us_state_contiguous_grid1",
  "sk_province_grid1", "ch_aargau_districts_grid1", "jo_gov_grid1",
  "es_autonomous_communities_grid1", "spain_prov_grid2",
  "world_countries_grid1", "br_states_grid2", "china_city_grid1",
  "kr_seoul_district_grid1", "nz_regions_grid1", "sl_regions_grid1",
  "us_census_div_grid1", "ar_tucuman_province_grid1", "us_nh_counties_grid1",
  "china_prov_grid2", "pl_voivodeships_grid1", "us_ia_counties_grid1",
  "us_id_counties_grid1", "ar_cordoba_dep_grid1", "us_fl_counties_grid1",
  "ar_buenosaires_communes_grid1", "nz_regions_grid2", "oecd_grid1",
  "ec_prov_grid1", "nl_prov_grid1", "ca_prov_grid1", "us_nc_counties_grid1",
  "mx_ciudad_prov_grid1", "bg_prov_grid1", "us_hhs_regions_grid1",
  "tw_counties_grid1", "tw_counties_grid2", "af_prov_grid1",
  "us_mi_counties_grid1", "pe_prov_grid1", "sa_prov_grid2", "mx_state_grid3",
  "cn_bj_districts_grid1", "us_va_counties_grid1", "us_mo_counties_grid1",
  "cl_santiago_prov_grid1", "us_tx_capcog_counties_grid1",
  "sg_planning_area_grid1", "in_state_ut_grid1", "cn_fujian_prov_grid1",
  "ca_quebec_electoral_districts_grid1", "nl_prov_grid2",
  "cn_bj_districts_grid2", "ar_santiago_del_estero_prov_grid1",
  "ar_formosa_prov_grid1", "ar_chaco_prov_grid1", "ar_catamarca_prov_grid1",
  "ar_jujuy_prov_grid1", "ar_neuquen_prov_grid1", "ar_san_luis_prov_grid1",
  "ar_san_juan_prov_grid1", "ar_santa_fe_prov_grid1", "ar_la_rioja_prov_grid1",
  "ar_mendoza_prov_grid1", "ar_salta_prov_grid1", "ar_rio_negro_prov_grid1",
  "uy_departamentos_grid1", "ar_buenos_aires_prov_electoral_dist_grid1",
  "europe_countries_grid1", "argentina_grid2", "us_state_without_DC_grid2",
  "jp_prefs_grid2", "na_regions_grid1", "mm_state_grid1",
  "us_state_with_DC_PR_grid1", "fr_departements_grid1", "ar_salta_prov_grid2",
  "ie_counties_grid1", "sg_regions_grid1", "us_ny_counties_grid1",
  "ru_federal_subjects_grid1", "us_ca_counties_grid1", "lk_districts_grid1",
  "us_state_without_DC_grid3", "co_cali_subdivisions_grid1",
  "us_in_northern_counties_grid1", "italy_grid3", "us_state_with_DC_PR_grid2",
  "us_state_grid7", "sg_planning_area_grid2", "ch_cantons_fl_grid1",
  "europe_countries_grid2", "us_states_territories_grid1",
  "us_tn_counties_grid1", "us_il_chicago_community_areas_grid1",
  "us_state_with_DC_PR_grid3", "in_state_ut_grid2", "at_states_grid1",
  "us_pa_counties_grid1", "us_oh_counties_grid1", "fr_departements_grid2",
  "us_wi_counties_grid1", "africa_countries_grid1", "no_counties_grid1",
  "tr_provinces_grid1", "us_eastern_states_grid1", "br_states_grid3",
  "us_states_territories_grid2", "us_state_grid8", "us_state_grid9",
  "fr_departements_grid3", "in_state_ut_grid3", "th_provinces_grid1",
  "th_bangkok_districts_grid1", "ca_us_prov_state_grid1",
  "sy_governorates_grid1", "ro_counties_grid1", "us_va_health_districts_grid1",
  "us_state_without_DC_canada_prov_grid1", "ir_provinces_grid1",
  "co_departments_grid1", "ir_tehran_districts_grid1", "ro_counties_grid2",
  "gb_sct_council_areas_grid1", "mw_districts_grid1", "dk_cph_grid1",
  "us_nv_counties_grid1", "ie_counties_grid2", "bo_departments_grid1",
  "ie_counties_grid3", "co_departments_grid2", "americas_countries_grid1",
  "us_census_div_grid2", "ar_buenosaires_conurbano_grid1",
  "us_md_counties_grid1", "us_ia_counties_grid2", "us_western_states_grid1",
  "us_ga_counties_grid1", "ro_counties_grid3",
  "es_autonomous_communities_grid2", "qa_municipalities_grid1",
  "kz_region_grid1", "middle_east_grid1", "cz_prague_districts_grid1",
  "es_catalonia_comarques_grid1", "no_counties_grid2",
  "fi_helsinki_neighborhoods_grid1", "us_state_without_DC_AK_HI_grid1",
  "ru_federal_subjects_grid2", "us_ut_counties_grid1", "in_state_ut_grid4",
  "ec_prov_grid2", "es_prov_grid1", "americas_countries_grid2",
  "us_nm_counties_grid1", "us_me_counties_grid1", "cu_prov_grid1",
  "ge_regions_grid1", "co_departments_grid3", "gb_london_boroughs_grid2",
  "gb_sct_aberdeenshire_IZ_grid1", "gb_sct_aberdeenshire_wards_grid1",
  "at_vienna_districts_grid1", "gh_regions_grid1", "uy_departamentos_grid2",
  "ch_vaud_districts_grid1", "us_ca_counties_FIPS_grid1",
  "kr_seoul_district_grid2", "kr_districts_grid1", "oecd_grid2",
  "bo_departments_grid2", "ca_us_prov_state_grid2", "us_il_counties_grid1",
  "tn_governorates_grid1", "gb_sct_glasgow_wards_grid1", "kr_provinces_grid1",
  "kr_counties_districts_cities_grid1", "us_ok_counties_grid1",
  "us_dc_neighborhoods_grid1", "us_mn_counties_grid1")
