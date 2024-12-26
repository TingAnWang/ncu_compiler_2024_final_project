### How **grammar.lark** and **interpreter.py** Implement Recursion
因為function 成為可呼叫object，所以可以隨時呼叫或作為參數傳遞。
#### **Recursion Bonus Requirement** (From the Project File)
The requirement states that the interpreter must support recursive function calls. For example:

```lisp
(define f
 (fun (x) (if (= x 1)
  1
  (* x (f (- x 1))))))
(f 4) → 24
```

This involves:
1. Defining a named function (`f`).
2. Allowing the function `f` to call itself (`recursive call`).
3. Using the function's local parameter and scope to compute the result.

#### **Reason Why the Grammar Supports Recursion**

1. **Grammar Rule for Functions:**
   ```lark
   fun_exp  : "(" "fun" fun_ids fun_body ")"
   fun_ids  : "(" ID* ")"
   fun_body : def_stmt* exp
   ```
   - **`fun_exp`**: Defines an anonymous function with parameters (`fun_ids`) and a body (`fun_body`).
   - **`fun_body`**: Can include multiple variable definitions (`def_stmt`) followed by a single expression (`exp`).

   - Since `exp` allows a function call (via `fun_call`), recursive references to the same function are inherently supported by this structure.

2. **Grammar Rule for Named Functions:**
   ```lark
   def_stmt : "(" "define" variable exp ")"
   ```
   - A named function can be declared by assigning an anonymous function (`fun_exp`) to a variable (`variable`). This allows the function to reference itself recursively.

3. **Grammar Rule for Function Calls:**
   ```lark
   fun_call : "(" fun_exp param* ")" | "(" fun_name param* ")"
   ```
   - **Recursive Function Calls**: A function can call itself if the `fun_name` in `fun_call` refers to the same function. This is explicitly supported in the grammar.

#### **Why the Interpreter Supports Recursion**

1. **Handling Function Definitions:**
   In `interpret_AST`, function definitions (`fun_exp`) are processed as follows:
   ```python
   elif node.data == 'fun_exp':
       args = interpret_AST(node.children[0], environment)  # Get function parameters.
       body = interpret_AST(node.children[1], environment)  # Get function body.
       return Function(args, body, environment)  # Create a Function object.
   ```

   - The `Function` object captures:
     - The **parameters** (`args`).
     - The **body** (`body`) as an Abstract Syntax Tree (AST).
     - The **environment** where the function was defined.

2. **Handling Function Calls:**
   In `interpret_AST`, function calls (`fun_call`) are processed as follows:
   ```python
   elif node.data == 'fun_call':
       func = interpret_AST(node.children[0], environment)  # Evaluate the function.
       params = tuple(interpret_AST(expr, environment) for expr in node.children[1:])  # Evaluate arguments.
       return func(*params)  # Call the function with evaluated arguments.
   ```

   - When a recursive function is called, the `Function` object is invoked via its `__call__` method:
     ```python
     def __call__(self, *params):
         table = Table(symbol_names=self.args, symbol_values=params, outer=self.environment)
         return interpret_AST(self.body, table)  # Recursively evaluate the function body.
     ```
   - The recursive call creates a **new environment** (`table`) for each invocation, preserving the current parameter values and enabling the function to reference itself.

3. **Support for Recursive Scoping:**
   The `Table` class manages variable lookups:
   ```python
   def find(self, name):
       if name not in self and self.outer is None:
           raise NameError('{} is not found'.format(name))
       return self if name in self else self.outer.find(name)
   ```

   - If the recursive function references itself, it can find its definition in the environment where it was originally declared, enabling recursion.

#### **How It All Comes Together**

For the recursive function example:
```lisp
(define f
 (fun (x) (if (= x 1)
  1
  (* x (f (- x 1))))))
(f 4) → 24
```

1. **Function Definition**:
   - `(define f ...)`:
     - `f` is defined as a variable in the global environment, storing a `Function` object.
   
2. **Function Call**:
   - `(f 4)`:
     - `f` is found in the global environment.
     - The `Function` object is invoked with the argument `4`.

3. **Recursive Call**:
   - During evaluation, the `if` expression detects `x != 1` and recursively calls `(f (- x 1))` with `x = 3`.
   - This continues until `x == 1`, at which point the recursion stops, and the results are computed.

4. **Evaluation Flow**:
   - The recursive calls create new environments for each invocation, maintaining the integrity of each scope.

#### **Conclusion**

The combination of **grammar.lark** (which allows function definitions and calls) and **interpreter.py** (which correctly handles environments and recursive calls) ensures that the Mini-LISP interpreter supports recursion as described in the bonus requirements.