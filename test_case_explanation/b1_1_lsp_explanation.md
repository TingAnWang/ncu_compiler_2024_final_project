Let's analyze **Test Case b1_1.lsp** step by step with the corresponding grammar rules and implementation in `interpret.py`.

---

### Code:
```lisp
(define fact
  (fun (n) (if (< n 3) n
               (* n (fact (- n 1))))))

(print-num (fact 2))
(print-num (fact 3))
(print-num (fact 4))
(print-num (fact 10))

(define fib (fun (x)
  (if (< x 2) x (+
                 (fib (- x 1))
                 (fib (- x 2))))))

(print-num (fib 1))
(print-num (fib 3))
(print-num (fib 5))
(print-num (fib 10))
(print-num (fib 20))
```

---

### Step-by-Step Explanation:

#### Part 1: **Define the `fact` Function**
```lisp
(define fact
  (fun (n) (if (< n 3) n
               (* n (fact (- n 1))))))
```

1. **Parsing the `define` Statement:**
   - This matches the `def_stmt` rule in `grammar.lark`:
     ```lark
     def_stmt : "(" "define" variable exp ")"
     ```
     - `variable`: `fact`.
     - `exp`: A `fun` expression:
       ```lisp
       (fun (n) (if (< n 3) n (* n (fact (- n 1)))))
       ```

2. **Parsing the `fun` Expression:**
   - This matches the `fun_exp` rule:
     ```lark
     fun_exp  : "(" "fun" fun_ids fun_body ")"
     ```
     - Parameters (`fun_ids`): `(n)`.
     - Body (`fun_body`): An `if` expression:
       ```lisp
       (if (< n 3) n (* n (fact (- n 1))))
       ```

3. **`if` Expression:**
   - This matches the `if_exp` rule:
     ```lark
     if_exp : "(" "if" test_exp than_exp else_exp ")"
     ```
     - **Test (`test_exp`)**: `(< n 3)`.
     - **Then (`than_exp`)**: `n`.
     - **Else (`else_exp`)**: `(* n (fact (- n 1)))`.

4. **Storing in the Environment:**
   - `fact` is stored as a `Function` object in the environment.

---

#### Part 2: **Evaluate Factorial Calculations**
The function is called multiple times with different inputs:
```lisp
(print-num (fact 2))
(print-num (fact 3))
(print-num (fact 4))
(print-num (fact 10))
```

1. **Function Call:**
   - This matches the `fun_call` rule:
     ```lark
     fun_call : "(" fun_name param* ")"
     ```
     - `fun_name`: `fact`.
     - `param`: The argument passed (`2`, `3`, `4`, or `10`).

2. **Evaluate the Body of `fact`:**
   - For each call, the body:
     ```lisp
     (if (< n 3) n (* n (fact (- n 1))))
     ```
     is evaluated recursively in `interpret.py`:
     ```python
     elif node.data == 'if_exp':
         (test, then, els) = node.children
         test_res = interpret_AST(test, environment)
         expr = [els, then][test_res]  # Select `then` or `else` branch based on `test_res`
         return interpret_AST(expr, environment)
     ```

3. **Base Case (`< n 3`):**
   - If `n < 3`, return `n`.

4. **Recursive Case (`>= 3`):**
   - Compute:
     ```lisp
     (* n (fact (- n 1)))
     ```
   - Multiply `n` by the factorial of `n - 1`.

**Results for `fact`:**
- `fact(2)`: `2` (base case).
- `fact(3)`: `3 * fact(2) = 3 * 2 = 6`.
- `fact(4)`: `4 * fact(3) = 4 * 6 = 24`.
- `fact(10)`: `10 * fact(9) = 3,628,800`.

---

#### Part 3: **Define the `fib` Function**
```lisp
(define fib (fun (x)
  (if (< x 2) x (+
                 (fib (- x 1))
                 (fib (- x 2))))))
```

1. **Parsing the `define` Statement:**
   - Same process as `fact`, storing `fib` as a `Function` object.

2. **Body of `fib`:**
   ```lisp
   (if (< x 2) x (+ (fib (- x 1)) (fib (- x 2))))
   ```

3. **Recursive Case:**
   - Fibonacci formula:
     ```lisp
     (+ (fib (- x 1)) (fib (- x 2)))
     ```

---

#### Part 4: **Evaluate Fibonacci Calculations**
The function is called with multiple inputs:
```lisp
(print-num (fib 1))
(print-num (fib 3))
(print-num (fib 5))
(print-num (fib 10))
(print-num (fib 20))
```

1. **Base Case (`< x 2`):**
   - If `x < 2`, return `x`.

2. **Recursive Case (`>= 2`):**
   - Compute the sum of `fib(x-1)` and `fib(x-2)`.

**Results for `fib`:**
- `fib(1)`: `1` (base case).
- `fib(3)`: `fib(2) + fib(1) = 1 + 1 = 2`.
- `fib(5)`: `fib(4) + fib(3) = 3 + 2 = 5`.
- `fib(10)`: `55`.
- `fib(20)`: `6,765`.

---

#### Part 5: **Printing Results**
Each result is passed to `print-num`:
```lisp
(print-num ...)
```

In `interpret.py`, this outputs:
```python
def print_num(self, *args):
    print(*args, end='\r\n')
```

---

### Final Output:
```
2
6
24
3628800
1
2
5
55
6765
```

This explanation aligns with `grammar.lark` and `interpret.py`, detailing the logic for factorial and Fibonacci functions.