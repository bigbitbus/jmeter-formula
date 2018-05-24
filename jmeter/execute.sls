{% from "jmeter/map.jinja" import exec_jmeter as exec_jmeter_map with context %}
{% set cli_args = exec_jmeter_map.get ('cmd_cli_args','') %}
{% set jmx_template_file = exec_jmeter_map.get ('jmx_template_file','') %}
{% set out_dir = exec_jmeter_map.get('out_dir','/tmp/outputdata/jmeter') %}
{% set num_loops = exec_jmeter_map.get('num_loops',1) %}
{% set num_threads = exec_jmeter_map.get('num_threads',1) %}
{% set db_host = salt['pillar.get']('dbconnection:db_host','172.17.0.2') %}
{% set db_port = salt['pillar.get']('dbconnection:db_port','3306') %}
{% set db_name = salt['pillar.get']('dbconnection:db_name','employees') %}
{% set db_username = salt['pillar.get']('dbconnection:db_username','root') %}
{% set db_password = salt['pillar.get']('dbconnection:db_password','password') %}
{% set jmx_config = salt['pillar.get']('jmx_config', {}) %}
{% set id = grains.get('id','no_minion_id') %}
{% from "jmeter/map.jinja" import install_jmeter as install_jmeter_map with context %}
{% set install_dir = install_jmeter_map.get('install_dir', '/opt') %}
clean_out_dir:
  cmd.run:
    - names: 
      - mkdir -p {{ out_dir }}
      - touch {{ outdir }}/dummyfile
      - rm -rf {{ out_dir }}/*

prepare_jmx_file:
  file.managed:
    - name: {{ out_dir }}/test.jmx
    - source: salt://jmeter/files/{{ jmx_config.jmx_template_file }}
    - template: jinja
    - context:
        jmeterhost_id: {{ id }}
        install_dir: {{ install_dir }}
        out_dir: {{ out_dir }}
        db_host: {{ db_host }}
        db_port: {{ db_port }}
        db_name: {{ db_name }}
        db_password: {{ db_password }}
        db_username: {{ db_username }}
        jc: {{ jmx_config }}
    - makedirs: True
    - require: 
      - clean_out_dir

{% if (db_host != "NONE") %}
run_jmeter_test:
  cmd.run:
    - names:
      - date
      - {{ install_dir }}jmeter/bin/jmeter {{ cli_args }} -t {{ out_dir }}/test.jmx  -l {{ out_dir }}/results.jtl
    - cwd: {{ out_dir }}
    - require: 
      - prepare_jmx_file
{% endif %}
    