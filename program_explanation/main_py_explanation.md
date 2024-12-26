The `main.py` script is a simple command-line interface for running the Mini-LISP interpreter defined in **interpreter.py**. Here's an explanation of its components and their roles in the program:

---

### **1. Importing Required Modules**
```python
import sys
import argparse
from interpreter import Interpreter
import logging
```
- **`sys`**: Allows reading input from the standard input (`stdin`), which is how Mini-LISP code is provided to the interpreter.
- **`argparse`**: Handles command-line arguments for optional debugging.
- **`Interpreter`**: Imported from `interpreter.py`, it contains the logic to parse and evaluate Mini-LISP programs based on the grammar defined in `grammar.lark`.
- **`logging`**: Provides a mechanism for debugging and logging intermediate states during interpretation.

---

### **2. Main Program Execution**
```python
if __name__ == '__main__':
```
This condition ensures that the script is executed directly (not imported as a module). The script is the entry point for running the Mini-LISP interpreter.

---

### **3. Command-Line Argument Parsing**
```python
parser = argparse.ArgumentParser()
parser.add_argument('--debug', action='store_true')
args = parser.parse_args()
```
- **`argparse.ArgumentParser`**:
  - Defines command-line options for the script.
  - Here, a single argument, `--debug`, is defined.
- **`--debug`**:
  - If specified, enables verbose debugging output via the `logging` module.
  - `action='store_true'` means the argument is a flag (boolean), defaulting to `False`.

---

### **4. Configuring Debugging**
```python
if args.debug:
    logging.basicConfig(level=logging.DEBUG)
```
- If `--debug` is set when running the script, the logging level is configured to `DEBUG`, enabling detailed debug information during interpretation.
- Debugging is particularly helpful to trace the parsing and evaluation steps inside the `Interpreter` class and `interpret_AST` function.

---

### **5. Interpreting Mini-LISP Code**
```python
Interpreter().interpret(sys.stdin.read())
```
- **`Interpreter()`**:
  - Creates an instance of the `Interpreter` class from `interpreter.py`.
  - The `Interpreter` class is responsible for:
    1. Parsing Mini-LISP code using the grammar defined in `grammar.lark`.
    2. Evaluating the parsed syntax tree using its `interpret` method.
- **`sys.stdin.read()`**:
  - Reads the entire Mini-LISP code provided via standard input (e.g., piping or redirection).
  - The code is passed to the `interpret` method of the `Interpreter` instance.
- **Execution Flow**:
  1. The Mini-LISP code is parsed into an Abstract Syntax Tree (AST) using Lark (as defined in `grammar.lark`).
  2. The AST is evaluated recursively using `interpret_AST`.

---

### Example Workflow

#### **Command-Line Usage:**
```bash
echo "(print-num (+ 1 2))" | python3 main.py
```

1. **Input:** The Mini-LISP code `(print-num (+ 1 2))` is piped into `main.py`.
2. **Parsing:** 
   - `Interpreter` parses the input using Lark and `grammar.lark`.
   - The expression `(print-num (+ 1 2))` is parsed into an AST.
3. **Evaluation:**
   - `interpret_AST` evaluates the AST:
     - `(+ 1 2)` evaluates to `3`.
     - `print-num` outputs the result `3`.
4. **Output:** The result `3` is printed to the console.

#### **Debug Mode Example:**
```bash
echo "(print-num (* 2 3))" | python3 main.py --debug
```

- Adds detailed debug logs to trace how `(* 2 3)` is evaluated.

---

### Purpose of `main.py`
- **User Interface:** Provides a simple way to run Mini-LISP code using the interpreter.
- **Debugging Support:** Enables debugging to trace internal states during execution.
- **Code Integration:** Links the Mini-LISP grammar (`grammar.lark`) and interpreter logic (`interpreter.py`) into an executable program.

This script is designed to bridge user inputs and the underlying interpreter, making the Mini-LISP implementation accessible via a command-line interface.