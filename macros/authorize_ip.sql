{% macro authorize_ip() %}
{% set sql %}
    create network policy mypolicy1 allowed_ip_list=('139.135.32.2');
    alter user muhib set network_policy=mypolicy1;
{% endset %}

{% do run_query(sql) %}
-- {% do log("Privileges granted", info=True) %}
{% endmacro %}
