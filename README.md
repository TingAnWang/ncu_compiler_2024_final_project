# ncu_compiler_2024_final_project
# Mini-Lisp Interpreter

This project provides a minimal Lisp-like language interpreter implemented in Python using [Lark](https://github.com/lark-parser/lark). It includes:

- A **grammar** definition (`grammar.lark`) describing the syntax of the mini-lisp language.  
- An **interpreter** (`interpreter.py`) that parses and evaluates mini-lisp code.  
- Basic arithmetic and logical operations, conditionals, user-defined functions, and variable definitions.  

---

## Features

- **Arithmetic operations**: `+`, `-`, `*`, `/`, and `mod`.  
- **Logical operations**: `and`, `or`, and `not`.  
- **Comparison operations**: `>`, `<`, and `=`.  
- **Boolean values**: `#t` (true) and `#f` (false).  
- **Conditional expressions**: `(if test then else)`.  
- **Variable definitions**: `(define variable expression)`.  
  - **No redefinition**: Once defined, a variable cannot be redefined in the same scope.  
- **User-defined functions**: `(fun (arg1 arg2 ...) body)`.  
- **Function calls**: `((fun (x) x) 5)` or `(some-fun 5 10)`.  
- **Printing**:  
  - `(print-num expr)` prints numeric values.  
  - `(print-bool expr)` prints `#t` or `#f`.  

---

## Dependencies

- **Python** 3.7+  
- **[Lark](https://github.com/lark-parser/lark)**: A modern parsing library for Python.  
- **[logging](https://docs.python.org/3/library/logging.html)** (part of the Python standard library).  

Install Lark if you haven’t already:

```bash
pip install lark-parser
```

---

## Language Overview

A quick overview of the mini-lisp syntax supported by this interpreter:

- **Expressions** can be:  
  - **Numbers**: Integers like `42` or `-5`.  
  - **Booleans**: `#t`, `#f`.  
  - **Variables**: Symbolic names (e.g., `x`, `my-var`).  
  - **Function calls**: `(f arg1 arg2 ...)` where `f` is a function name or a function expression.  
  - **Arithmetic**: `(+ expr expr+)`, `(- expr expr)`, `(* expr expr+)`, `(/ expr expr)`, `(mod expr expr)`.  
  - **Comparisons**: `(> expr expr)`, `(< expr expr)`, `(= expr expr+)`.  
  - **Logical ops**: `(and expr expr+)`, `(or expr expr+)`, `(not expr)`.  
  - **If expressions**: `(if test then else)`.  

- **Statements** include:
  - **`def_stmt`**: `(define x 10)` which defines a variable `x` with value `10`.  
  - **`print_num`**: `(print-num expr)` prints numeric result.  
  - **`print_bool`**: `(print-bool expr)` prints `#t` or `#f`.  

- **Functions**:
  - **Definition**: `(fun (x y) ( ... body ... ))` returns a function that takes two parameters, `x` and `y`, and uses them in `body`.  
  - **Call**: `((fun (x) x) 5)` calls a function inline, or `(some-fun 5)` if `some-fun` is bound to a function.

