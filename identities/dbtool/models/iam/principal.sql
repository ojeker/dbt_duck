WITH

user_json AS (
    SELECT 
        id,
        roles_ AS roles,
        groups_ AS groups
    FROM 
        read_json_auto('data/users.json')
)
,
group_json AS (
    SELECT 
        id,
        roles_ AS roles,
        groups_ AS groups
    FROM 
        read_json_auto('data/groups.json')
)
,
principal AS (
    SELECT *, TRUE AS is_user FROM user_json
    UNION ALL 
    SELECT *, FALSE AS is_user FROM group_json
)

SELECT * FROM principal