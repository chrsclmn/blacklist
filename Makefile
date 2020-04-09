bind9.conf: hostnames
	sed -e 's/.*/zone "\0" IN { type master; notify no; file "adblock.zone"; };/' < $< > $@

hosts: hostnames
	sed -e 's/^/127.0.0.1 /' < $< > $@

hostnames: adaway.hostnames stevenblack.hostnames winhelp2002.hostnames
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
	rm -f bind9.conf hosts hostnames *.hosts *.hostnames
