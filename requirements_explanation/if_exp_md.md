### Reason the `grammar.lark` and `interpreter.py` Meet the `if` Expression Feature Requirement

#### `if` Expression Feature
According to the project description (page 1 of the uploaded document), implementing the `if` expression is worth **8 points** under **basic features**. This feature requires:
- Support for conditional branching using the `if` keyword.
- Evaluation of a test expression (`test-exp`), followed by evaluation of the `then-exp` or `else-exp` based on the test result.
- **Bonus Requirements:**
  - Proper **type checking** to ensure the `test-exp` evaluates to a boolean value.
  - Recursive evaluation of nested `if` expressions.

---

### **How `grammar.lark` Handles `if` Expressions**

1. **Grammar for `if` Expressions**
   - The grammar for `if` expressions is explicitly defined in `grammar.lark`:
     ```lark
     ?if_exp : "(" "if" test_exp than_exp else_exp ")"
     ?test_exp : exp
     ?than_exp : exp
     ?else_exp : exp
     ```
   - **Key Requirements from Grammar:**
     - The `if` expression must begin with the keyword `if`.
     - The first argument (`test_exp`) is a valid expression (`exp`) that will determine the branching decision.
     - The second (`than_exp`) and third (`else_exp`) arguments are also valid expressions and represent the outcomes for `True` and `False`, respectively.

2. **Support for Nested `if` Expressions**
   - Since all components (`test_exp`, `than_exp`, and `else_exp`) are parsed as `exp`, the grammar allows for nesting of `if` expressions. For example:
     ```lisp
     (if #t 1 (if #f 2 3))
     ```
   - Grammar ensures that nested `if` expressions are syntactically valid.

---

### **How `interpreter.py` Executes `if` Expressions**

1. **Execution of `if` Expressions in the Interpreter**
   - The logic for handling `if` expressions is implemented in the `interpret_AST` function in `interpreter.py`:
     ```python
     elif node.data == 'if_exp':
         (test, then, els) = node.children
         test_res = interpret_AST(test, environment)
         if not isinstance(test_res, bool):
             raise TypeError("Expect 'boolean' but got 'number'.")
         expr = [els, then][test_res]
         return interpret_AST(expr, environment)
     ```

2. **Features of the `if` Expression Implementation:**
   - **Evaluation of `test_exp`:**
     - The test condition (`test_exp`) is evaluated first.
     - If the result is `True`, the `then-exp` is executed; otherwise, the `else-exp` is executed.
   - **Type Checking for `test_exp`:**
     - The `if` logic explicitly checks that the `test_exp` evaluates to a boolean:
       ```python
       if not isinstance(test_res, bool):
           raise TypeError("Expect 'boolean' but got 'number'.")
       ```
       - If the result is not a boolean, a `TypeError` is raised, fulfilling the **type checking bonus feature**.
   - **Recursive Evaluation of Expressions:**
     - Both `than_exp` and `else_exp` are recursively evaluated as expressions, allowing for complex nested conditions.

---

### **Validation Against the `if` Expression Requirements**

#### **Meets the Feature Description**
1. **Specification in Grammar:**
   - The `grammar.lark` defines strict syntax rules for `if` expressions, ensuring proper parsing.
   - All components (`test_exp`, `then_exp`, and `else_exp`) are validated as expressions (`exp`), enabling nesting.

2. **Implementation in Interpreter:**
   - The `interpreter.py` evaluates `if` expressions with correct branching logic and type checking for the `test_exp`.

---

### **Validation Against Bonus Requirements**

1. **Type Checking**
   - The interpreter ensures that the `test_exp` evaluates to a boolean. For example:
     - Invalid input:
       ```lisp
       (if 1 2 3)
       ```
       - Raises a `TypeError`:
         ```plaintext
         TypeError: Expect 'boolean' but got 'number'.
         ```

2. **Support for Nested `if` Expressions**
   - Both grammar and interpreter support nested `if` expressions. For example:
     ```lisp
     (if #t 1 (if #f 2 3))
     ```
     - Grammar parses this as valid syntax.
     - Interpreter evaluates it step by step:
       - Outer `if`: `#t → True`, so it evaluates `1`.
       - Output: `1`.

---

### **Test Case Validation**

1. **Demonstration of `if` Expressions**
   - Test cases like `05_1.lsp` and `05_2.lsp` demonstrate correct implementation of `if` expressions:
     - Example from `05_2.lsp`:
       ```lisp
       (print-num (if (< 1 2) (+ 1 2 3) (* 1 2 3 4 5)))
       ```
       - Grammar parses this as valid syntax.
       - Interpreter evaluates:
         - `(< 1 2)` → `True`.
         - Executes the `then-exp`: `(+ 1 2 3)` → `6`.
       - Output: `6`.

2. **Type Checking and Nested `if` Expressions**
   - Invalid cases like:
     ```lisp
     (if 1 2 3)
     ```
     - Grammar parses this, but the interpreter raises a `TypeError` during evaluation:
       ```plaintext
       TypeError: Expect 'boolean' but got 'number'.
       ```

---

### **Conclusion**

The combination of `grammar.lark` and `interpreter.py` fulfills the **if Expression feature** because:

1. **Grammar Validation:**
   - Rules for `if` expressions are explicitly defined, ensuring proper syntax and support for nested expressions.

2. **Interpreter Execution:**
   - Correct branching logic is implemented in the interpreter.
   - Type checking ensures the `test-exp` evaluates to a boolean.
   - Nested `if` expressions are evaluated recursively.

These implementations meet both **basic requirements** and **bonus feature requirements**, as demonstrated in the provided test cases.