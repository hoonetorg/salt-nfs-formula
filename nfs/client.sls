# vim: sts=2 ts=2 sw=2 et ai
{% from "nfs/map.jinja" import nfs with context %}

nfs_client__pkg_nfsclient:
  pkg.installed:
    - name: nfsclient
{% if nfs.client is defined and nfs.client.slsrequires is defined and nfs.client.slsrequires %}
    - require:
{% for slsrequire in nfs.client.slsrequires %}
      - {{slsrequire}}
{% endfor %}
{% endif %}
    - pkgs: {{nfs.nfsclientpackages}}

nfs_client__service_rpcbind:
  service.running:
    - name: rpcbind
    - require:
      - pkg: nfs_client__pkg_nfsclient

#nfs_client__service_rpc-statd:
#  service.running:
#    - name: rpc-statd
#    - require:
#      - pkg: nfs_client__pkg_nfsclient
#      - service: nfs_client__service_rpcbind
