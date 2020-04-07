bind9.conf: hosts.txt
	egrep -o '^0\.0\.0\.0 [^ ]+' $< | cut -d ' ' -f 2 | sed -e 's/.*/zone "\0" IN { type master; notify no; file "adblock.zone"; };/' > $@

hosts.txt:
	curl -s http://winhelp2002.mvps.org/hosts.txt | sed -e 's/\r//' > $@

.PHONY: clean
clean:
	rm -f hosts.txt
