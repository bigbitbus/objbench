{% from "objbench/map.jinja" import install_objbench as install_map with context %}
install_objbench:
  pkg.installed:
    - pkgs:
      - python-pip

  git.latest:
    - name: {{ install_map.get('git_url') }}
    - target: {{ install_map.get('install_dir') }}
    - rev: {{ install_map.get('git_rev') }}
    - branch: {{ install_map.get('git_rev') }}
    - force_reset: True

  pip.installed:
    - name: objectbench_requirements
    - requirements: {{ install_map.get('install_dir') }}/requirements.txt
    - requires: 
      - pkg.installed
  