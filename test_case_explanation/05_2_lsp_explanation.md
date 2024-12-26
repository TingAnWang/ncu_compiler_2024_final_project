Let’s dive into **Test Case 05_2.lsp** and explain it step by step.

---

### Test Case Content:
```lisp
(print-num (if (< 1 2) (+ 1 2 3) (* 1 2 3 4 5)))

(print-num (if (= 9 (* 2 5))
               0
               (if #t 1 2)))
```

This test case includes two expressions:
1. A conditional `if` with a nested numerical operation in its branches.
2. A conditional `if` with a nested `if` as its `else_exp`.

---

### Grammar Breakdown:
#### 1. **print-num Statement**:
As described earlier, the `print-num` statement expects an `exp`:
```lark
?print_stmt : "(" "print-num" exp ")"
```

#### 2. **Expression (`exp`)**:
In this case, the `exp` is an `if_exp`:
```lark
?if_exp : "(" "if" test_exp than_exp else_exp ")"
```

#### 3. **Nested Expressions**:
- **Numerical Comparisons (`<`, `=`)**:
  ```lark
  smaller : "(" "<" exp exp ")"
  equal   : "(" "=" exp exp+ ")"
  ```
  - `(< 1 2)` evaluates whether `1` is less than `2`.
  - `(= 9 (* 2 5))` evaluates whether `9` equals the result of `(* 2 5)`.

- **Mathematical Operations**:
  ```lark
  plus     : "(" "+" exp exp+ ")"
  multiply : "(" "*" exp exp+ ")"
  ```
  - `(+ 1 2 3)` sums the numbers: `1 + 2 + 3`.
  - `(* 1 2 3 4 5)` multiplies the numbers: `1 × 2 × 3 × 4 × 5`.

---

### Parsing:
#### First Statement:
```lisp
(print-num (if (< 1 2) (+ 1 2 3) (* 1 2 3 4 5)))
```
- **Outer Structure**:
  - `print-num`: A statement to output the result.
  - Argument: An `if_exp`.

- **Inner Structure** (Parsing `if_exp`):
  - `test_exp`: `(< 1 2)` evaluates to `True`.
  - `than_exp`: `(+ 1 2 3)` evaluates to `6`.
  - `else_exp`: `(* 1 2 3 4 5)` evaluates to `120`.
  - Since `test_exp` is `True`, `than_exp` (`6`) is selected.

#### Second Statement:
```lisp
(print-num (if (= 9 (* 2 5))
               0
               (if #t 1 2)))
```
- **Outer Structure**:
  - `print-num`: A statement to output the result.
  - Argument: An `if_exp`.

- **Inner Structure** (Parsing `if_exp`):
  - `test_exp`: `(= 9 (* 2 5))` evaluates to `False` because `9 != 10`.
  - `than_exp`: `0` (ignored as `test_exp` is false).
  - `else_exp`: Another `if_exp`: `(if #t 1 2)`.

- **Nested `if_exp` Evaluation**:
  - `test_exp`: `#t` evaluates to `True`.
  - `than_exp`: `1`.
  - `else_exp`: `2`.
  - Since `test_exp` is `True`, `1` is selected as the result of the nested `if_exp`.

---

### Interpreter Execution:
#### **First Statement**:
```lisp
(print-num (if (< 1 2) (+ 1 2 3) (* 1 2 3 4 5)))
```
1. The interpreter evaluates the `if_exp`:
   - `(< 1 2)`:
     - Compares `1` and `2`.
     - Result: `True`.
   - `(+ 1 2 3)`:
     - Adds `1`, `2`, and `3`.
     - Result: `6`.
   - Since `test_exp` is `True`, the result is `6`.

2. The result (`6`) is passed to `print_num`.
3. `print_num` outputs:
   ```
   6
   ```

#### **Second Statement**:
```lisp
(print-num (if (= 9 (* 2 5))
               0
               (if #t 1 2)))
```
1. The interpreter evaluates the outer `if_exp`:
   - `(= 9 (* 2 5))`:
     - Computes `(* 2 5)`:
       - Multiplies `2 × 5`.
       - Result: `10`.
     - Compares `9` and `10`.
     - Result: `False`.
   - Since `test_exp` is `False`, the interpreter evaluates the `else_exp`: `(if #t 1 2)`.

2. The nested `if_exp` is evaluated:
   - `#t`: Evaluates to `True`.
   - Selects `than_exp = 1`.

3. The result of the nested `if_exp` (`1`) is returned as the result of the outer `if_exp`.

4. The result (`1`) is passed to `print_num`.
5. `print_num` outputs:
   ```
   1
   ```

---

### Step-by-Step Breakdown in Code:
#### **Key Steps for Each Statement**:
1. **First Statement**:
   - `(< 1 2)`:
     ```python
     def smaller(self, *args):
         self.type_checker(int, args)
         return args[0] < args[1]
     ```
     Result: `True`.

   - `(+ 1 2 3)`:
     ```python
     def plus(self, *args):
         self.type_checker(int, args)
         return sum(args)
     ```
     Result: `6`.

2. **Second Statement**:
   - `(= 9 (* 2 5))`:
     ```python
     def equal(self, *args):
         self.type_checker(int, args)
         return args.count(args[0]) == len(args)
     ```
     Result: `False`.

   - Nested `(if #t 1 2)`:
     - `#t` maps to `True`.
     - `1` is returned.

#### **If Expression Evaluation**:
Handled in the `if_exp` block:
```python
elif node.data == 'if_exp':
    (test, then, els) = node.children
    test_res = interpret_AST(test, environment)
    if not isinstance(test_res, bool):
        raise TypeError("Expect 'boolean' but got 'number'.")
    expr = [els, then][test_res]
    return interpret_AST(expr, environment)
```

- For the first statement:
  - `test_res = True` → Executes `then_exp = (+ 1 2 3)`.
- For the second statement:
  - `test_res = False` → Executes `else_exp = (if #t 1 2)`.

---

### Final Output:
The results are:
```
6
1
```

This matches the expected output, and the step-by-step reasoning demonstrates how the grammar rules and interpreter logic are applied.