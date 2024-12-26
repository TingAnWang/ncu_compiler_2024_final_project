Here is a detailed explanation of the **grammar.lark** file, broken down rule by rule, explaining the purpose and how it aligns with the Mini-LISP language structure:

---

### **Top-Level Rule**
```lark
program : stmt+
```
- **`program`**: Represents a complete Mini-LISP program.
  - **`stmt+`**: A program consists of one or more statements (`stmt`).
  - The `+` operator means at least one `stmt` must be present.
- **Purpose**: Defines the entry point for parsing a Mini-LISP program. A `program` is essentially a sequence of statements.

---

### **Statements**
```lark
?stmt : exp
    | def_stmt
    | print_stmt
```
- **`stmt`**: Represents a statement, which can be one of the following:
  1. **`exp`**: An expression (e.g., arithmetic, logical operations, function calls).
  2. **`def_stmt`**: A variable definition statement (e.g., `(define x 10)`).
  3. **`print_stmt`**: A print statement (e.g., `(print-num 10)` or `(print-bool #t)`).
- The `?` indicates this rule is a sub-rule, making it easier to reference in other rules.

---

### **Print Statements**
```lark
?print_stmt : "(" "print-num" exp ")"   -> print_num
    | "(" "print-bool" exp ")"          -> print_bool
```
- **`print-num`**: Prints the result of evaluating a numeric expression.
- **`print-bool`**: Prints the result of evaluating a boolean expression.
- **Purpose**: Enables output functionality, differentiating between numeric and boolean printing.

---

### **Expressions**
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
- **`exp`**: Represents any valid Mini-LISP expression. It can be:
  1. **`BOOL_VAL`**: A boolean literal (`#t` or `#f`).
  2. **`NUMBER`**: A numeric literal.
  3. **`variable`**: A variable reference.
  4. **`num_op`**: Numeric operations like addition, subtraction, etc.
  5. **`logical_op`**: Logical operations like `and`, `or`, `not`.
  6. **`fun_exp`**: A function definition.
  7. **`fun_call`**: A function call.
  8. **`if_exp`**: An if-then-else conditional expression.
- **Purpose**: Defines all possible forms of expressions in Mini-LISP.

---

### **Numeric Operations**
```lark
?num_op : plus | minus | multiply | divide | modulus | greater | smaller | equal

plus     : "(" "+" exp exp+ ")"
minus    : "(" "-" exp exp ")"
multiply : "(" "*" exp exp+ ")"
divide   : "(" "/" exp exp ")"
modulus  : "(" "mod" exp exp ")"
greater  : "(" ">" exp exp ")"
smaller  : "(" "<" exp exp ")"
equal    : "(" "=" exp exp+ ")"
```
- **`num_op`**: Represents numeric operations, which include:
  - **`plus`**: Addition of two or more numbers.
  - **`minus`**: Subtraction of two numbers.
  - **`multiply`**: Multiplication of two or more numbers.
  - **`divide`**: Integer division of two numbers.
  - **`modulus`**: Modulo operation (remainder of division).
  - **`greater`**: Greater-than comparison.
  - **`smaller`**: Less-than comparison.
  - **`equal`**: Equality check for two or more numbers.
- **Purpose**: Handles basic arithmetic and comparison operations.

---

### **Logical Operations**
```lark
?logical_op : and_op | or_op | not_op

and_op     : "(" "and" exp exp+ ")"
or_op      : "(" "or" exp exp+ ")"
not_op     : "(" "not" exp ")"
```
- **`logical_op`**: Represents logical operations:
  - **`and_op`**: Logical AND of two or more boolean values.
  - **`or_op`**: Logical OR of two or more boolean values.
  - **`not_op`**: Logical NOT of a single boolean value.
- **Purpose**: Supports logical reasoning within Mini-LISP programs.

---

### **Variable Definitions**
```lark
def_stmt : "(" "define" variable exp ")"
?variable : ID
```
- **`def_stmt`**: Defines a variable with a name (`variable`) and an associated value (`exp`).
- **`variable`**: A valid variable name (matches the `ID` token).
- **Purpose**: Enables storage and reuse of values or expressions.

---

### **Function Definitions and Calls**
```lark
fun_exp  : "(" "fun" fun_ids fun_body ")"
fun_ids  : "(" ID* ")"
fun_body : def_stmt* exp

fun_call : "(" fun_exp param* ")"
          | "(" fun_name param* ")"

?param    : exp
?fun_name : ID
```
- **Function Definition (`fun_exp`)**:
  - Defines a function with parameters (`fun_ids`) and a body (`fun_body`).
  - **`fun_ids`**: A list of parameter names.
  - **`fun_body`**: Consists of zero or more variable definitions followed by a single expression.
- **Function Call (`fun_call`)**:
  - Calls a function, either inline or by name.
  - Accepts zero or more parameters (`param`).
- **Purpose**: Supports defining and invoking reusable code blocks.

---

### **Conditional Expressions**
```lark
?if_exp : "(" "if" test_exp than_exp else_exp ")"
?test_exp : exp
?than_exp : exp
?else_exp : exp
```
- **`if_exp`**: Represents an if-then-else conditional:
  - **`test_exp`**: The condition to evaluate.
  - **`than_exp`**: Expression to evaluate if the condition is true.
  - **`else_exp`**: Expression to evaluate if the condition is false.
- **Purpose**: Implements decision-making logic in Mini-LISP.

---

### **Tokens and Ignored Characters**
```lark
ID : LETTER (LETTER | DIGIT | "-")*
BOOL_VAL : "#t" | "#f"

%import common.LETTER
%import common.DIGIT
%import common.WS
%import common.SIGNED_INT -> NUMBER

COMMENT: "//" /[^\n]/*

%ignore WS
%ignore COMMENT
```
- **`ID`**: Represents a valid identifier (variable or function name).
- **`BOOL_VAL`**: Represents boolean literals (`#t` for true, `#f` for false).
- **`NUMBER`**: Represents signed integers (e.g., `123`, `-45`).
- **Comments (`COMMENT`)**:
  - Matches lines starting with `//` and ignores them.
  - Example: `// This is a comment`.
- **Ignored Characters**:
  - **Whitespace (`WS`)**: Spaces, tabs, and line breaks are ignored.

---

### **Purpose of `grammar.lark`**
This grammar defines:
1. The **syntax** for a Mini-LISP program, ensuring that only valid expressions, statements, and programs are parsed.
2. The **structure** of various constructs (e.g., arithmetic, logical operations, conditionals, functions).
3. The **tokens** used in the language (e.g., identifiers, numbers, boolean values).

This grammar, when combined with a parser (e.g., Lark), enables the interpretation of Mini-LISP programs by creating an abstract syntax tree (AST) that can be evaluated by the `Interpreter`.