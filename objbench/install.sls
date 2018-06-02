{% from "objbench/map.jinja" import install_objbench as install_map with context %}
install_objbench:
  git.latest:
    - name: {{ install_map.get('git_url') }}
    - target: {{ install_map.get('install_dir') }}
    - rev: master

  pip.installed:
    - name: objectbench_requirements
    - requirements: {{ install_map.get('install_dir') }}/requirements.txt
  