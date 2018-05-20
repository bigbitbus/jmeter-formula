{% from "jmeter/map.jinja" import exec_jmeter as exec_jmeter_map with context %}
{% set cli_args = exec_jmeter_map.get ('cmd_cli_args','') %}
{% set jmx_template_file = exec_jmeter_map.get ('jmx_template_file',[]) %}
{% set out_dir = exec_fio_map.get('out_dir','/tmp/outputdata') %}

prepare_jmx_file:
  file.managed:
    - name: {{ out_dir }}/test.jmx
    - source: salt://jmeter/files/{{ jmx_template_file }}
    - template: jinja

run_jmeter_test:
  cmd.run:
    - names:
      -  {{ install_dir }}/jmeter/bin/jmeter {{ cli_args }} -t {{ out_dir }}/test.jmx
    - cwd:
      - {{ out_dir }}

    