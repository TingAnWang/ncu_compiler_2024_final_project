Here is the detailed explanation for **Test Case 07_2.lsp**:

---

### Test Case Content:
```lisp
(define x 0)

(print-num
  ((fun (x y z) (+ x (* y z))) 10 20 30))

(print-num x)
```

This test case includes:
1. A `define` statement to declare a variable `x` and assign it the value `0`.
2. A `print-num` statement that calls an anonymous function (`fun`) with three parameters.
3. A `print-num` statement to print the value of the global variable `x`.

---

### Grammar Breakdown:
#### 1. **Define Statement**:
The grammar for `define` is:
```lark
def_stmt : "(" "define" variable exp ")"
```
- `variable`: Matches `ID` (e.g., `x`).
- `exp`: Any valid expression (e.g., `0`).

#### 2. **Function Definition (`fun_exp`)**:
The grammar rule for defining a function is:
```lark
fun_exp : "(" "fun" fun_ids fun_body ")"
```
- `fun_ids`: A list of parameter names:
  ```lark
  fun_ids : "(" ID* ")"
  ```
  Matches a list of identifiers (e.g., `(x y z)`).

- `fun_body`: The body of the function, which consists of optional `define` statements followed by an expression:
  ```lark
  fun_body : def_stmt* exp
  ```

#### 3. **Function Call (`fun_call`)**:
The grammar rule for calling a function is:
```lark
fun_call : "(" fun_exp param* ")" 
         | "(" fun_name param* ")"
```
- A function call can directly use a `fun_exp` or a previously defined function name (`fun_name`).
- `param*`: A list of arguments passed to the function.

#### 4. **Print Statement**:
The grammar for `print-num` is:
```lark
?print_stmt : "(" "print-num" exp ")"
```
- `exp`: A valid expression, including a `fun_call`.

---

### Parsing:
#### 1. `(define x 0)`:
- `define`: A statement to create a variable.
- `x`: The variable name.
- `0`: The value assigned to `x`.

#### 2. `(print-num ((fun (x y z) (+ x (* y z))) 10 20 30))`:
- `print-num`: A statement to print the result of the following expression.
- `((fun (x y z) (+ x (* y z))) 10 20 30)`:
  - A function call where:
    - The function is defined inline as `(fun (x y z) (+ x (* y z)))`.
    - The arguments passed to the function are `10`, `20`, and `30`.

#### 3. `(print-num x)`:
- `print-num`: A statement to print the value of `x`.
- `x`: A variable whose value is `0`.

---

### Interpreter Execution:
#### 1. `(define x 0)`:
- The `def_stmt` is executed:
  ```python
  environment['x'] = 0
  ```
- The global variable `x` is stored in the environment with value `0`.

#### 2. `(print-num ((fun (x y z) (+ x (* y z))) 10 20 30))`:
- **Function Definition**:
  - `(fun (x y z) (+ x (* y z)))` defines a function with:
    - `fun_ids = [x, y, z]`: Three parameters named `x`, `y`, and `z`.
    - `fun_body = (+ x (* y z))`: The body computes `x + (y * z)`.

- **Function Call**:
  - The function is called with arguments `10`, `20`, and `30`:
    - A new local environment is created:
      ```python
      local_environment['x'] = 10
      local_environment['y'] = 20
      local_environment['z'] = 30
      ```
    - The body `(+ x (* y z))` is evaluated:
      - `(* y z)`:
        ```python
        def multiply(self, *args):
            self.type_checker(int, args)
            return reduce(lambda x, y: x * y, args)
        ```
        - `args = [20, 30]`.
        - Computation: `20 * 30 = 600`.
      - `(+ x 600)`:
        ```python
        def plus(self, *args):
            self.type_checker(int, args)
            return sum(args)
        ```
        - `args = [10, 600]`.
        - Computation: `10 + 600 = 610`.

- **Result**:
  - The result of the function call is `610`.
  - This value is passed to `print_num`, which outputs:
    ```
    610
    ```

#### 3. `(print-num x)`:
- The `print-num` statement retrieves the value of the global variable `x`:
  ```python
  print(environment['x'])  # Outputs: 0
  ```
- Since the function’s local environment does not affect the global environment, the value of `x` remains `0`.

---

### Step-by-Step Breakdown in Code:
#### **First Statement**:
1. Define the global variable `x`:
   ```python
   environment['x'] = 0
   ```

#### **Second Statement**:
1. Define the function:
   ```python
   Function(args=['x', 'y', 'z'], body='(+ x (* y z))', environment=...)
   ```
2. Call the function with `x = 10`, `y = 20`, `z = 30`:
   - Compute `(* y z)`:
     ```python
     result = 20 * 30  # Result: 600
     ```
   - Compute `(+ x 600)`:
     ```python
     result = 10 + 600  # Result: 610
     ```
3. Pass `610` to `print_num`:
   ```python
   print(610)  # Outputs: 610
   ```

#### **Third Statement**:
1. Retrieve the global value of `x`:
   ```python
   print(environment['x'])  # Outputs: 0
   ```

---

### Final Output:
The outputs of the two `print-num` statements are:
```
610
0
```

This matches the expected results because:
- The local variable `x` in the function does not affect the global variable `x`.
- The `print-num` statements correctly output the function result and the global value of `x`.