# vim: sts=2 ts=2 sw=2 et ai
{% from "nfs/map.jinja" import nfs with context %}

nfs_server__pkg_nfsserver:
  pkg.installed:
    - name: nfsserver
{% set slsrequires =salt['pillar.get']('nfs:slsrequires', False) %}
{% if slsrequires is defined and slsrequires %}
    - require:
{% for slsrequire in slsrequires %}
      - {{slsrequire}}
{% endfor %}
{% endif %}
    - pkgs: {{nfs.nfsserverpackages}}

{% if nfs.exports is defined and nfs.exports %}
nfs_server__file_/etc/exports:
  file.managed:
    - name: /etc/exports
    - source: salt://nfs/templates/etc/exports.jinja
    - template: jinja
    - user: root
    - group: root
    - mode: 0644
    - context: 
      nfs: {{nfs}}
    - require:
      - pkg: nfs_server__pkg_nfsserver
    - watch_in:
      - service: nfs_server__service_rpcbind
      - service: nfs_server__service_nfs
{% endif %}

nfs_server__service_rpcbind:
  service.running:
    - name: rpcbind
    - require:
      - pkg: nfs_server__pkg_nfsserver

nfs_server__service_nfs:
  service.running:
    - name: nfs-server
    - enable: true
    - require:
      - pkg: nfs_server__pkg_nfsserver
      - service: nfs_server__service_rpcbind
