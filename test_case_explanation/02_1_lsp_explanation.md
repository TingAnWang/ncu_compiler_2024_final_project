### Detailed Explanation of Test Case `02_1.lsp`

#### Content of `02_1.lsp`
```lisp
(print-num 1)
(print-num 2)
(print-num 3)
(print-num 4)
```

---

### Grammar Parsing

1. **Grammar Rule for `print-num`:**
   - The `print-num` operation falls under the `print_stmt` rule in `grammar.lark`:
     ```lark
     print_stmt: "(" "print-num" exp ")" -> print_num
     ```
   - This rule requires:
     - An opening parenthesis `(`.
     - The keyword `print-num` to indicate a print operation for numerical values.
     - A valid expression (`exp`) as an argument.
     - A closing parenthesis `)`.

2. **Validation of Each `print-num` Statement:**
   - **First Statement (`(print-num 1)`):**
     - The argument `1` is a valid expression (`exp`), defined in the grammar as:
       ```lark
       exp: BOOL_VAL | NUMBER | variable | num_op | logical_op | fun_exp | fun_call | if_exp
       ```
     - Since `1` matches the `NUMBER` rule, the first statement is syntactically valid.
   - **Subsequent Statements (`(print-num 2)`, `(print-num 3)`, `(print-num 4)`):**
     - Arguments `2`, `3`, and `4` are also valid `NUMBER` literals, satisfying the `exp` rule.

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
       - Verifies that all arguments are integers (`int`).
       - Since `1`, `2`, `3`, and `4` are valid integers, they pass the type check.
     - **Print Operation:**
       - Each argument is printed to the standard output, followed by a newline (`\r\n`).

2. **Processing Each `print-num` Statement:**
   - **First Statement (`(print-num 1)`):**
     - The interpreter evaluates the argument `1`.
     - Passes the type check and prints `1`.
   - **Second Statement (`(print-num 2)`):**
     - The interpreter evaluates the argument `2`.
     - Passes the type check and prints `2`.
   - **Third Statement (`(print-num 3)`):**
     - The interpreter evaluates the argument `3`.
     - Passes the type check and prints `3`.
   - **Fourth Statement (`(print-num 4)`):**
     - The interpreter evaluates the argument `4`.
     - Passes the type check and prints `4`.

---

### Interpreter Output
The output of the program is:
```plaintext
1
2
3
4
```

---

### Explanation of the Result

1. **Syntactic Validity:**
   - Each `print-num` statement adheres to the grammar rule for `print_stmt`.
   - The arguments `1`, `2`, `3`, and `4` are valid numerical expressions (`exp`).

2. **Semantic Validity:**
   - The interpreter verifies that each argument is an integer.
   - All arguments pass the type check and are printed successfully.

3. **Sequential Execution:**
   - The statements are executed in the order they appear.
   - Each statement produces an output corresponding to its argument.

---

### Key Insights

- The program is both syntactically and semantically correct.
- Each `print-num` operation is parsed, validated, and executed without errors.
- The numerical arguments are printed in sequence, producing the expected output.

This detailed explanation aligns with the provided `grammar.lark` and `interpret.py`.