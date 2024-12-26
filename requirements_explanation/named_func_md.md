The **named function** feature in your project refers to the ability to define and call functions by assigning them a name (variable). This capability was implemented as part of the basic feature (Feature 8) and tested using Mini-LISP programs in `test_results.txt`. Below is how it aligns with the `grammar.lark`, `interpreter.py`, and `test_results.txt` files:

### Alignment with `grammar.lark`
1. **Syntax Definition**:
   - The `def_stmt` rule allows defining variables, including functions, with `(define variable exp)`. This enables associating a name with a function expression.
   - The `fun_exp` rule enables function declarations `(fun (arg1 arg2 ...) body)`.
   - The `fun_call` rule facilitates invoking functions, including named ones, with `(fun_name param*)`.

2. **Relevant Grammar**:
   ```lark
   def_stmt : "(" "define" variable exp ")"
   fun_exp  : "(" "fun" fun_ids fun_body ")"
   fun_call : "(" fun_exp param* ")"
             | "(" fun_name param* ")"
   ?fun_name : ID
   ```

### Alignment with `interpreter.py`
1. **Definition Handling**:
   - The `def_stmt` branch in `interpret_AST` processes variable definitions. When the value is a function (`fun_exp`), it associates the function object with the variable name in the `SymbolTable`.

   ```python
   elif node.data == 'def_stmt':
       (var, expr) = node.children
       environment[var] = interpret_AST(expr, environment)
   ```

2. **Function Representation**:
   - The `userFunction` class encapsulates the function's arguments, body, and the defining environment, enabling closure behavior when needed.

   ```python
   class userFunction:
       def __init__(self, args, body, environment=None):
           self.args = args
           self.body = body
           self.environment = environment
   ```

3. **Calling Named Functions**:
   - `fun_call` evaluates either an inline `fun_exp` or looks up a named function (`fun_name`) in the `SymbolTable` and invokes it with provided parameters.

   ```python
   elif node.data == 'fun_call':
       func = interpret_AST(node.children[0], environment)
       params = tuple(interpret_AST(expr, environment) for expr in node.children[1:])
       return func(*params)
   ```

### Alignment with `test_results.txt`
1. **Testing Named Functions**:
   - Test Case `08_1.lsp` demonstrates defining and calling a named function:
     ```lisp
     (define foo
       (fun (a b c) (+ a b (* b c))))
     (print-num (foo 10 9 8))
     ```
     **Output**: `91`, verifying successful named function implementation.

   - Test Case `08_2.lsp` extends functionality to multiple named functions:
     ```lisp
     (define bar (fun (x) (+ x 1)))
     (define bar-z (fun () 2))
     (print-num (bar (bar-z)))
     ```
     **Output**: `3`, showing correct handling of named function calls.

2. **Recursive Function Support**:
   - Bonus tests like `b1_1.lsp` further validate recursive calls within named functions.

### Project Requirements
The ability to declare and call named functions is explicitly required under **Feature 8: Named Function** in the project specification (Compiler Final Project, Page 1). The associated grammar, interpreter logic, and test cases collectively ensure the functionality meets the requirement.

Let me know if you need further clarification or additional details!