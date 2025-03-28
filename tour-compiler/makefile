exercise = progetto

exe: $(objs)
	@echo "Esecuzione compilatore bison..."
	@bison -d -o parser.cpp parser.y
	@echo "Esecuzione compilatore flex..."
	@flex -o lexer.cpp lexer.l
	@echo "Generazione eseguibile..."
	@g++ -o exe lexer.cpp parser.cpp
	@echo "Esecuzione..."
	@./exe <input.txt
pulizia:
	@cls
	@rm exe.exe lexer.cpp lexer.h parser.cpp parser.hpp output.txt
