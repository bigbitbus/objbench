{% from "objbench/map.jinja" import install_objbench as install_map with context %}
{% from "objbench/map.jinja" import execute_objbench as execute_map with context %}
{% set numIters = execute_map.get('numIters','file_') %}
{% set storageClass_aws = execute_map.get('storageClass_aws','STANDARD') %}
{% set storageClass_gcp = execute_map.get('storageClass_gcp','STANDARD') %}
{% set fileSizeskb = execute_map.get('fileSizeskb','1 100 1000') %}
{% set gcpjsonfile = salt['pillar.get']('gcpjsonfile','NO_GCP_CREDENTIALS') %}
{% set AZBLOBACCOUNT = salt['pillar.get']('AZBLOBACCOUNT','NO_AZURE_ACCOUNT') %}
{% set AZBLOBKEY = salt['pillar.get']('AZBLOBKEY','NO_AZURE_KEY') %}
{% set S3KEY = salt['pillar.get']('S3KEY','NO_AWS_KEY') %}
{% set S3SECRET = salt['pillar.get']('S3SECRET','NO_AWS_SECRET') %}
{% set platformgrain = salt['grains.get']('platformgrain') %}
create_setup:
  file.directory:
    - names: 
      - {{ execute_map.get('output_dir') }}
      - {{ execute_map.get('data_dir') }}
    - makedirs: True

{% if platformgrain == 'gcp' %}
copy_credentials:
  file.managed:
    - name: {{ execute_map.get('credentials_dir') }}/{{ gcpjsonfile }}
    - source: salt://credentials/{{ gcpjsonfile }}
    - include_empty: True
    - makedirs: True
    - file_mode: 700


run_objbench_gcp:
  cmd.run:
    - name: "python gcpexercizer.py {{ execute_map.get('data_dir') }} {{ storageClass_gcp }} {{ numIters }} {{ fileSizeskb }}"
    - cwd: {{ install_map.get('install_dir') }}
    - env:
      - GOOGLE_APPLICATION_CREDENTIALS: {{ execute_map.get('credentials_dir') }}/{{ gcpjsonfile }}
    - requires: create_setup
{% endif %}

{% if platformgrain == 'azure' %}
run_objbench_azure:
  cmd.run:
    - name: "python azureexercizer.py {{ execute_map.get('data_dir') }} {{ numIters }} {{ fileSizeskb }}"
    - cwd: {{ install_map.get('install_dir') }}
    - env:
      - AZBLOBACCOUNT: {{ AZBLOBACCOUNT }}
      - AZBLOBKEY: {{ AZBLOBKEY }}
    - requires: create_setup
{% endif %}

{% if platformgrain == 'aws' %}
run_objbench_aws:
  cmd.run:
    - name: "python awsexercizer.py {{ execute_map.get('data_dir') }} {{ storageClass_aws }} {{ numIters }}  {{ fileSizeskb }}"
    - cwd: {{ install_map.get('install_dir') }}
    - env:
      - S3KEY: {{ S3KEY }}
      - S3SECRET: {{ S3SECRET }}
    - requires: create_setup      
{% endif %}







