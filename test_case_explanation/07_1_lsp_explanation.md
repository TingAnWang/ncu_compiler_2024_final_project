Let’s analyze **Test Case 07_1.lsp**, providing a detailed explanation of its behavior.

---

### Test Case Content:
```lisp
(print-num
  ((fun (x) (+ x 1)) 3))

(print-num
  ((fun (a b) (+ a b)) 4 5))
```

This test case includes:
1. A `print-num` statement that calls an anonymous function (`fun`) with one parameter.
2. A `print-num` statement that calls an anonymous function (`fun`) with two parameters.

---

### Grammar Breakdown:
#### 1. **Function Definition (`fun_exp`)**:
The grammar rule for defining a function is:
```lark
fun_exp : "(" "fun" fun_ids fun_body ")"
```
- `fun_ids`: A list of parameter names:
  ```lark
  fun_ids : "(" ID* ")"
  ```
  Matches a list of identifiers (e.g., `(x)` or `(a b)`).
  
- `fun_body`: The body of the function, which consists of optional `define` statements followed by an expression:
  ```lark
  fun_body : def_stmt* exp
  ```

#### 2. **Function Call (`fun_call`)**:
The grammar rule for calling a function is:
```lark
fun_call : "(" fun_exp param* ")" 
         | "(" fun_name param* ")"
```
- A function call can directly use a `fun_exp` or a previously defined function name (`fun_name`).
- `param*`: A list of arguments passed to the function.

#### 3. **Print Statement**:
The grammar for `print-num` is:
```lark
?print_stmt : "(" "print-num" exp ")"
```
- `exp`: A valid expression, including a `fun_call`.

---

### Parsing:
#### First Statement:
```lisp
(print-num
  ((fun (x) (+ x 1)) 3))
```
- `print-num`: A statement to print the result of the following expression.
- `((fun (x) (+ x 1)) 3)`:
  - A function call where:
    - The function is defined inline as `(fun (x) (+ x 1))`.
    - The argument passed to the function is `3`.

#### Second Statement:
```lisp
(print-num
  ((fun (a b) (+ a b)) 4 5))
```
- `print-num`: A statement to print the result of the following expression.
- `((fun (a b) (+ a b)) 4 5)`:
  - A function call where:
    - The function is defined inline as `(fun (a b) (+ a b))`.
    - The arguments passed to the function are `4` and `5`.

---

### Interpreter Execution:
#### 1. **First Statement**:
```lisp
(print-num
  ((fun (x) (+ x 1)) 3))
```
- **Function Definition**:
  - `(fun (x) (+ x 1))` defines a function with:
    - `fun_ids = [x]`: One parameter named `x`.
    - `fun_body = (+ x 1)`: The body adds `x` and `1`.
    
- **Function Call**:
  - The function is called with the argument `3`:
    - The environment for the function execution is created with `x = 3`.
    - The body `(+ x 1)` is evaluated:
      ```python
      def plus(self, *args):
          self.type_checker(int, args)
          return sum(args)
      ```
      - `args = [3, 1]`.
      - Computation: `3 + 1 = 4`.

- **Result**:
  - The result of the function call is `4`.
  - This value is passed to `print_num`, which outputs:
    ```
    4
    ```

#### 2. **Second Statement**:
```lisp
(print-num
  ((fun (a b) (+ a b)) 4 5))
```
- **Function Definition**:
  - `(fun (a b) (+ a b))` defines a function with:
    - `fun_ids = [a, b]`: Two parameters named `a` and `b`.
    - `fun_body = (+ a b)`: The body adds `a` and `b`.
    
- **Function Call**:
  - The function is called with the arguments `4` and `5`:
    - The environment for the function execution is created with `a = 4` and `b = 5`.
    - The body `(+ a b)` is evaluated:
      ```python
      def plus(self, *args):
          self.type_checker(int, args)
          return sum(args)
      ```
      - `args = [4, 5]`.
      - Computation: `4 + 5 = 9`.

- **Result**:
  - The result of the function call is `9`.
  - This value is passed to `print_num`, which outputs:
    ```
    9
    ```

---

### Step-by-Step Breakdown in Code:
#### **First Statement**:
1. Define the function:
   ```python
   Function(args=['x'], body='(+ x 1)', environment=...)
   ```
2. Call the function with `x = 3`:
   ```python
   environment['x'] = 3
   result = sum([3, 1])  # Result: 4
   ```
3. Pass `4` to `print_num`:
   ```python
   print(4)  # Outputs: 4
   ```

#### **Second Statement**:
1. Define the function:
   ```python
   Function(args=['a', 'b'], body='(+ a b)', environment=...)
   ```
2. Call the function with `a = 4` and `b = 5`:
   ```python
   environment['a'] = 4
   environment['b'] = 5
   result = sum([4, 5])  # Result: 9
   ```
3. Pass `9` to `print_num`:
   ```python
   print(9)  # Outputs: 9
   ```

---

### Final Output:
The outputs of the two `print-num` statements are:
```
4
9
```

This matches the expected results because:
- Each function is correctly defined and executed with its arguments.
- The `print-num` statements correctly output the function results.