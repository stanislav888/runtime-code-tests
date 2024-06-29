## Intro
It is a cmake-based playground to check different C\C++ code errors against different runtime sanitisers and Valgrind tools.

## How it works
File with buggy C\C++ code with *main()* are compiled into several executables with different sanitisers. 
CTest utility(part of CMake) runs these exeutables and check return codes. Having Valgrind installed, CTest runs different tests with this tool either. At the end you can see what tool catch code error and what does not.
An example of CTest ouput:

```
        Start 113: undefined-behaviour_addr-san
113/144 Test #113: undefined-behaviour_addr-san ..................   Passed    0.00 sec
        Start 114: undefined-behaviour_thrd-san
114/144 Test #114: undefined-behaviour_thrd-san ..................   Passed    0.01 sec
        Start 115: undefined-behaviour_undef-san
115/144 Test #115: undefined-behaviour_undef-san .................***Failed    0.00 sec
        Start 116: undefined-behaviour_leak-san
116/144 Test #116: undefined-behaviour_leak-san ..................   Passed    0.00 sec
        Start 117: undefined-behaviour
117/144 Test #117: undefined-behaviour ...........................   Passed    0.00 sec
        Start 118: undefined-behaviour_valgrind-memcheck
118/144 Test #118: undefined-behaviour_valgrind-memcheck .........***Failed    0.01 sec
        Start 119: undefined-behaviour_valgrind-helgrind
119/144 Test #119: undefined-behaviour_valgrind-helgrind .........   Passed    0.45 sec
        Start 120: undefined-behaviour_valgrind-drd
120/144 Test #120: undefined-behaviour_valgrind-drd ..............   Passed    0.48 sec
```
Where *undefined-behaviour* is a case of standalone executable program built & run with different tests and sanitiser options. It is based on source file (source/regular/undefined-behaviour.cpp).
The test name suffix defines the test case*(_addr-san, _valgrind-memcheck)*. 

## Current test cases
|Test pattern | Description |
|------------ | ------------- |
|**XXX_addr-san** | separated executable compiled with "-fsanitize=address"|
|**XXX_thrd-san** | executable compiled with "-fsanitize=thread"|
|**XXX_undef-san** | executable compiled with ""-fsanitize=undefined,float-divide-by-zero,float-cast-overflow""|
|**XXX_leak-san** | executable compiled with "-fsanitize=leak"|
|**XXX** | plain program run and return code checking. Also, it is the executable name used by Valgrind tools|
|**XXX_valgrind-memcheck**| program run under *valgrind --tool=memcheck --leak-check=full --show-leak-kinds=all --read-var-info=yes --leak-check-heuristics=full*|
|**XXX_valgrind-helgrind**| program run under *valgrind --tool=helgrind*|
|**XXX_valgrind-drd**| program run under *valgrind --tool=drd*|

Thus, embedded compiler sanitisers have separated executables for their tests. But Valgrind tools run one "plain" executable every test case.
The checkings are defined in *add_buggy_targets* function within *cmake/add-target.cmake* file.

## Quick start
*$ cd runtime-code-tests && cmake -B build -S ./ --fresh && cmake --build build && cd build && ctest*  
To see details of every sanitiser's errors. Rerun CTest:  
*$ ctest --rerun-failed --output-on-failure*

## Project structure  

| File or folder|Description|
|----------|--------------------------------------|
|**cmake/** | folder with custom cmake utility code|
|**source/**| source code to be tested|
|**source/regular/**| buggy sources with single-file program implementation|
|**source/complicated/**|buggy source code with complicated (multi-file) program implementation|
|**source/CMakeLists.txt**|CMake file where you can add your complicated test case|
|**source/include/**|all buggy sources "include" directory|
|**build/**|the preferred build folder|
|**build/buggy-progs/**|buggy executables to be run with CTest|

There are no "good" C++ code to work in solution. All job is done by CMake scripts.

## Adding your own test case (i.e. buggy program)
### Regular test case
It is single-file programs with a piece of buggy code inside. It should not require external libraries linking. 

1. Make your <program\>.cpp or <program\>.c with exactly these file extensions. <program\> will be the prefix of all these tests and executables. "return 0;" statement is mandatory in *main()*. It will be cheked.
2. Test compilation with simplest possible way like *gcc <program\>.c -o program*
3. Copy the source file into **source/regular/** . 
4. Run your builds and tests in the way of **Quick start** above.

CMake scripts should recognise your new source automatically by *.cpp & .c* file extensions(h, cxx and etc. are ignored). And make all apppropriate build and test preparations. Please check any source at **source/regular/** for example.

### Complicated test case
It is an advanced source set with any libraries. But the case requires to add your own CMake instructions.
You must know CMake well to do it!

1. Create any program source structure in **source/complicated**. The directory isn't scanned automatically for sources. "return 0;" is still mandatory in *main()*
2. Setup executable build with *add_buggy_targets( SOURCE TARGETS_DEPENDENCIES )* in the tail of **source/CMakeLists.txt**. Where SOURCE is a single source file. And TARGETS_DEPENDENCIES is a (CMake)list of configured CMake "tagret" dependencies to build your source. Understanding CMake "targets" is out of the topic and subject of CMake documentation.
3. Run the project build and tests as usual (**Quick start** above)

#### Please note
* Multi-threaded application can use *#include <thread\>* . Consider **source/regular/data-race.cpp** as an example
* Any libraries must be setup\imported\found\added by CMake code as a (CMake)"target". 
* Consider two examples of "complicated" sources in the middle of **source/CMakeLists.txt**
* To be honest, it never goes as smooth as described. Please be ready to nasty debug time. 

## Additional notes
The project is still a playground to test various C\C++ bugs with different runtime checkers. It doesn't pretend to fill anybody's needs or problems, as well as to have production quality code and structure. You can use this code in your projects in accordance to the Licence. Moreover, I will happy if you have any profits of such usage. 
It has been tested exceptionally under Linux with GCC(13.2.0), Clang(16.0.6) and CMake(3.25.1).
The solution is inspired by an excellent book **"Modern CMake for C++: Discover a better approach to building, testing, and packaging your software"** By Rafał Świdziński. If you are completely lost yourself in CMake stuff of this project. But despite of all, want to manage with it. Consider this book as a complete guide which help you on this way.

## License
SPDX short identifier: BSD-3-Clause 
