## pcasm_examples
This repo is used to store the examples of pc assembly language.   
The pdf of this book: https://pdos.csail.mit.edu/6.828/2018/readings/pcasm-book.pdf

My Makefile skill is poor, but it works! Use this instruction to build all code files into output files below:   
```bash  
make
```
and use this to clean those obj files:  
```bash  
make clean  
```
or use this to initialize these repo, *MUST* use before 'git add':
```bash
make reset
```

Use this project **NEED** some dependencies: 
```bash
# for fedora/rh only:
sudo dnf install -y nasm
sudo dnf install -y gcc g++
sudo dnf install -y glibc-devel.i686
```

Have fun!