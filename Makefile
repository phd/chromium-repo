all:

clean:
	rm -f *.version
	rm -f *.checked
	rm -f *.log

remove:
	rm -rf focal kinetic jammy lunar mantic

chmod:
	chmod -R a+r .
	chmod    a+x .
