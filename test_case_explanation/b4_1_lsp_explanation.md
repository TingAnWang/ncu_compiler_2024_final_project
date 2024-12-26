Let’s break down **Test Case b4_1.lsp** step by step, linking it to `grammar.lark` and `interpret.py`.

---

### Code:
```lisp
(define add-x
  (fun (x) (fun (y) (+ x y))))

(define z (add-x 10))

(print-num (z 1))
```

---

### Step-by-Step Explanation:

#### Step 1: **Defining the `add-x` Function**
```lisp
(define add-x
  (fun (x) (fun (y) (+ x y))))
```

1. **Parsing the `define` Statement:**
   - Matches the `def_stmt` rule in `grammar.lark`:
     ```lark
     def_stmt : "(" "define" variable exp ")"
     ```
     - `variable`: `add-x`.
     - `exp`: A `fun` expression:
       ```lisp
       (fun (x) (fun (y) (+ x y)))
       ```

2. **Parsing the `fun` Expression:**
   - Matches the `fun_exp` rule:
     ```lark
     fun_exp  : "(" "fun" fun_ids fun_body ")"
     ```
     - Parameters (`fun_ids`): `(x)`.
     - Body (`fun_body`): A nested `fun` expression:
       ```lisp
       (fun (y) (+ x y))
       ```

3. **Parsing the Nested `fun` Expression:**
   - The nested function takes a parameter `y` and computes `(+ x y)`.

4. **Parsing the `+` Operation:**
   - Matches the `plus` rule in `grammar.lark`:
     ```lark
     plus : "(" "+" exp exp+ ")"
     ```
     - Operands: `x` (from the outer function) and `y` (from the inner function).

5. **Storing in the Environment:**
   - `add-x` is stored as a `Function` object with:
     - **Parameter:** `x`.
     - **Body:** `(fun (y) (+ x y))`.

---

#### Step 2: **Defining `z`**
```lisp
(define z (add-x 10))
```

1. **Parsing the `define` Statement:**
   - Matches the `def_stmt` rule:
     - `variable`: `z`.
     - `exp`: A function call:
       ```lisp
       (add-x 10)
       ```

2. **Parsing the Function Call:**
   - Matches the `fun_call` rule:
     ```lark
     fun_call : "(" fun_name param* ")"
     ```
     - `fun_name`: `add-x`.
     - `param*`: Argument `10`.

3. **Function Invocation:**
   - The function `add-x` is called with:
     - `x = 10`.

4. **Evaluate the Body of `add-x`:**
   - The body of `add-x` is:
     ```lisp
     (fun (y) (+ x y))
     ```
   - A new `Function` object is created with:
     - **Parameter:** `y`.
     - **Body:** `(+ x y)`.
     - **Environment:** Includes `x = 10`.

5. **Storing in the Environment:**
   - `z` is stored as this new `Function` object.

---

#### Step 3: **Calling `(z 1)`**
```lisp
(print-num (z 1))
```

1. **Parsing the `print-num` Statement:**
   - Matches the `print_stmt` rule:
     ```lark
     print_stmt : "(" "print-num" exp ")" -> print_num
     ```
     - `exp`: `(z 1)`, a function call.

2. **Parsing the Function Call:**
   - Matches the `fun_call` rule:
     ```lark
     fun_call : "(" fun_name param* ")"
     ```
     - `fun_name`: `z`.
     - `param*`: Argument `1`.

3. **Function Invocation:**
   - The function `z` is called with:
     - `y = 1`.

4. **Evaluate the Body of `z`:**
   - The body of `z` is:
     ```lisp
     (+ x y)
     ```
   - **Evaluate `+ x y`:**
     - `x` is resolved from the environment where `z` was defined (`x = 10`).
     - `y = 1` is passed as an argument.
     - Compute:
       ```python
       def plus(self, *args):
           self.type_checker(int, args)  # Ensure arguments are integers
           return sum(args)  # Compute sum
       ```
       - Result: `10 + 1 = 11`.

---

#### Step 4: **Printing the Result**
The result `11` is passed to `print-num`:
```python
def print_num(self, *args):
    self.type_checker(int, args)  # Ensure the argument is an integer
    print(*args, end='\r\n')  # Print the number
```

- Output: `11`.

---

### Final Output:
```
11
```

This explanation aligns with the grammar and interpreter implementation to compute the result step by step.