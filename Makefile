bind9.conf: hostnames.txt
	sed -e 's/.*/zone "\0" IN { type master; notify no; file "adblock.zone"; };/' < $< > $@

hosts.txt: hostnames.txt
	sed -e 's/^/127.0.0.1 /' < $< > $@

hostnames.txt: adaway.org.hostnames.txt winhelp2002.mvps.org.hostnames.txt
	egrep -hv '^localhost$$' $^ | sort -u > $@

%.hostnames.txt: %.hosts.txt
	egrep -o '^(127\.0\.0\.1|0\.0\.0\.0) [A-Za-z0-9.-]+' $< | cut -d ' ' -f 2 > $@

adaway.org.hosts.txt:
	curl -s https://adaway.org/hosts.txt -o $@

winhelp2002.mvps.org.hosts.txt:
	curl -s http://winhelp2002.mvps.org/hosts.txt -o $@

.PHONY: clean
clean:
	rm -f hosts.txt *.hosts.txt *.hostnames.txt
