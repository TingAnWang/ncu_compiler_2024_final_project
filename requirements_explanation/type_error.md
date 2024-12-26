The **Type Checking** feature in the Mini-LISP interpreter ensures that operations are applied to compatible data types and raises errors when type mismatches occur. This is a **bonus feature** in the Compiler Final Project, described as "Print error messages for type errors" (Compiler Final Project, Page 2).

Here’s how the **Type Checking** feature aligns with `grammar.lark`, `interpreter.py`, and `test_results.txt`:

---

### Alignment with `grammar.lark`

The grammar (`grammar.lark`) enforces syntax rules for the Mini-LISP language but does not directly enforce type constraints. Instead, it defines the following constructs:

1. **Typed Expressions**:
   - Boolean literals: `BOOL_VAL` (`#t`, `#f`).
   - Numbers: `NUMBER`.
   - Operators like `+`, `and`, `if`, and others imply type requirements (e.g., `+` requires numbers, `and` requires booleans).

   Relevant Rules:
   ```lark
   BOOL_VAL : "#t" | "#f"
   NUMBER   : SIGNED_INT
   ?num_op  : plus | minus | multiply | divide | modulus | greater | smaller | equal
   ?logical_op : and_op | or_op | not_op
   ?if_exp : "(" "if" test_exp than_exp else_exp ")"
   ```

2. **Semantic Type Checking**:
   - While the grammar allows syntactically valid operations, type correctness (e.g., `(+ 1 #t)` is invalid) must be enforced in the interpreter.

---

### Alignment with `interpreter.py`

1. **Type Checking in Built-in Operations**:
   - The `SymbolTable` class includes methods for operations (e.g., `plus`, `and_op`) that enforce type checking using the `type_checker` helper method.

   ```python
   def type_checker(dtype, args):
       for arg in args:
           if type(arg) != dtype:
               raise TypeError(f"Expect {dtype} but got {type(arg)}")
   ```

   - For example, the `plus` operation ensures all arguments are integers:
     ```python
     def plus(self, *args):
         self.type_checker(int, args)
         return sum(args)
     ```

2. **Error Messaging for Type Mismatches**:
   - If a type mismatch occurs, the `type_checker` raises a `TypeError` with a detailed message.
   - Example:
     ```python
     (print-num (+ 1 #t))
     ```
     Output:
     ```
     Type Error: Expect <class 'int'> but got <class 'bool'>
     ```

3. **Type Checking for `if` Expressions**:
   - The `if_exp` branch in `interpret_AST` checks whether the condition (`test_exp`) evaluates to a boolean:
     ```python
     if not isinstance(test_res, bool):
         raise TypeError("Expect 'boolean' but got 'number'.")
     ```

4. **Scope of Type Checking**:
   - Type checking is applied in all built-in functions and logical constructs, such as:
     - Arithmetic operators (`+`, `-`, `*`, `/`, `mod`): Require integers.
     - Logical operators (`and`, `or`, `not`): Require booleans.
     - Relational operators (`<`, `>`, `=`): Require integers and return booleans.

---

### Alignment with `test_results.txt`

Several test cases explicitly validate the Type Checking feature:

1. **Arithmetic Type Errors**:
   - Test Case `b2_1.lsp`:
     ```lisp
     (+ 1 2 3 (or #t #f))
     ```
     **Output**:
     ```
     TypeError: Expect <class 'int'> but got <class 'bool'>
     ```
     Explanation:
     - The `+` operator expects all arguments to be integers.
     - `(or #t #f)` evaluates to a boolean, causing a type mismatch.

2. **Logical Type Errors**:
   - Test Case `b2_2.lsp`:
     ```lisp
     (define f
       (fun (x)
         (if (> x 10) 10 (= x 5))))
     (print-num (* 2 (f 4)))
     ```
     **Output**:
     ```
     TypeError: Expect <class 'int'> but got <class 'bool'>
     ```
     Explanation:
     - The `if` expression evaluates to a boolean (`(= x 5)`), but the `*` operator expects integers.

3. **Successful Type Usage**:
   - Test Case `02_1.lsp`:
     ```lisp
     (print-num 1)
     (print-num -123)
     ```
     **Output**:
     ```
     1
     -123
     ```
     Explanation:
     - Correct usage of `print-num` with integers.

4. **Error Messages for Invalid Constructs**:
   - The test results include clear error messages when type mismatches occur, confirming compliance with the requirement to "print error messages for type errors."

---

### Alignment with Project Requirements (Page 2, Compiler Final Project)

The **Type Checking** feature meets the bonus requirement by:
1. Enforcing type constraints for operations (`+`, `and`, `if`, etc.).
2. Printing meaningful error messages for type mismatches, such as:
   ```
   (> 1 #t)
   Type Error: Expect 'number' but got 'boolean'.
   ```

The type specification table in the project description (Page 2) is directly implemented in the interpreter:
| Operation      | Parameter Type  | Output Type       |
|----------------|-----------------|-------------------|
| `+`, `-`, `*`, `/`, `mod` | Number(s)       | Number            |
| `>`, `<`, `=`   | Number(s)       | Boolean           |
| `and`, `or`, `not` | Boolean(s)    | Boolean           |
| `if`            | Boolean (test)  | Depends on branches |

---

### Summary of Alignment

| Component         | Implementation                                                                                  |
|-------------------|------------------------------------------------------------------------------------------------|
| **grammar.lark**  | Defines constructs (`BOOL_VAL`, `NUMBER`, `if_exp`) but leaves type checking to the interpreter. |
| **interpreter.py**| Implements type checking in `type_checker`, arithmetic, logical, and `if` constructs, raising errors for mismatches. |
| **test_results.txt**| Validates type checking with cases like `b2_1.lsp` and `b2_2.lsp`, demonstrating errors for invalid operations. |

This feature ensures robust handling of invalid inputs, enhances the interpreter's reliability, and meets the project requirements for **Type Checking**. Let me know if you'd like further clarification or examples!