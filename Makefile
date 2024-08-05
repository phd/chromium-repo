all:

clean:
	rm -f *.checked
	rm -f *.log
	rm -f *.old
	rm -f *.version

remove:
	rm -rf focal kinetic jammy lunar mantic

chmod:
	chmod -R a+r .
	chmod    a+x .

dependencies:
	sudo apt-get install apt-utils gpg gzip wget
