{% macro set_duckdb_file_search_path() %}
    {% set path = project_root ~ '/data' %}
    {% do run_query("SET file_search_path='" ~ path ~ "';") %}
{% endmacro %}
