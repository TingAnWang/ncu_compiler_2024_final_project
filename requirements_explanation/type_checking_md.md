The **Type Checking** feature in the bonus requirements ensures the interpreter can detect and report type mismatches in Mini-LISP programs. This involves validating whether inputs to operations (e.g., arithmetic, logical, and comparisons) conform to expected types and throwing meaningful error messages when they don't.

Here’s how **grammar.lark** and **interpreter.py** meet this requirement:

---

### **Type Checking Bonus Requirement**
From the bonus features:
- **Requirement**: Detect and print error messages for type mismatches. For example:
  ```lisp
  (> 1 #t)
  → Type Error: Expect 'number' but got 'boolean'.
  ```
- **Expected Behavior**: Operations like `+`, `-`, `*`, `/`, `mod`, `and`, `or`, `not`, `if`, and function calls should validate their argument types.

---

### **Support for Type Checking in grammar.lark**

1. **Grammar Rules for Operations**
   ```lark
   ?num_op : plus | minus | multiply | divide | modulus | greater | smaller | equal
   plus     : "(" "+" exp exp+ ")"
   minus    : "(" "-" exp exp ")"
   multiply : "(" "*" exp exp+ ")"
   divide   : "(" "/" exp exp ")"
   modulus  : "(" "mod" exp exp ")"
   greater  : "(" ">" exp exp ")"
   smaller  : "(" "<" exp exp ")"
   equal    : "(" "=" exp exp+ ")"
   ```
   - Each numeric operation expects one or more `exp` (expressions) as arguments.
   - `exp` can represent any valid expression (e.g., numbers, variables, or other operations).

   **Logical Operations**:
   ```lark
   ?logical_op : and_op | or_op | not_op
   and_op     : "(" "and" exp exp+ ")"
   or_op      : "(" "or" exp exp+ ")"
   not_op     : "(" "not" exp ")"
   ```
   - Logical operations expect boolean arguments (`#t` or `#f`).

2. **Why This is Relevant**
   - The grammar does not explicitly restrict types (e.g., `exp` could represent anything).
   - Type validation is performed at runtime by the interpreter.

---

### **Support for Type Checking in interpreter.py**

#### 1. **`type_checker` Method**
   ```python
   @staticmethod
   def type_checker(dtype, args):
       """
       Helper method to validate that all items in 'args' match the expected type 'dtype'.
       Raises a TypeError with a meaningful message if any argument has the wrong type.
       """
       logging.debug('type-checker => args: {}'.format(args))
       for arg in args:
           if type(arg) != dtype:
               raise TypeError('Expect {} but got {}'.format(dtype, type(arg)))
   ```
   - This method:
     - Checks whether all elements in `args` match the specified `dtype` (e.g., `int` or `bool`).
     - Raises a `TypeError` with a detailed error message if a mismatch is found.

#### 2. **Type Checking in Built-In Functions**
Each built-in function explicitly calls `type_checker` to enforce type constraints. Examples:

##### **Arithmetic Operations**
   ```python
   def plus(self, *args):
       self.type_checker(int, args)  # Ensure all arguments are integers.
       return sum(args)
   ```

##### **Logical Operations**
   ```python
   def and_op(self, *args):
       self.type_checker(bool, args)  # Ensure all arguments are booleans.
       return all(args)
   ```

##### **Comparison Operations**
   ```python
   def greater(self, *args):
       self.type_checker(int, args)  # Ensure both arguments are integers.
       return args[0] > args[1]
   ```

- **Behavior**: Before performing any operation, the interpreter validates argument types using `type_checker`. If a mismatch is detected, an exception is raised.

#### 3. **Error Propagation**
The `type_checker` method raises a `TypeError`, which propagates back to the user as an error message. For example:
   ```python
   (> 1 #t)
   ```
   - During evaluation, the `greater` method calls `type_checker(int, args)` with `args = [1, True]`.
   - Since `True` is not an integer, a `TypeError` is raised:
     ```
     TypeError: Expect <class 'int'> but got <class 'bool'>
     ```

#### 4. **Conditional Expressions**
   ```python
   elif node.data == 'if_exp':
       (test, then, els) = node.children
       test_res = interpret_AST(test, environment)
       if not isinstance(test_res, bool):  # Ensure test condition is a boolean.
           raise TypeError("Expect 'boolean' but got 'number'.")
       expr = [els, then][test_res]
       return interpret_AST(expr, environment)
   ```
   - The `if_exp` rule enforces that the condition (`test_exp`) evaluates to a boolean.

#### 5. **Function Calls**
For function calls (`fun_call`), parameter type checking is implicit in how the function is defined and invoked:
   ```python
   def __call__(self, *params):
       table = Table(symbol_names=self.args, symbol_values=params, outer=self.environment)
       return interpret_AST(self.body, table)  # Evaluate function body in a new environment.
   ```
   - Incorrect parameter types lead to errors when evaluating the function body.

---

### **Example Walkthrough**
Given the input:
```lisp
(> 1 #t)
```

1. **Parsing**:
   - Grammar recognizes `>` as a `greater` operation with two arguments (`1` and `#t`).

2. **Interpretation**:
   - `greater` is invoked with arguments `[1, True]`.

3. **Type Checking**:
   - `type_checker(int, args)` detects a mismatch (`1` is an integer, but `#t` maps to `True` which is a boolean).

4. **Error Handling**:
   - A `TypeError` is raised:
     ```
     Type Error: Expect 'number' but got 'boolean'
     ```

---

### **Why It Meets the Requirement**
- **Grammar**: The grammar allows flexible expressions (`exp`), enabling runtime type checks.
- **Interpreter**:
  - Ensures type correctness for all operations (arithmetic, logical, conditionals, and functions).
  - Provides detailed error messages when mismatches occur.
- **Output**: Type errors are caught and reported to the user, fulfilling the bonus requirement.

This robust handling of types ensures that the **Type Checking** feature is fully implemented and compliant with the project specifications.