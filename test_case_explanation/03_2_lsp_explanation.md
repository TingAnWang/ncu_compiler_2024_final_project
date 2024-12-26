Let's analyze **03_2.lsp** step by step, explicitly aligning the explanation with the **grammar.lark** rules and the logic from **interpreter.py**.

---

### Code:
```lisp
(print-num (mod 10 (+ 1 2)))

(print-num (* (/ 1 2) 4))

(print-num (- (+ 1 2 3 (- 4 5) 6 (/ 7 8) (mod 9 10))
              11))
```

---

### Parsing and Execution

#### **First Expression:** `(print-num (mod 10 (+ 1 2)))`

1. **Outer Expression:** `(print-num ...)`
   - Matches the **grammar rule**:
     ```lark
     print_stmt : "(" "print-num" exp ")" -> print_num
     ```
   - **Parsing:** `print-num` expects an `exp` as its argument.

2. **Inner Expression:** `(mod 10 (+ 1 2))`
   - Matches the **grammar rule**:
     ```lark
     modulus : "(" "mod" exp exp ")"
     ```
   - **Parsing:** `mod` requires exactly two sub-expressions (`10` and `(+ 1 2)`).
   - **Execution:** The `modulus` method in `Table` handles the operation:
     ```python
     def modulus(self, *args):
         self.type_checker(int, args)
         return args[0] % args[1]
     ```
     - First argument: `10`.
     - Second argument: Result of `(+ 1 2)`.

3. **Innermost Expression:** `(+ 1 2)`
   - Matches the **grammar rule**:
     ```lark
     plus : "(" "+" exp exp+ ")"
     ```
   - **Parsing:** `+` expects two or more sub-expressions.
   - **Execution:** The `plus` method in `Table` performs the addition:
     ```python
     def plus(self, *args):
         self.type_checker(int, args)
         return sum(args)
     ```
     - Arguments: `[1, 2]`.
     - Result: `1 + 2 = 3`.

4. **Final Evaluation:** `mod(10, 3)` → `1`.

5. **Print Statement:**
   - **Execution:** `print_num` in `Table` is invoked:
     ```python
     def print_num(self, *args):
         self.type_checker(int, args)
         print(*args, end='\r\n')
     ```
   - Result: Prints `1`.

---

#### **Second Expression:** `(print-num (* (/ 1 2) 4))`

1. **Outer Expression:** `(print-num ...)`
   - Same as above.

2. **Inner Expression:** `(* (/ 1 2) 4)`
   - Matches the **grammar rule**:
     ```lark
     multiply : "(" "*" exp exp+ ")"
     ```
   - **Parsing:** `*` expects two or more sub-expressions.
   - **Execution:** The `multiply` method in `Table` computes:
     ```python
     def multiply(self, *args):
         self.type_checker(int, args)
         return reduce(lambda x, y: x * y, args)
     ```
     - Arguments: Result of `(/ 1 2)` and `4`.

3. **Innermost Expression:** `(/ 1 2)`
   - Matches the **grammar rule**:
     ```lark
     divide : "(" "/" exp exp ")"
     ```
   - **Parsing:** `/` expects exactly two sub-expressions.
   - **Execution:** The `divide` method in `Table` performs integer division:
     ```python
     def divide(self, *args):
         self.type_checker(int, args)
         return args[0] // args[1]
     ```
     - Arguments: `[1, 2]`.
     - Result: `1 // 2 = 0`.

4. **Final Evaluation:** `*(0, 4)` → `0`.

5. **Print Statement:** Prints `0`.

---

#### **Third Expression:**
```lisp
(print-num (- (+ 1 2 3 (- 4 5) 6 (/ 7 8) (mod 9 10))
              11))
```

1. **Outer Expression:** `(print-num ...)`
   - Same as above.

2. **Inner Expression:** `(- ...)`
   - Matches the **grammar rule**:
     ```lark
     minus : "(" "-" exp exp ")"
     ```
   - **Parsing:** `-` expects exactly two sub-expressions.
   - **Execution:** The `minus` method in `Table` computes:
     ```python
     def minus(self, *args):
         self.type_checker(int, args)
         return args[0] - args[1]
     ```
     - First argument: Result of `(+ 1 2 3 (- 4 5) 6 (/ 7 8) (mod 9 10))`.
     - Second argument: `11`.

3. **Innermost Expression:** `(+ 1 2 3 (- 4 5) 6 (/ 7 8) (mod 9 10))`
   - Matches the **grammar rule**:
     ```lark
     plus : "(" "+" exp exp+ ")"
     ```
   - **Parsing:** `+` expects two or more sub-expressions.
   - **Execution:** The `plus` method computes:
     ```python
     def plus(self, *args):
         self.type_checker(int, args)
         return sum(args)
     ```
     - Sub-expressions:
       - `1 + 2 + 3 = 6`.
       - `(- 4 5)` evaluates to `-1`:
         - Matches the `minus` rule.
         - Result: `4 - 5 = -1`.
       - `(/ 7 8)` evaluates to `0`:
         - Matches the `divide` rule.
         - Result: `7 // 8 = 0`.
       - `(mod 9 10)` evaluates to `9`:
         - Matches the `modulus` rule.
         - Result: `9 % 10 = 9`.
     - Total Sum: `6 + (-1) + 6 + 0 + 9 = 20`.

4. **Final Evaluation:** `-(20, 11)` → `9`.

5. **Print Statement:** Prints `9`.

---

### Final Output:
```
1
0
9
```

---

### How Grammar and Interpreter Work Together:
1. **Grammar Rules (grammar.lark):**
   - Define the syntax and structure of valid Mini-LISP programs.
   - For example, `print-num`, arithmetic operations (`+`, `-`, `/`, etc.), and nested expressions are all explicitly described.

2. **Interpreter Logic (interpreter.py):**
   - The `interpret_AST` function recursively evaluates parsed expressions based on the rules defined in **grammar.lark**.
   - Operations like `+`, `-`, `*`, `/`, and `mod` are implemented as methods in the `Table` class.
   - Printing (`print-num`) is also handled via methods in `Table`.

By aligning **grammar.lark** (parsing rules) with **interpreter.py** (execution logic), we see how the program evaluates nested arithmetic expressions and produces the correct output.