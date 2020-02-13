# VARIABLES
SRC_C = json.c
HEADER_H = json.h miniunit.h
SRC_H = json.h clog.h miniunit.h
TEST_C = test_json.c
ECHO_C = echo_color.c
COLOR_EXE = echo_color
TEST_EXPECTED = expected.txt
TEST_ACTUAL = actual.txt
EXECUTABLE = json
MAKE = Makefile
ASG_NICKNAME = HW08
CC = gcc
CFLAGS = -g -std=c99 -Wall -Wshadow -Wvla -Werror -pedantic
CFLAGS_GCOV = $(CFLAGS) -fprofile-arcs -ftest-coverage
COV_FILE = json.c.gcov test_json.gcda json.gcda test_json.gcno json.gcno

# RULES
$(EXECUTABLE) : $(TEST_C) $(SRC_C)
	$(CC) -o $(EXECUTABLE) $(TEST_C) $(SRC_C) $(CFLAGS)

test : $(EXECUTABLE $(TEST_ACTUAL) $(TEST_EXPECTED) $(COLOR_EXE)
	./$(EXECUTABLE) > $(TEST_ACTUAL)
	@diff -b $(TEST_ACTUAL) $(TEST_EXPECTED) &> /dev/null;									\
	if [ $$? -eq 0 ]; 																		\
	then 																					\
		./$(COLOR_EXE) green "Test passed: $(TEST_ACTUAL) matches $(TEST_EXPECTED)"; 		\
	else 																					\
		./$(COLOR_EXE) red "Test failed: $(TEST_ACTUAL) does NOT match $(TEST_EXPECTED)"; \
	fi

submit : $(SRC_C) $(TEST_C) $(TEST_EXPECTED) $(HEADER_H)
	264submit $(ASG_NICKNAME) $(SRC_C) $(TEST_C) $(TEST_EXPECTED) $(HEADER_H)

pretest :
	264test $(ASG_NICKNAME)

coverage : $(EXECUTABLE) $(SRC_C)
	$(CC) -o $(EXECUTABLE) $(TEST_C) $(SRC_C) $(CFLAGS_GCOV) -DNDEBUG
	./$(EXECUTABLE) &> /dev/null;
	gcov -f $(SRC_C)

debug : $(TEST_C) $(SRC_C)
	$(CC) -DDEBUG -o $(EXECUTABLE) $(TEST_C) $(SRC_C) $(CFLAGS)

$(COLOR_EXE) : $(ECHO.C)
	$(CC) -o $(COLOR_EXE) $(ECHO_C)

clean : $(EXECUTABLE) $(COLOR_EXE) $(TEST_ACTUAL) $(COV_FILE)
	rm -f $(EXECUTABLE) $(COLOR_EXE) $(TEST_ACTUAL) $(COV_FILE)

# .PHONY TARGET
.PHONY :
