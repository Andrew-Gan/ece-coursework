# VARIABLES
SOURCE_JAVA = Main.java
EXE = Main
INTR = java
JAVAC = javac
MAKE = Makefile
INPUT0_TXT = Compiler_Test_Cases/Compiler_Inputs/Basics.txt
INPUT1_TXT = Compiler_Test_Cases/Compiler_Inputs/Comprehensive.txt
INPUT2_TXT = Compiler_Test_Cases/Compiler_Inputs/Jumping.txt
INPUT3_TXT = Compiler_Test_Cases/Compiler_Inputs/Other_Instructions.txt
INPUT4_TXT = Compiler_Test_Cases/Compiler_Inputs/Poke_Peek.txt
INPUT5_TXT = Compiler_Test_Cases/Compiler_Inputs/Simple_Math.txt
INPUT6_TXT = Compiler_Test_Cases/Compiler_Inputs/Simple_Variables.txt
OUTPUT_TXT = myOutput.bin
EXPECTED0_BIN = Compiler_Test_Cases/Compiler_Binary_Output/Basics.bin
EXPECTED1_BIN = Compiler_Test_Cases/Compiler_Binary_Output/Comprehensive.bin
EXPECTED2_BIN = Compiler_Test_Cases/Compiler_Binary_Output/Jumping.bin
EXPECTED3_BIN = Compiler_Test_Cases/Compiler_Binary_Output/Other_Instructions.bin
EXPECTED4_BIN = Compiler_Test_Cases/Compiler_Binary_Output/Poke_Peek.bin
EXPECTED5_BIN = Compiler_Test_Cases/Compiler_Binary_Output/Simple_Math.bin
EXPECTED6_BIN = Compiler_Test_Cases/Compiler_Binary_Output/Simple_Variables.bin

# RULES
cc :
	$(JAVAC) $(SOURCE_JAVA)

Basics :
	$(INTR) $(EXE) $(INPUT0_TXT) $(OUTPUT_TXT)

Comprehensive :
	$(INTR) $(EXE) $(INPUT1_TXT) $(OUTPUT_TXT)

Jumping :
	$(INTR) $(EXE) $(INPUT2_TXT) $(OUTPUT_TXT)

Other_Instructions :
	$(INTR) $(EXE) $(INPUT3_TXT) $(OUTPUT_TXT)

Poke_Peek :
	$(INTR) $(EXE) $(INPUT4_TXT) $(OUTPUT_TXT)

Simple_Math :
	$(INTR) $(EXE) $(INPUT5_TXT) $(OUTPUT_TXT)

Simple_Variables :
	$(INTR) $(EXE) $(INPUT6_TXT) $(OUTPUT_TXT)

run :
	@$(INTR) $(EXE) $(INPUT0_TXT) $(OUTPUT_TXT)
	@cmp --silent $(OUTPUT_TXT) $(EXPECTED0_BIN) && echo '\e[32mTest 0 Passed: Basics\e[30m' || echo '\e[31mTest 0 Failed: Basics\e[30m'
	@$(INTR) $(EXE) $(INPUT1_TXT) $(OUTPUT_TXT)
	@cmp --silent $(OUTPUT_TXT) $(EXPECTED1_BIN) && echo '\e[32mTest 1 Passed: Comprehensive\e[30m' || echo '\e[31mTest 1 Failed: Comprehensive\e[30m'
	@$(INTR) $(EXE) $(INPUT2_TXT) $(OUTPUT_TXT)
	@cmp --silent $(OUTPUT_TXT) $(EXPECTED2_BIN) && echo '\e[32mTest 2 Passed: Jumping\e[30m' || echo '\e[31mTest 2 Failed: Jumping\e[30m'
	@$(INTR) $(EXE) $(INPUT3_TXT) $(OUTPUT_TXT)
	@cmp --silent $(OUTPUT_TXT) $(EXPECTED3_BIN) && echo '\e[32mTest 3 Passed: Other_Instructions\e[30m' || echo '\e[31mTest 3 Failed: Other_Instructions\e[30m'
	@$(INTR) $(EXE) $(INPUT4_TXT) $(OUTPUT_TXT)
	@cmp --silent $(OUTPUT_TXT) $(EXPECTED4_BIN) && echo '\e[32mTest 4 Passed: Poke_Peek\e[30m' || echo '\e[31mTest 4 Failed: Poke_Peek\e[30m'
	@$(INTR) $(EXE) $(INPUT5_TXT) $(OUTPUT_TXT)
	@cmp --silent $(OUTPUT_TXT) $(EXPECTED5_BIN) && echo '\e[32mTest 5 Passed: Simple_Math\e[30m' || echo '\e[31mTest 5 Failed: Simple_Math\e[30m'
	@$(INTR) $(EXE) $(INPUT6_TXT) $(OUTPUT_TXT)
	@cmp --silent $(OUTPUT_TXT) $(EXPECTED6_BIN) && echo '\e[32mTest 6 Passed: Simple_Variables\e[30m' || echo '\e[31mTest 6 Failed: Simple_Variables\e[30m'

.PHONY : clean
clean : 
	rm $(OUTPUT_TXT) *.class