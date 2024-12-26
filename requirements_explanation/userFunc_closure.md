Yes, the `userFunction` class is **the primary reason** that closures are supported in your Mini-LISP interpreter. Here's how it works and why it enables closures:

---

### What is a Closure?
A **closure** is a function that "remembers" the environment (i.e., the variable values) in which it was defined, even if it is executed outside of that environment. For example:
```lisp
(define add-x
  (fun (x) (fun (y) (+ x y))))
(define add-10 (add-x 10))
(print-num (add-10 5)) ; Output: 15
```
Here:
- The function `(fun (y) (+ x y))` retains access to `x` (from the outer function `add-x`), even when it is invoked as `add-10`.

---

### How `userFunction` Enables Closures
The `userFunction` class in your interpreter is specifically designed to support closures. Let's break down how it works:

1. **Capturing the Environment**:
   - When a function is created (via the `fun_exp` rule), the current environment (`SymbolTable`) is stored as part of the `userFunction` instance.
   - This environment ensures that all variables accessible at the time of the function's creation remain available later.

   ```python
   def __init__(self, args, body, environment=None):
       self.args = args          # Parameters of the function
       self.body = body          # Function body
       self.environment = environment  # Captures the defining environment (closure)
   ```

2. **Evaluating in the Captured Environment**:
   - When the function is called (via the `__call__` method), a new `SymbolTable` is created for the function's parameters, but it is chained to the stored environment.
   - This chaining ensures that the function has access to its own parameters (`args`) **and** the variables from the environment in which it was defined.

   ```python
   def __call__(self, *params):
       table = SymbolTable(
           symbol_names=self.args, 
           symbol_values=params, 
           outer=self.environment  # Outer environment is the captured closure
       )
       return interpret_AST(self.body, table)
   ```

3. **Environment Chaining**:
   - The `outer` attribute of `SymbolTable` links the function's local environment with its parent environment. This allows the interpreter to look up variables recursively through the scope chain.

   ```python
   class SymbolTable(dict):
       def __init__(self, symbol_names=None, symbol_values=None, outer=None):
           self.update(zip(symbol_names, symbol_values))
           self.outer = outer

       def find(self, name):
           if name in self:
               return self
           elif self.outer:
               return self.outer.find(name)
           else:
               raise NameError(f"{name} is not found.")
   ```

---

### Example of How It Works
For the closure example:
```lisp
(define add-x
  (fun (x) (fun (y) (+ x y))))
(define add-10 (add-x 10))
(print-num (add-10 5)) ; Output: 15
```

1. **Defining `add-x`**:
   - `add-x` is a function that takes `x` and returns another function `(fun (y) (+ x y))`.
   - When `add-x` is called with `10`, a `userFunction` instance is created for `(fun (y) (+ x y))`, capturing the environment where `x = 10`.

2. **Calling `add-10`**:
   - When `add-10` (the inner function) is invoked with `5`, the interpreter uses the captured environment where `x = 10`.
   - The calculation `(+ x y)` is evaluated as `(+ 10 5)`.

---

### Why `userFunction` is Essential
Without the `userFunction` class:
- The interpreter wouldn't have a way to store the environment where the function was defined.
- When a function is called, it would lose access to variables from its defining scope, breaking closure behavior.

The combination of the `userFunction` class and the `SymbolTable` structure ensures that closures work correctly in your interpreter.

---

### Summary
Yes, the `userFunction` class is the **key reason** closures are supported in your Mini-LISP interpreter. It:
1. Captures the environment at the time of function definition.
2. Uses this captured environment when the function is called, ensuring access to outer variables.
3. Enables first-class function behavior and supports higher-order programming. 

Let me know if you'd like to explore closures further!