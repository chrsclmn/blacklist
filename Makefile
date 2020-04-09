bind9.conf: hostnames.txt
	sed -e 's/.*/zone "\0" IN { type master; notify no; file "adblock.zone"; };/' < $< > $@

hosts.txt: hostnames.txt
	sed -e 's/^/127.0.0.1 /' < $< > $@

hostnames.txt: adaway.hostnames.txt stevenblack.hostnames.txt winhelp2002.hostnames.txt
	cat $^ | egrep -v '^local(host(\.localdomain)?)?$$' | egrep -v '^[0-9.]+$$' | sort -u > $@

%.hostnames.txt: %.hosts.txt
	egrep -o '^(127\.0\.0\.1|0\.0\.0\.0) [A-Za-z0-9.-]+' $< | cut -d ' ' -f 2 > $@

adaway.hosts.txt:
	curl -s https://adaway.org/hosts.txt -o $@

stevenblack.hosts.txt:
	curl -s https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts -o $@

winhelp2002.hosts.txt:
	curl -s http://winhelp2002.mvps.org/hosts.txt -o $@

.PHONY: clean
clean:
	rm -f bind9.conf hosts.txt hostnames.txt *.hosts.txt *.hostnames.txt
