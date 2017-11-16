FROM    alpine:edge
RUN	    apk add --no-cache --update postfix ca-certificates supervisor rsyslog bash python py2-pip && \
	    (rm "/tmp/"* 2>/dev/null || true) && (rm -rf /var/cache/apk/* 2>/dev/null || true)

COPY	main.cf /etc/postfix/
COPY	supervisord.conf /etc/supervisord.conf
COPY	rsyslog.conf /etc/rsyslog.conf
COPY	postfix.sh /postfix.sh
COPY	mail2json.py /sbin/
RUN	    chmod +x /postfix.sh /sbin/mail2json.py
COPY	requirements.txt requirements.txt
RUN	    pip install -r requirements.txt

VOLUME	[ "/var/spool/postfix", "/etc/postfix" ]

USER	root
WORKDIR	/tmp

EXPOSE 25
ENTRYPOINT ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]

