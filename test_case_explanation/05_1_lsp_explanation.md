Let’s provide a more detailed explanation, covering all aspects of the grammar and interpreter for **Test Case 05_1.lsp**.

---

### Test Case Content:
```lisp
(print-num (if #t 1 2))
(print-num (if #f 1 2))
```

This test case includes two expressions:
1. A conditional `if` with a true test case (`#t`).
2. A conditional `if` with a false test case (`#f`).

Both are wrapped in `print-num`, which outputs the result of evaluating the `if` expressions.

---

### Grammar Breakdown:
#### 1. **print-num Statement**:
The grammar rule for `print-num` is:
```lark
?print_stmt : "(" "print-num" exp ")"
```
This rule matches:
- The `print-num` keyword.
- An argument that must conform to the `exp` rule.

#### 2. **Expression (`exp`)**:
The `exp` rule allows multiple types of expressions, including `if_exp`:
```lark
?exp : BOOL_VAL
     | NUMBER
     | variable
     | num_op
     | logical_op
     | fun_exp
     | fun_call
     | if_exp
```

Here, `if_exp` is explicitly permitted as a valid expression inside `print-num`.

#### 3. **If Expression (`if_exp`)**:
The conditional logic is defined as:
```lark
?if_exp : "(" "if" test_exp than_exp else_exp ")"
```
- `test_exp`: A boolean expression (e.g., `#t` or `#f`).
- `than_exp`: The result if `test_exp` evaluates to true.
- `else_exp`: The result if `test_exp` evaluates to false.

### Parsing:
#### For `(print-num (if #t 1 2))`:
1. The parser identifies `print-num` as a statement.
2. The argument `(if #t 1 2)` is parsed as an `if_exp`:
   - `test_exp = #t`: Matches `BOOL_VAL` and evaluates to `True`.
   - `than_exp = 1`: A number to return if the condition is true.
   - `else_exp = 2`: A number to return if the condition is false.

#### For `(print-num (if #f 1 2))`:
1. The parser identifies `print-num` as a statement.
2. The argument `(if #f 1 2)` is parsed as an `if_exp`:
   - `test_exp = #f`: Matches `BOOL_VAL` and evaluates to `False`.
   - `than_exp = 1`: Ignored because the condition is false.
   - `else_exp = 2`: Returned because the condition is false.

---

### Interpreter Execution:

1. **First Statement**:
   ```lisp
   (print-num (if #t 1 2))
   ```
   - The `if_exp` is evaluated:
     - `test_exp = #t`: The interpreter maps `#t` to `True`.
     - Since `test_exp` is `True`, the interpreter evaluates `than_exp = 1`.
   - The result (`1`) is passed to `print_num`.
   - `print_num` validates the argument type as an integer and outputs:
     ```
     1
     ```

2. **Second Statement**:
   ```lisp
   (print-num (if #f 1 2))
   ```
   - The `if_exp` is evaluated:
     - `test_exp = #f`: The interpreter maps `#f` to `False`.
     - Since `test_exp` is `False`, the interpreter evaluates `else_exp = 2`.
   - The result (`2`) is passed to `print_num`.
   - `print_num` validates the argument type as an integer and outputs:
     ```
     2
     ```

---

### Step-by-Step Breakdown in Code:
#### **Key Functionality in the Interpreter**:
1. **Boolean Evaluation**:
   The interpreter converts `#t` to `True` and `#f` to `False`:
   ```python
   if node == '#t':
       return True
   if node == '#f':
       return False
   ```

2. **If Expression Handling**:
   The `if_exp` logic is implemented here:
   ```python
   elif node.data == 'if_exp':
       (test, then, els) = node.children
       test_res = interpret_AST(test, environment)
       if not isinstance(test_res, bool):
           raise TypeError("Expect 'boolean' but got 'number'.")
       expr = [els, then][test_res]
       return interpret_AST(expr, environment)
   ```
   - The condition (`test_exp`) is evaluated.
   - Depending on the condition’s result, either `than_exp` or `else_exp` is evaluated and returned.

3. **Print Functionality**:
   The `print_num` function outputs the result:
   ```python
   def print_num(self, *args):
       self.type_checker(int, args)
       print(*args, end='\r\n')
   ```
   - It checks the argument type (must be an integer).
   - Outputs the value.

---

### Final Output:
Based on the above explanation, the outputs are:
```
1
2
```

This matches the expected results due to the correct evaluation of `if_exp` and the proper functioning of `print_num`.