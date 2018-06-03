{% from "objbench/map.jinja" import install_objbench as install_map with context %}
{% from "objbench/map.jinja" import execute_objbench as execute_map with context %}
{% set gcpjsonfile = salt['pillar.get']('gcpjsonfile','NO_GCP_CREDENTIALS') %}
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
    - file_mode: 700

run_objbench_gcp:
  cmd.run:
    - name: python gcpexercizer.py {{ execute_map.get('data_dir') }}
    - cwd: {{ install_map.get('install_dir') }}
    -env:
      GOOGLE_APPLICATION_CREDENTIALS: {{ gcpjsonfile }}








