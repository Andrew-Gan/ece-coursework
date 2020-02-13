# VARIABLES
HUFF_C = huff.c
UNHUFF_C = unhuff.c
HUFF = huff 
UNHUFF = unhuff
MAKE = Makefile

# RULES
compile :
	gcc -o $(HUFF) $(HUFF_C)
	gcc -o $(UNHUFF) $(UNHUFF_C)

run :
	./$(HUFF) text0.txt
	./$(HUFF) text1.txt
	./$(HUFF) text2.txt
	./$(HUFF) text3.txt
	./$(HUFF) text4.txt
	./$(HUFF) text5.txt
	./$(UNHUFF) text0.txt.huff
	./$(UNHUFF) text1.txt.huff
	./$(UNHUFF) text2.txt.huff
	./$(UNHUFF) text3.txt.huff
	./$(UNHUFF) text4.txt.huff
	./$(UNHUFF) text5.txt.huff

test :
	@cmp --silent text0.txt text0.txt.huff.unhuff && echo '### Test 0 Passed ###' || echo '### Test 0 Failed ###'
	@cmp --silent text1.txt text1.txt.huff.unhuff && echo '### Test 1 Passed ###' || echo '### Test 1 Failed ###'
	@cmp --silent text2.txt text2.txt.huff.unhuff && echo '### Test 2 Passed ###' || echo '### Test 2 Failed ###'
	@cmp --silent text3.txt text3.txt.huff.unhuff && echo '### Test 3 Passed ###' || echo '### Test 3 Failed ###'
	@cmp --silent text4.txt text4.txt.huff.unhuff && echo '### Test 4 Passed ###' || echo '### Test 4 Failed ###'
	@cmp --silent text5.txt text5.txt.huff.unhuff && echo '### Test 5 Passed ###' || echo '### Test 5 Failed ###'

ratio :
	@val=$(($(($(($(stat -c%s "text0.txt")-$(stat -c%s "text0.txt.huff")))*100))/$(stat -c%s "text0.txt")))
	@echo $val

clean : 
	rm -f *.txt.huff *.txt.huff.unhuff

# .PHONY TARGET
.PHONY: huff unhuff