hosts: hostnames
	sed -e 's/^/127.0.0.1 /' < $< > $@

rpz.zone: hostnames
	echo '$$TTL 1h' > $@
	echo '@ SOA localhost. root.localhost. (1 1h 15m 30d 2h)' >> $@
	echo '@ NS  localhost.' >> $@
	sed -e 's/.*/\0 A 127.0.0.1/' < $< >> $@

hostnames: adaway.hostnames stevenblack.hostnames winhelp2002.hostnames custom.hostnames
	cat $^ | egrep -v '^local(host(\.localdomain)?)?$$' | egrep -v '^[0-9.]+$$' | sort -u > $@

%.hostnames: %.hosts
	egrep -o '^(127\.0\.0\.1|0\.0\.0\.0) [A-Za-z0-9.-]+' $< | cut -d ' ' -f 2 > $@

adaway.hosts:
	curl -s https://adaway.org/hosts.txt -o $@

stevenblack.hosts:
	curl -s https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts -o $@

winhelp2002.hosts:
	curl -s http://winhelp2002.mvps.org/hosts.txt -o $@

.PHONY: clean
clean:
	rm -f hosts rpz.zone hostnames *.hosts *.hostnames
