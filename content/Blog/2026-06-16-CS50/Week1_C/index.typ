#import "../../../index.typ": template, tufted
#show: template.with(
  title: "C",
  description: "CS50x (2026 version)",
  date: datetime(year: 2026, month: 6, day: 19),
  tags: ("CS50x",),
)

= C

== Source code

- Recall that machines only understand binary. Where humans write *source code*, a list of instructions for the computer that is human readable, machines only understand what we can now call *machine code*. This machine code is a pattern of ones and zeros that produces a desired effect.

#html.div(class: "marginnote margin-figure")[
  #image("Tuning machine to convert source code into machine code.png", width: 80%, alt: "Compiler converting source code into machine code")
  #par[Compiler converting source code into machine code]
]
- It turns out that we can convert source code into machine code using a very special piece of software called a compiler. Today, we will be introducing you to a compiler that will allow you to convert *source code* in the programming language *C* into machine code.

== Visual Studio Code for CS50

- The text editor that is utilized for this course is *Visual Studio Code*, aka *VS Code*, affectionately referred to as #link("https://cs50.dev/")[cs50.dev], which can be accessed via that same URL.

- Notice that there is a file explorer on the left side where you can find your files. Further, notice that there is a region in the middle called a text editor where you can edit your program. Finally, there is a `command line interface`, known as a *CLI*, command line, or terminal window, where we can send commands to the computer in the cloud.

- *GUI (graphical user interface)*
#html.div(class: "marginnote margin-figure")[
  #image("vs code GUI.png", width: 80%, alt: "Visual Studio Code GUI for CS50")
  #par[Visual Studio Code GUI for CS50]
]

- The IDE includes everything you need for this course.

== Hello, World

Three commands for the first program:
```bash
code hello.c
make hello
./hello
```

- `code hello.c` creates a file named `hello.c` and opens it in the text editor. The `.c` extension indicates that it is a C source file.
- `make hello` compiles the source code and creates an executable file named `hello`.
- `./hello` runs the executable, which prints `hello, world` in the terminal.

```c
// A program that says hello to the world

#include <stdio.h>

int main(void)
{
    printf("hello, world\n");
}
```

- C provides escape sequences for characters that are difficult to write directly:
```text
\n  start a new line
\r  return to the start of the current line
\"  include a double quote
\'  include a single quote
\\  include a backslash
```

== Header Files and CS50 Manual Pages
- The `#include <stdio.h>` directive makes declarations from the `stdio.h` header file available to the program. Among other things, this lets us call the standard library function `printf`. Notice that the header is named `stdio.h`, not `studio.h`.


- CS50 provides a library with the `cs50.h` header. It includes several functions that serve as training wheels while you get started in C:
```c
get_char
get_double
get_float
get_int
get_long
get_string
```

== Hello, You

- In C, we can do the same. Modify your code as follows:
```c
// get_string and printf with incorrect placeholder

#include <stdio.h>

int main(void)
{
    string answer = get_string("What's your name? ");
    printf("hello, answer\n");
}
```
The `get_string` function reads a string from the user. Without `#include <cs50.h>`, the compiler does not know the `string` type or the declaration of `get_string`. The program also needs a format code to print the value stored in `answer`. Add the header and modify the call to `printf` as follows:
```c
// get_string and printf with %s

#include <cs50.h>
#include <stdio.h>

int main(void)
{
    string answer = get_string("What's your name? ");
    printf("hello, %s\n", answer);
}
```
`%s` is a format code that tells `printf` to expect a string. The value of `answer` is substituted for `%s`.

== Linux
Some common commands used in the terminal include:
- `cd` changes the current directory.
- `cp` copies files and directories.
- `ls` lists files in a directory.
- `mkdir` creates a directory.
- `mv` moves or renames files and directories.
- `rm` removes files.
- `rmdir` removes empty directories.

For example, running `ls` displays the files in the current directory.

== Conditionals

In C, you can compare two values as follows:
```c
// Conditionals that are mutually exclusive

if (x < y)
{
    printf("x is less than y\n");
}
else
{
    printf("x is not less than y\n");
}
```
Similarly, we can plan for three possible outcomes:
```c
// Conditional that isn't necessary

if (x < y)
{
    printf("x is less than y\n");
}
else if (x > y)
{
    printf("x is greater than y\n");
}
else if (x == y)
{
    printf("x is equal to y\n");
}
```
You may have guessed that we can improve this code as follows:
```c
if (x < y)
{
    printf("x is less than y\n");
}
else if (x > y)
{
    printf("x is greater than y\n");
}
else
{
    printf("x is equal to y\n");
}
```
When conditions are mutually exclusive, an `else if` chain communicates that only one branch should run and avoids unnecessary checks. Separate `if` statements remain appropriate when more than one condition may be true.
```c
if (x > 0)
{
    // This branch may run.
}
if (x % 2 == 0)
{
    // This branch may also run.
}
```

== Types
There are many data types used in C:
```text
bool
char
float
int
long
string
```

`string` is provided by the CS50 library; it is not a built-in C type.

== Format Codes
We used `%s` as a placeholder for a string in `printf`. This placeholder is called a format code. Some format codes used in this course include:
```text
%c
%f
%i
%li
%s
```

== Variables

In C, you can assign a value to an int or integer as follows:
```c
int counter = 0; // Assign 0 to an int named counter
counter = counter + 1; // Add 1 to counter
counter += 1;
counter++;
counter--;
```

== compare.c
```c
// Conditionals

#include <cs50.h>
#include <stdio.h>

int main(void)
{
    // Prompt user for integers
    int x = get_int("What's x? ");
    int y = get_int("What's y? ");

    // Compare integers
    if (x < y)
    {
        printf("x is less than y\n");
    }
    else if (x > y)
    {
        printf("x is greater than y\n");
    }
    else
    {
        printf("x is equal to y\n");
    }
}
```

== agree.c
Considering another data type called `char`, we can start a new program by running `code agree.c` in the terminal.
Where a `string` is a sequence of characters, a `char` stores a single character.
```c
// Comparing against lowercase and uppercase char

#include <cs50.h>
#include <stdio.h>

int main(void)
{
    // Prompt user to agree
    char c = get_char("Do you agree? ");

    // Check whether agreed
    if (c == 'y')
    {
        printf("Agreed.\n");
    }
    else if (c == 'Y')
    {
        printf("Agreed.\n");
    }
    else
    {
        printf("Not agreed.\n");
    }
}
```

```c
#include <cs50.h>
#include <stdio.h>

int main(void)
{
    // Prompt user to agree
    char c = get_char("Do you agree? ");

    // Check whether agreed
    if (c == 'Y' || c == 'y')
    {
        printf("Agreed.\n");
    }
    else
    {
        printf("Not agreed.\n");
    }
}
```

== Loops and meow.c

In your terminal, run `code meow.c` and write the following:
```c
// Opportunity for better design

#include <stdio.h>

int main(void)
{
    printf("meow\n");
    printf("meow\n");
    printf("meow\n");
}
```

```c
// Abstraction with parameterization

#include <stdio.h>

void meow(int n);

int main(void)
{
    meow(3);
}

// Meow some number of times
void meow(int n)
{
    for (int i = 0; i < n; i++)
    {
        printf("meow\n");
    }
}
```

We can also validate the value provided by the user:
```c
// Return value

#include <cs50.h>
#include <stdio.h>

int get_positive_int(void);
void meow(int n);

int main(void)
{
    int n = get_positive_int();
    meow(n);
}

// Get number of meows
int get_positive_int(void)
{
    int n;
    do
    {
        n = get_int("Number: ");
    }
    while (n < 1);
    return n;
}

// Meow some number of times
void meow(int n)
{
    for (int i = 0; i < n; i++)
    {
        printf("meow\n");
    }
}
```

== Correctness, Design, Style

- Code can be evaluated along three axes.
- Correctness asks whether the code runs as intended. You can check correctness with `check50`.
- Design asks how well the code is structured.
- Style asks whether the code is readable and consistent. You can evaluate style with `style50`.

== Mario
In the terminal, run `code mario.c` and write the following:
```c
// Prints a row of 4 question marks

#include <stdio.h>

int main(void)
{
    printf("????\n");
}
```

#html.div(class: "marginnote margin-figure")[
  #image("Mario-first.png", width: 80%, alt: "Four horizontal question-mark blocks in Mario")
  #par[Four horizontal question-mark blocks in Mario]
]
Using a loop, we can more efficiently print the question marks:

```c
// Prints a row of 4 question marks with a loop

#include <stdio.h>

int main(void)
{
    for (int i = 0; i < 4; i++)
    {
        printf("?");
    }
    printf("\n");
}
```

== Operators
Operators represent operations supported by the language. Common arithmetic operators in C include:
```text
+ for addition
- for subtraction
\* for multiplication
/ for division
% for remainder
```

Types are important because each type has specific limits. On systems where `int` is 32 bits, a signed `int` can typically store values up to `2147483647`, while an unsigned `int` can store values up to `4294967295`. Arithmetic outside the range of a signed integer causes undefined behavior; unsigned arithmetic wraps modulo $2^32$ on a 32-bit unsigned type.

Using a `long` provides a larger range on CS50's 64-bit Linux environment. When printing a `long`, use `%li` instead of `%i`. A `long` delays, but does not eliminate, overflow.

Floating-point imprecision illustrates that computers cannot represent every real number exactly.

We could use floats throughout:
```c
// Floats

#include <cs50.h>
#include <stdio.h>

int main(void)
{
    // Prompt user for x
    float x = get_float("What's x? ");

    // Prompt user for y
    float y = get_float("What's y? ");

    // Divide x by y
    printf("%.50f\n", x / y);
}
```

We use `get_float` for input and `%.50f` to display 50 digits after the decimal point. The result may contain unexpected digits because many decimal fractions do not have an exact binary floating-point representation.

== Problem set

=== `me/hello.c`

```c
#include <cs50.h>
#include <stdio.h>

int main(void)
{
    string me = get_string("What's your name? ");

    printf("hello, %s\n", me);
}
```

=== `mario-less/mario.c`

```c
#include <cs50.h>
#include <stdio.h>

int main(void)
{
    int height;
    do
    {
        height = get_int("Height: ");
    }
    while (height < 1);

    for (int row = 1; row <= height; row++)
    {
        for (int spaces = 0; spaces < height - row; spaces++)
        {
            printf(" ");
        }
        for (int bricks = 0; bricks < row; bricks++)
        {
            printf("#");
        }
        printf("\n");
    }
}
```

=== `mario-more/mario.c`

```c
#include <cs50.h>
#include <stdio.h>

int main(void)
{
    int height;
    do
    {
        height = get_int("Height: ");
    }
    while (height < 1);

    for (int row = 1; row <= height; row++)
    {
        for (int spaces = 0; spaces < height - row; spaces++)
        {
            printf(" ");
        }
        for (int bricks = 0; bricks < row; bricks++)
        {
            printf("#");
        }
        printf("  ");
        for (int bricks = 0; bricks < row; bricks++)
        {
            printf("#");
        }
        printf("\n");
    }
}
```

=== `cash/cash.c`

```c
#include <cs50.h>
#include <stdio.h>

int main(void)
{
    int cents;
    do
    {
        cents = get_int("Change owed: ");
    }
    while (cents < 0);

    int count = 0;
    count += cents / 25;
    cents %= 25;

    count += cents / 10;
    cents %= 10;

    count += cents / 5;
    cents %= 5;

    count += cents;
    printf("%i\n", count);
}
```

=== `credit/credit.c`

```c
#include <cs50.h>
#include <stdio.h>

bool is_valid_luhn(long number);
int get_digit_count(long number);
int get_first_digit(long number);
int get_second_digit(long number);

int main(void)
{
    long number = get_long("Number: ");

    if (!is_valid_luhn(number))
    {
        printf("INVALID\n");
        return 0;
    }

    int digits = get_digit_count(number);
    int first = get_first_digit(number);
    int second = get_second_digit(number);

    if (first == 4 && (digits == 13 || digits == 16))
    {
        printf("VISA\n");
    }
    else if (first == 5 && second >= 1 && second <= 5 && digits == 16)
    {
        printf("MASTERCARD\n");
    }
    else if (first == 3 && (second == 4 || second == 7) && digits == 15)
    {
        printf("AMEX\n");
    }
    else
    {
        printf("INVALID\n");
    }
}

bool is_valid_luhn(long number)
{
    int sum = 0;
    while (number > 0)
    {
        sum += number % 10;
        number /= 10;

        int doubled = (number % 10) * 2;
        sum += doubled / 10 + doubled % 10;
        number /= 10;
    }
    return sum % 10 == 0;
}

int get_digit_count(long number)
{
    int digits = 0;
    while (number > 0)
    {
        number /= 10;
        digits++;
    }
    return digits;
}

int get_first_digit(long number)
{
    while (number >= 10)
    {
        number /= 10;
    }
    return number;
}

int get_second_digit(long number)
{
    while (number >= 100)
    {
        number /= 10;
    }
    return number % 10;
}
```
