FROM fluent/fluentd

COPY fluent.conf /fluentd/etc/fluent.conf

RUN gem install fluent-plugin-s3 -v 1.0.0 --no-document
