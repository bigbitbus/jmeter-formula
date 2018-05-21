{% from "jmeter/map.jinja" import install_jmeter as jmeter_map with context %}
{% set prereq_packages = jmeter_map.get('prereq_packages',[]) %}
{% set jmeter_source_url = jmeter_map.get('jmeter_source_url','url_needed')  %}
{% set install_dir = jmeter_map.get('install_dir', '/opt') %}
{% set mysql_jdbc_plugin_url = jmeter_map.get('mysql_jdbc_plugin_url') %}

install_prereqs:
  pkg.latest:
    - pkgs: {{ prereq_packages }}

install_from_url:
  cmd.run:
    - names: 
      - rm -rf jmeter*
      - wget {{ jmeter_source_url }} -O jmeter.tar.gz
      - mkdir -p {{ install_dir }}
      - tar -xvzf jmeter.tar.gz -C {{ install_dir }}
      - mv {{ install_dir }}apache-jmeter*/ {{ install_dir }}jmeter/
      - wget {{ mysql_jdbc_plugin_url }} -O jdbc.tar.gz
      - tar -xvzf jdbc.tar.gz
      - mv mysql-connector*/*.jar {{ install_dir}}jmeter/lib
      - rm -rf mysql-connector*/
      - rm -rf *.tar.gz
    - cwd: /tmp

add_summarizer:
  file.append:
    - name: {{ install_dir}}jmeter/bin/jmeter.properties
    - text: |
        #----------------------------------------------------------
        # Summariser - Generate Summary Results - configuration (mainly applies to non-GUI mode)
        #----------------------------------------------------------
        # Define the following property to automatically start a summariser with that name
        # (applies to non-GUI mode only)
        summariser.name=summary
        #
        # interval between summaries (in seconds) default 3 minutes
        summariser.interval=10
        #
        # Write messages to log file
        summariser.log=true
        #
        # Write messages to System.out
        summariser.out=true
    - requires:
        - install_from_url

    

  
    
    

