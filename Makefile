all:

clean:
	rm -f *.version
	rm -f *.checked
	rm -f *.log

remove:
	rm -rf focal jammy lunar mantic

chmod:
	chmod -R a+r .
	chmod    a+x .
