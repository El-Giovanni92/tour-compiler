# Tour Management Compiler  

## Introduction  

The Tour Management Compiler is a project developed in C++ using Flex and Bison to create a compiler for processing structured input files containing information about musical tour dates and ticket sales. The compiler parses the input, applies category-based discounts, and generates detailed reports on earnings and ticket distribution.  

## Features  

- Lexical and syntactic analysis using Flex and Bison  
- Processing of structured input files containing tour dates, ticket categories, and pricing  
- Automatic discount application based on user categories (e.g., Musicians, Juniors, Seniors, Disabled, Authorities)  
- Generation of structured output files with sales statistics and financial reports  

## Installation  

To run the compiler, you need to install the following dependencies:  

- C++ Compiler (g++)  
- Flex  
- Bison  

Clone the repository:  

```bash
git clone https://github.com/El-Giovanni92/web-server-monitor.git
```

Navigate to the project directory and compile the executable:

```bash
make exe
```

## Usage
After building the executable, you can run the compiler with the default input file (input.txt) using:

```bash
./exe <input.txt
```
The processed data will be stored in output.txt.

To execute the compiler with a different input file, run:

```bash
./exe <filename.txt
```
The input file should follow the correct format, as shown in input.txt.

## Project Documentation
For an in-depth explanation of the project, please refer to the **Project Report.pdf** file.

### Contributors
[madoverflow](https://github.com/madoverflow)
