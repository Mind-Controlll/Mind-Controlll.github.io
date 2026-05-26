#import "../../index.typ": template, tufted
#show: template.with(
  title: "变量和输出",
  description: "从零学习 c++ ",
  date: datetime(year: 2026, month: 5, day: 26),
)

== 变量(variable)

=== 变量定义

所有计算机都有内存，即 RAM （随机访问内存）， 可供程序使用。你可以将 RAM 看做是一系列具有标号的“信箱”，在程序运行的过程中，它们可以存放一系列的数据片段。一个单独的存放在内存中的数据，称之为值（value）。

在一些比较古老的编程语言中（例如 Apple Basic），你可以直接访问这些”信箱“（对应的语句类似于获取标号为7532的信箱中的数据）

在 C++ 中，直接访问内存是不被允许的，我们只能够通过某个对象间接地访问内存。所谓对象，即存放在某个区域（一般来讲为内存），具有值以及其他属性的数据。获取标号为7532的信箱中的数据 是不可行的，取而代之的应当是获取某个对象所保存的值。这意味着，我们可以专注于使用对象来存储和读取数据，而不必担心它们实际使用的内存。

对象可以是命名的，或未命名的。一个命名的对象被称为变量，而该对象的名字本身，则称为标识符(identifier)。在我们的程序中，大多数的对象都属于变量。

在C++中，变量是用来存储数据值的一种实体。每个变量都有一个类型，这个类型决定了变量可以存储的数据的种类以及变量在内存中所占的空间大小。

=== 变量的声明与初始化(variable assignment and initialization)

计算机中数据是按照二进制存储的，一个字节占*8bit*, bit就是位的意思，比如数字2会转化为二进制`00000010`, 然后将这个`00000010`放到计算机为我们分配好的存储单元里，这个存储单元本身还有一个地址，假设存储单元的地址为5，转化为二进制就是`00000101`.

当我们想要取出数据`00000010`时，需要先访问地址`00000101`找到存储单元，然后取出存储单元存储的数据。

再次理解以下，存储单元可以理解为一个变量，存储了数据`00000010`，变量的地址为`00000101`。理解这个，之后我们会介绍*指针*的概念。

在C++中，你首先需要声明一个变量，然后（可选地）可以初始化它。声明变量时，你需要指定变量的类型和名称

```cpp
// 声明一个整型变量age，未初始化
int age; 
// 声明并初始化一个整型变量height
int height = 175; 
// 声明并初始化一个双精度浮点型变量weight
double weight = 65.5; 
// 声明并初始化一个字符型变量gender
char gender = 'M';
```

=== 变量命名规则

在C++中，变量名可以包含字母、数字和下划线（\_），但不能以数字开头。此外，C++是大小写敏感的，因此age和Age被视为两个不同的变量。

=== 变量类型

C++支持多种基本数据类型，包括整型（*int*、*short*、*long*、*long long*）、浮点型（*float*、*double*、*long double*）、字符型（*char*）、布尔型（*bool*）等。此外，C++还支持枚举（*enum*）、结构体（*struct*）、联合体（*union*）和类（*class*）等*_复合数据类型_*。

==== 示例：使用变量

```cpp
#include <iostream>

int main() {
    //初始化变量a和b
    int a = 5, b = 10;
    //a+b的值赋值给sum
    int sum = a + b;
    //输出求和的结果
    std::cout << "The sum of " << a << " and " << b << " is " << sum << std::endl;
    return 0;
}
```

=== iostream 简介：cout，cin 和 endl

输入输出库 ( IO 库) 是 C++ 标准库的一部分，用于处理基本的输入和输出。我们会使用该库提供的功能从键盘获取输入并向控制台输出数据。iostream 中的 io 指代的是输入输出（input/output）。

==== `std:: cout`

iostream 库中包含了一些预定义的变量供我们使用，其中最有用的当属 `std::cout`，通过它可以向控制台打印文本，`cout` 代表的含义就是字符输出（*character output*）。

```cpp
#include <iostream> // for std::cout
 
int main()
{
    std::cout << "Hello world!"; // print Hello world! to console
 
    return 0;
}
```
在这个程序中，_iostream_ 已经被包含了，因此我们可以访问 `std::cout`。在主函数中，我们使用了 `std::cout`，并配合插入运算符（`<<`）将文本 Hello world!发送到控制台并打印出来。\
`std::cout` 不仅可以打印文本，还可以打印数字\
它还可以用来打印变量的值

==== `std:: endl`
显然，将一条语句拆分为两行，并不会产生不同的结果。

如果我们希望分行打印，则必须要告知控制台将光标移动到下一行。

一种方式是使用 `std::endl`。当使用 `std::cout` 进行输出时，`std::endl` 会打印一个换行符（促使光标被移动到下一行的开头）。因此，`endl` 表示的是结束该行（*end line*）。

```cpp
#include <iostream> // for std::cout and std::endl
 
int main()
{
    std::cout << "Hi!" << std::endl; // std::endl will cause the cursor to move to the next line of the console
    std::cout << "My name is Alex." << std::endl;
 
    return 0;
}
```

输出结果：

```cpp
Hi!
My name is Alex.
```

#tufted.margin-note[
  在左面的程序中，第二个`std::endl`从技术上讲并无必要，因为在执行完这行代码后程序会立即停止。不过，这么做其实还有两个有用的目的：首先，它可以表明该行的内容已经被”完整输出“ （与之相对的是部分输出，即后续代码中还有需要输出的部分）。其次，如果将来我们在后面添加其他额外的输出，就不需要修改已有的代码了。因此不妨加上它。
]

==== `std:: endl` vs `\n`

使用 `std::endl` 换行的效率稍微有点低，因为它通常需要完成两件事：将光标移动到下一行，然后确保输出结果马上显示在屏幕上（称为刷新输出）。当使用 `std::cout` 进行输出时，`std::cout` 本来就会刷新输出（即使没有刷新，通常也不会产生什么问题）。因此，使用 `std::endl` 来刷新输出就有些多余了。

因此，使用换行字符(`\n`)一般来讲是更好的选择。‘\n’ 符号会将光标移动到下一行，但是它并不会请求刷新，因此在无需特别刷新时可以获得更好的性能。‘\n’ 字符还更易读，因为它不仅更简洁，而且还可以嵌入在已有的文本中。

```cpp
#include <iostream> // for std::cout
 
int main()
{
    int x{ 5 };
    std::cout << "x is equal to: " << x << '\n'; // Using '\n' standalone
    std::cout << "And that's all, folks!\n"; // Using '\n' embedded into a double-quoted piece of text (note: no single quotes when used this way)
    return 0;
}
```

#tufted.margin-note[
  `\n`使用的是反斜杠（和其他特殊字符一样），而不是斜杠。使用斜杠（例如 ‘/n’）可能会带来无法预料的结果。
]

==== `std:: cin`
`std::cin` 是 iostream 中预定义的另外一个变量。与用于输出的 std::cout 不同， `std::cin`(表示字符输入，“*character input*”) 配合提取运算符(`>>`)，可以从键盘读取输入。当然，输入的结果必须存放在变量中才可以被使用。
```cpp
#include <iostream>  // for std::cout and std::cin
 
int main()
{
    std::cout << "Enter a number: "; // ask user for a number
 
    int x{ }; // define variable x to hold user input (and zero-initialize it)
    std::cin >> x; // get number from keyboard and store it in variable x
 
    std::cout << "You entered " << x << '\n';
    return 0;
}
```
*例如*：

```cpp
Enter a number: 4
You entered 4
```

#tufted.margin-note[
  变量在用于接收用户输入（例如通过 `std::cin`）的数据之前，是否应该进行初始化这个问题有很多争论，因为用户的输入会覆盖初始化的值。与我们之前的建议类似，变量在使用前都必须要进行初始化，因此这里的*最佳实践*仍然是，*_变量要先进行初始化再用于接收用户输入_*。
]