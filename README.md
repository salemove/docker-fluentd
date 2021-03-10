# docker-fluentd
Fluentd image with added plugins:

* fluent-plugin-kubernetes_metadata_filter -v 2.5.2
* fluent-plugin-elasticsearch -v 3.5.2
* fluent-plugin-dogstatsd -v 0.0.6
* fluent-plugin-multi-format-parser -v 1.0.0
* fluent-plugin-record-modifier -v 2.0.1
* fluent-plugin-systemd -v 1.0.2
* fluent-plugin-aws-elasticsearch-service -v 2.4.0

## Local build 

To run build locally please use the next command:
```bash
docker build -t salemove/docker-fluentd:local --build-arg FLUENTD_VERSION=1.4.2 .
```
