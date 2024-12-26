### **Nested Function Feature**
The **nested function** feature in the bonus requirements allows Mini-LISP to define and use functions within other functions. This is useful for creating closures and enabling more modular, localized definitions of functionality.

---

### **Requirement for Nested Functions**
Nested functions involve:
1. Defining a function inside another function.
2. Allowing the inner function to access the local scope of the outer function (closure behavior).
3. Calling the inner function either within the outer function or elsewhere if returned.

For example:
```lisp
(define outer
 (fun (x)
  (define inner
   (fun (y) (+ x y)))
  (inner 10)))

(outer 5)  ; Output: 15
```

---

### **How `grammar.lark` Supports Nested Functions**

#### **Function Definitions**
```lark
fun_exp  : "(" "fun" fun_ids fun_body ")"
fun_ids  : "(" ID* ")"
fun_body : def_stmt* exp
```
- **`fun_exp`**:
  - Defines a function with parameters (`fun_ids`) and a body (`fun_body`).
  - The `fun_body` rule explicitly allows:
    - Multiple variable or function definitions (`def_stmt*`).
    - A single expression (`exp`), which may include function calls or nested function definitions.

#### **Variable and Function Declarations**
```lark
def_stmt : "(" "define" variable exp ")"
```
- **`def_stmt`**:
  - Allows defining a variable or function within the body of another function.
  - The `exp` in `def_stmt` can be a `fun_exp`, meaning a function can define another function.

#### **Function Calls**
```lark
fun_call : "(" fun_exp param* ")" | "(" fun_name param* ")"
```
- A function can call another function (e.g., a nested one) either by defining it inline (`fun_exp`) or by referencing a previously declared function name (`fun_name`).

---

### **How `interpreter.py` Supports Nested Functions**

#### **Function Definitions and Closures**
When a function is defined (`fun_exp`), it creates a `Function` object:
```python
elif node.data == 'fun_exp':
    args = interpret_AST(node.children[0], environment)  # Function parameters.
    body = interpret_AST(node.children[1], environment)  # Function body.
    return Function(args, body, environment)  # Create a Function object.
```
- The `Function` object captures:
  - **`args`**: The parameter names.
  - **`body`**: The function body (as an AST).
  - **`environment`**: The environment where the function is defined.

- This means:
  - Inner functions automatically have access to the environment (scope) of the outer function, enabling closures.

#### **Function Calls**
When a function is called (`fun_call`), it evaluates the parameters and creates a new environment:
```python
elif node.data == 'fun_call':
    func = interpret_AST(node.children[0], environment)  # Evaluate the function.
    params = tuple(interpret_AST(expr, environment) for expr in node.children[1:])  # Evaluate arguments.
    return func(*params)  # Call the function with evaluated arguments.
```
- **Nested Function Calls**:
  - If the function body includes calls to a nested function, the interpreter evaluates those calls within the local environment of the outer function.

#### **Environment Management**
The `SymbolTable` class handles nested scopes:
```python
def __call__(self, *params):
    table = SymbolTable(symbol_names=self.args, symbol_values=params, outer=self.environment)
    return interpret_AST(self.body, table)  # Evaluate the function body in the new environment.
```
- When a function is called:
  - A new `SymbolTable` (environment) is created for the function's parameters and body.
  - This `SymbolTable` references the `outer` environment (where the function was defined).
- **Closure Support**:
  - If the nested function references variables from the outer function, it finds them in the outer scope through the `outer` reference in `SymbolTable`.

#### **Variable and Function Lookup**
The `SymbolTable` class allows variables and functions to be accessed from nested scopes:
```python
def find(self, name):
    if name not in self and self.outer is None:
        raise NameError('{} is not found'.format(name))
    return self if name in self else self.outer.find(name)
```
- If the nested function references a variable or function from its enclosing scope, the `find` method resolves it by traversing the chain of environments (`self.outer`).

---

### **Example Walkthrough**

#### Code:
```lisp
(define outer
 (fun (x)
  (define inner
   (fun (y) (+ x y)))
  (inner 10)))

(outer 5)
```

#### Parsing:
- **`define outer`**:
  - Assigns an anonymous function (`fun_exp`) to the variable `outer`.
- **`fun_exp` (outer function)**:
  - Parameter: `x`.
  - Body:
    - **`define inner`**: Assigns an anonymous function (`fun_exp`) to `inner`.
    - **Function Call (`inner 10`)**: Calls the `inner` function with `y = 10`.

#### Interpretation:
1. **Defining `outer`**:
   - `outer` is stored in the global environment as a `Function` object.
2. **Calling `outer(5)`**:
   - A new environment is created with `x = 5`.
   - The `outer` function body is evaluated in this environment.
3. **Defining `inner`**:
   - `inner` is stored in the local environment of `outer` as a `Function` object.
4. **Calling `inner(10)`**:
   - A new environment is created with `y = 10`.
   - The `inner` function body (`(+ x y)`) is evaluated.
   - The `x` variable is resolved from the `outer` environment (`x = 5`).

#### Output:
- `(+ x y)` → `(+ 5 10)` → `15`.

---

### **Why It Meets the Requirement**

1. **Grammar**:
   - Nested function definitions are supported by allowing `def_stmt` within `fun_body`.
   - Nested function calls are supported by referencing either `fun_exp` or `fun_name`.

2. **Interpreter**:
   - Closures are implemented by capturing the `environment` when a function is defined.
   - Nested function calls resolve variables and functions from the correct scope using the `SymbolTable` class.

3. **Behavior**:
   - Nested functions can:
     - Access variables from their enclosing scope.
     - Be called recursively or within other functions.
   - The interpreter handles these cases seamlessly.

This implementation satisfies the **nested function** bonus requirement.