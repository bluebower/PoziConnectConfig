select distinct
    propnum as propnum,
    blg_unit_type as blg_unit_type,
    blg_unit_prefix_1 as blg_unit_prefix_1,
    blg_unit_id_1 as blg_unit_id_1,
    blg_unit_suffix_1 as blg_unit_suffix_1,
    blg_unit_prefix_2 as blg_unit_prefix_2,
    blg_unit_id_2 as blg_unit_id_2,
    blg_unit_suffix_2 as blg_unit_suffix_2,
    floor_type as floor_type,
    floor_prefix_1 as floor_prefix_1,
    floor_no_1 as floor_no_1,
    floor_suffix_1 as floor_suffix_1,
    floor_prefix_2 as floor_prefix_2,
    floor_no_2 as floor_no_2,
    floor_suffix_2 as floor_suffix_2,
    building_name as building_name,
    complex_name as complex_name,
    location_descriptor as location_descriptor,
    house_prefix_1 as house_prefix_1,
    house_number_1 as house_number_1,
    house_suffix_1 as house_suffix_1,
    house_prefix_2 as house_prefix_2,
    house_number_2 as house_number_2,
    house_suffix_2 as house_suffix_2,
    '' as display_prefix_1,
    '' as display_no_1,
    '' as display_suffix_1,
    '' as display_prefix_2,
    '' as display_no_2,
    '' as display_suffix_2,
    road_name as road_name,
    road_type as road_type,
    road_suffix as road_suffix,
    locality_name as locality_name,
    road_name_combined as roadnt_pr,
    road_locality as stjoin_pr,
    ezi_address as address_pr,
    ezi_address || ' ' || propnum as address_propnum_pr
from
    PC_Council_Property_Address