select
    *,
    ltrim ( num_road_address ||
        rtrim ( ' ' || locality_name ) ) as ezi_address
from (

select
    *,
    ltrim ( road_name_combined ||
        rtrim ( ' ' || locality_name ) ) as road_locality,
    ltrim ( num_address ||
        rtrim ( ' ' || road_name_combined ) ) as num_road_address
from (

select
    *,
    blg_unit_prefix_1 || blg_unit_id_1 || blg_unit_suffix_1 ||
        case when ( blg_unit_id_2 <> '' or blg_unit_suffix_2 <> '' ) then '-' else '' end ||
        blg_unit_prefix_2 || blg_unit_id_2 || blg_unit_suffix_2 ||
        case when ( blg_unit_id_1 <> '' or blg_unit_suffix_1 <> '' ) then '/' else '' end ||
        case when hsa_flag = 'Y' then hsa_unit_id || '/' else '' end ||
        house_prefix_1 || house_number_1 || house_suffix_1 ||
        case when ( house_number_2 <> '' or house_suffix_2 <> '' ) then '-' else '' end ||
        house_prefix_2 || house_number_2 || house_suffix_2 as num_address,
    ltrim ( road_name ||
        rtrim ( ' ' || road_type ) ||
        rtrim ( ' ' || road_suffix ) ) as road_name_combined
from (

select distinct
    cast ( lpaprop.tpklpaprop as varchar ) as propnum,
    case lpaprop.status
        when 'C' then 'A'
        when 'A' then 'P'
    end as status,
    '' as base_propnum,
    '' as is_primary,
    '' as distance_related_flag,
    case lpaadfm.tpklpaadfm
        when 1802 then 'Y'
        else ''
    end as hsa_flag,
    case
        when ifnull ( lpaadfm.tpklpaadfm , '' ) <> 1802 then ''
        when ifnull ( lpaaddr.unitprefix , '' ) = 'G' then 'G' || substr ( '00' || cast ( cast ( lpaaddr.strunitnum as integer ) as varchar ) , -2 )
        when ifnull ( lpaaddr.unitprefix , '' ) = 'B' then 'B' || cast ( cast ( lpaaddr.strunitnum as integer ) as varchar )
        else cast ( cast ( lpaaddr.strunitnum as integer ) as varchar )
    end as hsa_unit_id,
    case
        when lpaadfm.tpklpaadfm = 1802 then ''
        when upper ( lpaaddr.unitprefix ) in ('','ANT','APT','ATM','BBOX','BBQ','BERT','BLDG','BNGW','BTSD','CAGE','CARP','CARS','CARW','CHAL','CLUB','COOL','CTGE','CTYD','DUPL','FCTY','FLAT','GATE','GRGE','HALL','HELI','HNGR','HOST','HSE','JETY','KSK','LBBY','LOFT','LOT','LSE','MBTH','MSNT','OFFC','PSWY','PTHS','REST','RESV','ROOM','RPTN','SAPT','SE','SHCS','SHED','SHOP','SHRM','SIGN','SITE','STLL','STOR','STR','STU','SUBS','TNCY','TNHS','TWR','UNIT','VLLA','VLT','WARD','WC','WHSE','WKSH') then upper ( lpaaddr.unitprefix )
        when upper ( lpaaddr.unitprefix ) = 'CAR PARK' then 'CARP'
        when upper ( lpaaddr.unitprefix ) = 'COTTAGE' then 'CTGE'
        when upper ( lpaaddr.unitprefix ) = 'FACTORY' then 'FCTY'
        when upper ( lpaaddr.unitprefix ) = 'HOSTEL' then 'HOST'
        when upper ( lpaaddr.unitprefix ) = 'KIOSK' then 'KSK'
        when upper ( lpaaddr.unitprefix ) = 'OFFICE' then 'OFFC'
        when upper ( lpaaddr.unitprefix ) = 'STORE' then 'STOR'
        when upper ( lpaaddr.unitprefix ) = 'SUITE' then 'SE'
        when upper ( lpaaddr.unitprefix ) = 'L' then 'LOT'
        when upper ( lpaaddr.unitprefix ) like '%TOWER%' then 'TWR'
        else ''
    end as blg_unit_type,
    case
        when lpaadfm.tpklpaadfm = 1802 then ''
        when length ( lpaaddr.unitprefix ) = 1 then lpaaddr.unitprefix
        else ''
    end as blg_unit_prefix_1,
    case
        when lpaadfm.tpklpaadfm = 1802 then ''
        when lpaaddr.strunitnum = 0 or lpaaddr.strunitnum is null then ''
        else cast ( cast ( lpaaddr.strunitnum as integer ) as varchar )
    end as blg_unit_id_1,
    case
        when lpaadfm.tpklpaadfm = 1802 then ''
        else ifnull ( lpaaddr.strunitsfx , '' )
    end as blg_unit_suffix_1,
    '' as blg_unit_prefix_2,
    case
        when lpaadfm.tpklpaadfm = 1802 then ''
        when lpaaddr.endunitnum = 0 or lpaaddr.endunitnum is null then ''
        else cast ( cast ( lpaaddr.endunitnum as integer ) as varchar )
    end as blg_unit_id_2,
    case
        when lpaadfm.tpklpaadfm = 1802 then ''
        when trim ( lpaaddr.endunitsfx ) = '0' or lpaaddr.endunitsfx is null then ''
        else trim ( lpaaddr.endunitsfx )
    end as blg_unit_suffix_2,
    case
        when lpaadfm.tpklpaadfm = 1802 then ''
        when length ( lpaaddr.lvlprefix ) <= 2 then upper ( lpaaddr.lvlprefix )
        when upper ( lpaaddr.lvlprefix ) = 'BASEMENT' then 'B'
        when upper ( lpaaddr.lvlprefix ) = 'LEVEL' then 'L'
        when upper ( lpaaddr.lvlprefix ) = 'FLOOR' then 'FL'
        when upper ( lpaaddr.lvlprefix ) in ( 'GRD FLOOR' , 'GROUND' ) then 'G'
        else ''
    end as floor_type,
    '' as floor_prefix_1,
    case
        when lpaadfm.tpklpaadfm = 1802 then ''
        when lpaaddr.strlvlnum = 0 or lpaaddr.strlvlnum is null then ''
        else cast ( cast ( lpaaddr.strlvlnum as integer ) as varchar )
    end as floor_no_1,
    '' as floor_suffix_1,
    '' as floor_prefix_2,
    case
        when lpaadfm.tpklpaadfm = 1802 then ''
        when lpaaddr.endlvlnum = 0 or lpaaddr.endlvlnum is null then ''
        else cast ( cast ( lpaaddr.endlvlnum as integer ) as varchar )
    end as floor_no_2,
    '' as floor_suffix_2,
    ifnull ( upper ( lpapnam.propname ) , '' ) as building_name,
    '' as complex_name,
    case
        when upper ( lpaaddr.prefix ) in ( 'ABOVE' ) then 'ABOVE'
        when upper ( lpaaddr.prefix ) in ( 'BELOW' , 'UNDER' ) then 'BELOW'
        when upper ( lpaaddr.prefix ) in ( 'FRONT' ) then 'FRONT'
        when upper ( lpaaddr.prefix ) in ( 'OFF' ) then 'OFF'
        when upper ( lpaaddr.prefix ) in ( 'OPPOSITE' ) then 'OPPOSITE'
        when upper ( lpaaddr.prefix ) in ( 'REAR' , 'REAR OF' ) then 'REAR'
        else ''
    end as location_descriptor,
    '' as house_prefix_1,
    case
        when lpaaddr.strhousnum = 0 or lpaaddr.strhousnum is null then ''
        else cast ( cast ( lpaaddr.strhousnum as integer ) as varchar )
    end as house_number_1,
    ifnull ( lpaaddr.strhoussfx , '' ) as house_suffix_1,
    '' as house_prefix_2,
    case
        when lpaaddr.endhousnum = 0 or lpaaddr.endhousnum is null then ''
        else cast ( cast ( lpaaddr.endhousnum as integer ) as varchar )
    end as house_number_2,
    ifnull ( lpaaddr.endhoussfx , '' ) as house_suffix_2,
    upper ( replace ( replace ( cnacomp.descr , ' - ' , '-' ) , '''' , '' ) ) as road_name,
    case
        when
            cnaqual.descr like '% NORTH' or
            cnaqual.descr like '% SOUTH' or
            cnaqual.descr like '% EAST' or
            cnaqual.descr like '% WEST' then upper ( trim ( substr ( cnaqual.descr , 1 , length ( cnaqual.descr ) - 5 ) ) )
        else upper ( ifnull ( cnaqual.descr , '' ) )
    end as road_type,
    case
        when upper ( cnaqual.descr ) like '% NORTH' then 'N'
        when upper ( cnaqual.descr ) like '% SOUTH' then 'S'
        when upper ( cnaqual.descr ) like '% EAST' then 'E'
        when upper ( cnaqual.descr ) like '% WEST' then 'W'
        else ''
    end as road_suffix,
    upper ( lpasubr.suburbname ) as locality_name,
    '' as postcode,
    '' as access_type,
    '' as easting,
    '' as northing,
    '' as datum_proj,
    '' as outside_property,
    '342' as lga_code,
    '' as crefno,
    '' as summary
from
    pathway_lpaprop as lpaprop left join
    pathway_lpaadpr as lpaadpr on lpaprop.tpklpaprop = lpaadpr.tfklpaprop left join
    pathway_lpaaddr as lpaaddr on lpaadpr.tfklpaaddr = lpaaddr.tpklpaaddr left join
    pathway_lpastrt as lpastrt on lpaaddr.tfklpastrt = lpastrt.tpklpastrt left join
    pathway_cnacomp as cnacomp on lpastrt.tfkcnacomp = cnacomp.tpkcnacomp left join
    pathway_cnaqual as cnaqual on cnacomp.tfkcnaqual = cnaqual.tpkcnaqual left join
    pathway_lpaprtp as lpaprtp on lpaprop.tfklpaprtp = lpaprtp.tpklpaprtp left join
    pathway_lpasubr as lpasubr on lpaaddr.tfklpasubr = lpasubr.tpklpasubr left join
    pathway_lpapnam as lpapnam on lpaprop.tpklpaprop = lpapnam.tfklpaprop left join
    pathway_lpaadfm as lpaadfm on lpaadpr.tfklpaadfm = lpaadfm.tpklpaadfm
where
    lpaprop.status in ( 'A', 'C' ) and
    lpaaddr.addrtype = 'P' and
    lpaprop.fmtowner is not null and
    lpaprop.tfklpacncl = 12
)
)
)
