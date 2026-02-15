WITH RECURSIVE
principal_group AS (
    SELECT
        id,
        UNNEST(groups) AS grp
    FROM
        principal
)
,
-- Legt alle indirekten Gruppenberechtigungen um auf direkte Verknüpfungen.
-- Bsp: Aus user - subgruppe - übergruppe wird die direkte Verknüpfung 
-- user - übergruppe abgeleitet.
principal_direct_group AS ( 
    SELECT
        id,
        grp
    FROM 
        principal_group
    UNION ALL
    SELECT
        pag.id,
        pgt.grp
    FROM 
        principal_group pag
    JOIN 
        principal_group pgt
        ON 
            pgt.id = pag.grp
)
,
-- Alle user mit allen selbst, direkten und indirekten
-- Referenzen auf einen Principal.
user_group_and_self_ref AS (
    SELECT 
        id,
        id AS ref_id
    FROM
        principal
    WHERE
        is_user
        
    UNION ALL
    
    SELECT 
        pdg.id,
        pdg.grp AS ref_id
    FROM 
        principal_direct_group pdg
    JOIN 
        principal p ON pdg.id = p.id
    WHERE
        p.is_user
)
,
principal_role AS (
    SELECT
        id,
        UNNEST(roles) AS role
    FROM
        principal
)

SELECT DISTINCT 
    ug.id AS user_id,
    r.role AS role_id
FROM 
    user_group_and_self_ref ug
JOIN 
    principal_role r ON ug.ref_id = r.id
