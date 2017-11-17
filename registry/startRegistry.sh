#!/usr/bin/env bash

docker run -d -p 5000:5000 --restart=always --name registry \
  -v `pwd`/certs:/certs \
  -e REGISTRY_HTTP_TLS_CERTIFICATE=/certs/SSL.cer \
  -e REGISTRY_HTTP_TLS_KEY=/certs/measure.agilemeasure.com.key \
  registry:2