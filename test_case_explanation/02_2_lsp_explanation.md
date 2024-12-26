### Detailed Explanation of Test Case `02_2.lsp`

#### Content of `02_2.lsp`
```lisp
(print-num 0)
(print-num -123)
(print-num 456)
```

---

### Grammar Parsing

1. **Grammar Rule for `print-num`:**
   - The `print-num` operation is defined under the `print_stmt` rule in `grammar.lark`:
     ```lark
     print_stmt: "(" "print-num" exp ")" -> print_num
     ```
   - This rule specifies that:
     - The operation begins with an opening parenthesis `(`.
     - The keyword `print-num` is used to indicate a print operation for numerical values.
     - It requires a single argument, which must be a valid expression (`exp`).
     - It ends with a closing parenthesis `)`.

2. **Validation of Each `print-num` Statement:**
   - **First Statement (`(print-num 0)`):**
     - The argument `0` matches the `NUMBER` rule:
       ```lark
       %import common.SIGNED_INT -> NUMBER
       ```
     - Since `NUMBER` is a valid `exp`, this statement conforms to the grammar.
   - **Second Statement (`(print-num -123)`):**
     - The argument `-123` also matches the `NUMBER` rule, making it a valid `exp`.
   - **Third Statement (`(print-num 456)`):**
     - The argument `456` is another valid `NUMBER`, satisfying the `exp` rule.

---

### Interpreter Execution

1. **Definition of `print-num` in `interpret.py`:**
   - The `print-num` operation is implemented in the `Table` class:
     ```python
     def print_num(self, *args):
         self.type_checker(int, args)
         print(*args, end='\r\n')
     ```
   - Key steps in execution:
     - **Type Check (`type_checker`):**
       - Ensures that all arguments are integers (`int`).
       - The values `0`, `-123`, and `456` are all valid integers, passing the type check.
     - **Print Operation:**
       - Prints each argument to the standard output, followed by a newline (`\r\n`).

2. **Processing Each `print-num` Statement:**
   - **First Statement (`(print-num 0)`):**
     - The interpreter evaluates the argument `0`.
     - Passes the type check and prints `0`.
   - **Second Statement (`(print-num -123)`):**
     - The interpreter evaluates the argument `-123`.
     - Passes the type check and prints `-123`.
   - **Third Statement (`(print-num 456)`):**
     - The interpreter evaluates the argument `456`.
     - Passes the type check and prints `456`.

---

### Interpreter Output
The output of the program is:
```plaintext
0
-123
456
```

---

### Explanation of the Result

1. **Syntactic Validity:**
   - Each `print-num` statement adheres to the `print_stmt` rule in the grammar.
   - The arguments `0`, `-123`, and `456` are valid numerical expressions (`exp`).

2. **Semantic Validity:**
   - The interpreter verifies that each argument is an integer using the `type_checker`.
   - All arguments are valid and pass the type check.

3. **Sequential Execution:**
   - The `print-num` statements are executed in the order they appear.
   - Each statement produces an output corresponding to its argument.

---

### Key Insights

- The program is both syntactically and semantically correct.
- Each `print-num` statement is parsed and executed without errors.
- The arguments `0`, `-123`, and `456` are printed sequentially as expected.

This detailed explanation aligns with the provided `grammar.lark` and `interpret.py`.