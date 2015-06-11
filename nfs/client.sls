# vim: sts=2 ts=2 sw=2 et ai
{% from "nfs/map.jinja" import nfs with context %}

nfs_client__pkg_nfsclient:
  pkg.installed:
    - name: nfsclient
{% set slsrequires =salt['pillar.get']('nfs:slsrequires', False) %}
{% if slsrequires is defined and slsrequires %}
    - require:
{% for slsrequire in slsrequires %}
      - {{slsrequire}}
{% endfor %}
{% endif %}
    - pkgs: {{nfs.nfsclientpackages}}

nfs_client__service_rpcbind:
  service.running:
    - name: rpcbind
    - require:
      - pkg: nfs_client__pkg_nfsclient

nfs_client__service_nfs:
  service.running:
    - name: nfs
    - require:
      - pkg: nfs_client__pkg_nfsclient
      - service: nfs_client__service_rpcbind
