{% from "jmeter/map.jinja" import install_jmeter as jmeter_map with context %}
{% set prereq_packages = jmeter_map.get('prereq_packages',[]) %}
{% set jmeter_source_url = jmeter_map.get('jmeter_source_url','url_needed')  %}
{% set install_dir = jmeter_map.get('install_dir', '/opt') %}
{% set mysql_jdbc_plugin_url = jmeter_map.get('mysql_jdbc_plugin_url') %}

install_prereqs:
  pkg.latest:
    - pkgs: {{ prereqs }}

install_from_url:
  cmd.run:
    - names: 
      - rm -rf jmeter*
      - wget {{ jmeter_source_url }} -O jmeter.tar.gz
      - mkdir -p {{ install_dir }}
      - tar -xvzf jmeter.tar.gz -o {{ install_dir }}
      - mv {{ install_dir }}/apache-jmeter*/ {{ install_dir }}/jmeter/
      - wget {{ mysql_jdbc_plugin_url }} -O jdbc.tar.gz
      - tar -xvzf jdbc.tar.gz
      - mv mysql-connector*/*.jar {{ install_dir}}/jmeter/lib
      - rm -rf mysql-connector*/
      - rm -rf *.tar.gz
    - cwd: /tmp

  
    
    

