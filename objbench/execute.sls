{% from "objbench/map.jinja" import install_objbench as install_map with context %}
{% from "objbench/map.jinja" import execute_objbench as execute_map with context %}

create_data:
  file.directory:
    - name: {{ execute_map.get('output_dir') }}
    - makedirs: True

  cmd.run:
    - name: 'python datamaker.py {{ execute_map.get('output_dir') }}'
    - cwd: {{ install_map.get('install_dir') }}
    - requires: file.directory

copy_credentials:
  file.recurse:
    - name: /root/credentials
    - source: salt://credentials
    - include_empty: True
    - makedirs: True






