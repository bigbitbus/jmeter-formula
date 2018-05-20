{% from "jmeter/map.jinja" import exec_jmeter as exec_jmeter_map with context %}
{% set cli_args = exec_jmeter_map.get ('cmd_cli_args','') %}
{% set jmx_template_file = exec_jmeter_map.get ('jmx_template_file',[]) %}
{% set out_dir = exec_jmeter_map.get('out_dir','/tmp/outputdata') %}
{% set num_loops = exec_jmeter_map.get('num_loops',1) %}
{% set num_threads = exec_jmeter_map.get('num_threads',1) %}
{% set db_host = exec_jmeter_map.get('db_host') %}
{% set db_name = exec_jmeter_map.get('db_name','employees') %}
{% set db_password = exec_jmeter_map.get('db_password') %}
{% set db_username = exec_jmeter_map.get('db_username') %}

{% from "jmeter/map.jinja" import install_jmeter as install_jmeter_map with context %}
{% set install_dir = install_jmeter_map.get('install_dir', '/opt') %}

prepare_jmx_file:
  file.managed:
    - name: {{ out_dir }}/test.jmx
    - source: salt://jmeter/files/{{ jmx_template_file }}
    - template: jinja
    - context:
        install_dir: install_dir
        num_loops: num_loops
        num_threads: num_threads
        db_host: db_host
        db_name: db_name
        db_password: db_password
        db_username: db_username
    - makedirs: True

run_jmeter_test:
  cmd.run:
    - names:
      - date
      - {{ install_dir }}jmeter/bin/jmeter {{ cli_args }} -t {{ out_dir }}/test.jmx
      
    - cwd: {{ out_dir }}

    