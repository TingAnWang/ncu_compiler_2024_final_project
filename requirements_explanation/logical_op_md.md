### Reason the `grammar.lark` and `interpreter.py` Meet the Logical Operations Feature Requirement

#### Logical Operations Feature
According to the project description (page 1 of the uploaded document), implementing **all logical operations** is a key feature worth **25 points**. The required logical operations include:
- `and`
- `or`
- `not`

Each operation must handle boolean inputs, produce boolean outputs, and allow nested logical expressions. Additionally, **bonus requirements** include **type checking** to ensure only boolean values are processed by logical operations.

---

### **How `grammar.lark` Handles Logical Operations**

1. **Grammar for Logical Operations**
   - Logical operations are explicitly defined under the `logical_op` rule in `grammar.lark`:
     ```lark
     ?logical_op : and_op | or_op | not_op
     and_op     : "(" "and" exp exp+ ")"
     or_op      : "(" "or" exp exp+ ")"
     not_op     : "(" "not" exp ")"
     ```
   - **Key Requirements from Grammar:**
     - `and` and `or` operations accept multiple operands:
       - `exp exp+` requires at least two arguments.
     - `not` operation accepts exactly one operand (`exp`).
     - Operands are validated as `exp`, which allows for nesting logical operations and using boolean literals (`#t` and `#f`).

2. **Support for Nested Logical Expressions**
   - Since the operands are parsed as `exp`, logical operations can be nested. For example:
     ```lisp
     (and #t (or #f (not #t)))
     ```
   - Grammar ensures that such expressions are syntactically valid.

---

### **How `interpreter.py` Executes Logical Operations**

1. **Logical Operations in the Interpreter**
   - Logical operations are implemented in the `Table` class in `interpreter.py`. Each operation is defined as a method:
     ```python
     def and_op(self, *args):
         self.type_checker(bool, args)
         return all(args)

     def or_op(self, *args):
         self.type_checker(bool, args)
         return any(args)

     def not_op(self, arg):
         self.type_checker(bool, [arg])
         return not arg
     ```

2. **Features of Each Method:**
   - **Type Checking:**
     - The `type_checker` method ensures all arguments are booleans (`bool`):
       ```python
       def type_checker(dtype, args):
           for arg in args:
               if type(arg) != dtype:
                   raise TypeError(f'Expect {dtype} but got {type(arg)}')
       ```
       - If any argument is not a boolean, a `TypeError` is raised, fulfilling the **type checking bonus feature**.
   - **Logical Computation:**
     - **`and_op`:**
       - Evaluates `all(args)`, returning `True` only if all arguments are `True`.
     - **`or_op`:**
       - Evaluates `any(args)`, returning `True` if at least one argument is `True`.
     - **`not_op`:**
       - Computes the negation of the single argument using `not arg`.

3. **Handling Nested Logical Expressions**
   - Since logical operations operate on `exp` (expressions), they support nested evaluations. For example:
     - `(or #f (and #t #f) (not #f))`:
       - `(and #t #f)` → `False`
       - `(not #f)` → `True`
       - `(or #f False True)` → `True`

---

### **Validation Against Logical Operations Requirements**

#### **Meets the Feature Description**
1. **Specification in Grammar:**
   - The `grammar.lark` defines rules for logical operations, ensuring proper parsing.
   - Operands are validated as `exp`, allowing for booleans, variables, and nested expressions.

2. **Implementation in Interpreter:**
   - The `interpreter.py` implements logical operations with type checking and correct computation methods.
   - Nested expressions are supported through recursive evaluation of the AST.

---

### **Validation Against Bonus Requirements**

1. **Type Checking**
   - The interpreter ensures type consistency by checking that all arguments for `and`, `or`, and `not` are booleans.
   - For example:
     - Invalid input:
       ```lisp
       (and #t 1)
       ```
       - Raises a `TypeError`:
         ```plaintext
         TypeError: Expect <class 'bool'> but got <class 'int'>
         ```

2. **Nested Logical Operations**
   - Both grammar and interpreter support nested logical expressions.
   - Example:
     ```lisp
     (and #t (or #f (not #t)))
     ```
     - Evaluates step by step:
       - `(not #t)` → `False`
       - `(or #f False)` → `False`
       - `(and #t False)` → `False`

---

### **Test Case Validation**

1. **Demonstration of Logical Operations**
   - Logical operations are tested in cases like `04_1.lsp` and `04_2.lsp`:
     - Example from `04_2.lsp`:
       ```lisp
       (print-bool (or #t #f (not #f)))
       ```
       - Grammar parses this as valid syntax.
       - Interpreter evaluates it:
         - `(not #f)` → `True`
         - `(or #t #f True)` → `True`
       - Output: `#t`.

2. **Type Checking and Nested Expressions**
   - Cases like:
     ```lisp
     (and #t (not 1))
     ```
     - Grammar parses this, but the interpreter raises a `TypeError` during evaluation:
       ```plaintext
       TypeError: Expect <class 'bool'> but got <class 'int'>
       ```

---

### **Conclusion**

The combination of `grammar.lark` and `interpreter.py` fulfills the **Logical Operations feature** because:
1. **Grammar Validation:**
   - Rules for `and`, `or`, and `not` operations are explicitly defined.
   - Operands are validated as expressions, supporting nested logical expressions.

2. **Interpreter Execution:**
   - Logical operations are implemented with type checking and correct evaluation methods.
   - Nested logical expressions are evaluated recursively.

These implementations meet both **basic requirements** and **bonus feature requirements**, as demonstrated in the provided test cases.