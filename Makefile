hosts.txt:
	curl -s http://winhelp2002.mvps.org/hosts.txt | sed -e 's/\r//' > $@

.PHONY: clean
clean:
	rm -f hosts.conf hosts.txt
