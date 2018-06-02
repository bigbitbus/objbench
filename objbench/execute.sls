{% from "objbench/map.jinja" import install_objbench as install_map with context %}
{% from "objbench/map.jinja" import execute_objbench as execute_map with context %}

create_setup:
  file.directory:
    - names: 
      - {{ execute_map.get('output_dir') }}
      - {{ execute_map.get('data_dir') }}
    - makedirs: True

  cmd.run:
    - name: 'python datamaker.py {{ execute_map.get('data_dir') }}'
    - cwd: {{ install_map.get('install_dir') }}
    - requires: file.directory

copy_credentials:
  file.recurse:
    - name: {{ execute_map.get('credentials_dir') }}
    - source: salt://credentials
    - include_empty: True
    - makedirs: True

run_objbench_gcp:
  cmd.run:
    - names: 
      - source {{ execute_map.get('credentials_dir') }}/gcp.sh
      - python gcpexercizer.py {{ execute_map.get('data_dir') }}
    - cwd: {{ install_map.get('install_dir') }}







