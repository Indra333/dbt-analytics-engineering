{% macro cents_to_dollars(column_name) %}
    round(cast({{ column_name }} as double) / 100.0, 2)
{% endmacro %}
