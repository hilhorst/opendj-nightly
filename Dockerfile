FROM java:8
MAINTAINER Nick Hilhorst "nick.hilhorst@kpnmail.nl"

ENV LDAP_HOSTNAME=localhost LDAP_BASE_DN=dc=example,dc=com LDAP_ROOT_USER_DN=cn=admin LDAP_ROOT_USER_PASS=password

RUN curl https://forgerock.org/djs/opendjrel.js | grep -o "http://.*\.deb" | xargs curl -o opendj.deb && \
	dpkg -i opendj.deb && \
	rm opendj.deb

EXPOSE 389 636 4444

CMD	/opt/opendj/setup \
		--cli \
		--verbose \
		--acceptLicense \
		--hostname "$LDAP_HOSTNAME" \
		--baseDN "$LDAP_BASE_DN" \
		--addBaseEntry \
		--rootUserDN "$LDAP_ROOT_USER_DN" \
		--rootUserPassword "$LDAP_ROOT_USER_PASS" \
		--generateSelfSignedCertificate \
		--enableStartTLS \
		--no-prompt \
		--noPropertiesFile \
		--doNotStart \
	&& \
	/opt/opendj/bin/start-ds \
		--nodetach
