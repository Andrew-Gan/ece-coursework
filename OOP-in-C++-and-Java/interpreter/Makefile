# VARIABLES
SOURCE_C = interpreter.cpp
EXE_C = interpreter
GPP = g++ -o
MAKE = Makefile
INPUT0_TXT = Structured_Tests_Final/Basics.bin
INPUT1_TXT = Structured_Tests_Final/Comparisons.bin
INPUT2_TXT = Structured_Tests_Final/interpreter_Input.bin
INPUT3_TXT = Structured_Tests_Final/Jumps.bin
INPUT4_TXT = Structured_Tests_Final/Math.bin
INPUT5_TXT = Structured_Tests_Final/Peek_Poke.bin
INPUT6_TXT = Structured_Tests_Final/Push_Pop.bin
INPUT7_TXT = Structured_Tests_Final/Subroutines.bin
OUTPUT_TXT = Structured_Tests_Final/myOutput.txt
EXPECTED0_TXT = Structured_Tests_Final/BasicsOutput.txt
EXPECTED1_TXT = Structured_Tests_Final/ComparisonsOutput.txt
EXPECTED2_TXT = Structured_Tests_Final/interpreter_InputOutput.txt
EXPECTED3_TXT = Structured_Tests_Final/JumpsOutput.txt
EXPECTED4_TXT = Structured_Tests_Final/MathOutput.txt
EXPECTED5_TXT = Structured_Tests_Final/Peek_PokeOutput.txt
EXPECTED6_TXT = Structured_Tests_Final/Push_PopOutput.txt
EXPECTED7_TXT = Structured_Tests_Final/SubroutinesOutput.txt

# RULES
cc :
	$(GPP) $(EXE_C) $(SOURCE_C)

Basics :
	./$(EXE_C) $(INPUT0_TXT) $(OUTPUT_TXT)

Comparisons :
	./$(EXE_C) $(INPUT1_TXT) $(OUTPUT_TXT)

interpreter_Input :
	./$(EXE_C) $(INPUT2_TXT) $(OUTPUT_TXT)

Jumps :
	./$(EXE_C) $(INPUT3_TXT) $(OUTPUT_TXT)

Math :
	./$(EXE_C) $(INPUT4_TXT) $(OUTPUT_TXT)

Peek_Poke :
	./$(EXE_C) $(INPUT5_TXT) $(OUTPUT_TXT)

Push_Pop :
	./$(EXE_C) $(INPUT6_TXT) $(OUTPUT_TXT)

Subroutines :
	./$(EXE_C) $(INPUT7_TXT) $(OUTPUT_TXT)

run :
	@./$(EXE_C) $(INPUT0_TXT) $(OUTPUT_TXT)
	@cmp --silent $(OUTPUT_TXT) $(EXPECTED0_TXT) && echo '\e[32mTest 0 Passed: Basics\e[30m' || echo '\e[31mTest 0 Failed: Basics\e[30m'
	@./$(EXE_C) $(INPUT1_TXT) $(OUTPUT_TXT)
	@cmp --silent $(OUTPUT_TXT) $(EXPECTED1_TXT) && echo '\e[32mTest 1 Passed: Comparisons\e[30m' || echo '\e[31mTest 1 Failed: Comparisons\e[30m'
	@./$(EXE_C) $(INPUT2_TXT) $(OUTPUT_TXT)
	@cmp --silent $(OUTPUT_TXT) $(EXPECTED2_TXT) && echo '\e[32mTest 2 Passed: interpreter_Input\e[30m' || echo '\e[31mTest 2 Failed: interpreter_Input\e[30m'
	@./$(EXE_C) $(INPUT3_TXT) $(OUTPUT_TXT)
	@cmp --silent $(OUTPUT_TXT) $(EXPECTED3_TXT) && echo '\e[32mTest 3 Passed: Jumps\e[30m' || echo '\e[31mTest 3 Failed: Jumps\e[30m'
	@./$(EXE_C) $(INPUT4_TXT) $(OUTPUT_TXT)
	@cmp --silent $(OUTPUT_TXT) $(EXPECTED4_TXT) && echo '\e[32mTest 4 Passed: Math\e[30m' || echo '\e[31mTest 4 Failed: Math\e[30m'
	@./$(EXE_C) $(INPUT5_TXT) $(OUTPUT_TXT)
	@cmp --silent $(OUTPUT_TXT) $(EXPECTED5_TXT) && echo '\e[32mTest 5 Passed: Peek_Poke\e[30m' || echo '\e[31mTest 5 Failed: Peek_Poke\e[30m'
	@./$(EXE_C) $(INPUT6_TXT) $(OUTPUT_TXT)
	@cmp --silent $(OUTPUT_TXT) $(EXPECTED6_TXT) && echo '\e[32mTest 6 Passed: Push_Pop\e[30m' || echo '\e[31mTest 6 Failed: Push_Pop\e[30m'
	@./$(EXE_C) $(INPUT7_TXT) $(OUTPUT_TXT)
	@cmp --silent $(OUTPUT_TXT) $(EXPECTED7_TXT) && echo '\e[32mTest 7 Passed: Subroutines\e[30m' || echo '\e[31mTest 7 Failed: Subroutines\e[30m'

.PHONY : clean
clean : 
	rm $(OUTPUT_TXT) $(EXE_C)