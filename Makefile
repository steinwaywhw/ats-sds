

test: test.dats
	patscc -o a.out test.dats sds/sds.c
	
clean:
	rm *ats.c 

cleanall: clean 
	rm a.out