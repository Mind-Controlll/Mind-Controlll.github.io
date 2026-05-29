#import "../../../index.typ": template, tufted
#import "@preview/theorion:0.6.0": *
#show: template.with(
  title: "作用域和存储空间",
  description: "从零学习 c++ ",
  date: datetime(year: 2026, month: 5, day: 28),
  tags: ("C++",),
)

= *作用域*(scope)和*存储空间*(storage)

== *变量计算*

#note-block[
  整型， 浮点，双精度等变量支持计算，所谓计算就是我们熟悉的 \+ ,\-,\*,\/,%等
]

```cpp
void calculate(){
    //整形变量支持计算，所谓计算就是我们熟悉的  `+` ,`-`,`*`,`/`,`%`等
    int a = 10;
    int b = 20;
    std::cout << "a + b = " << a+b << std::endl;
    std::cout << "a - b = " << a-b << std::endl;
    std::cout << "a * b = " << a*b << std::endl;
    std::cout << "a / b = " << a/b << std::endl;
    std::cout << "a % b = " << a%b << std::endl;
    //浮点型变量支持计算，所谓计算就是我们熟悉的  `+` ,`-`,`*`,`/`等
    float c = 10.5;
    float d = 20.3;
    std::cout << "c + d = " << c+d << std::endl;
    std::cout << "c - d = " << c-d << std::endl;
    std::cout << "c * d = " << c*d << std::endl;
    std::cout << "c / d = " << c/d << std::endl;
    //浮点型变量支持计算，所谓计算就是我们熟悉的  `+` ,`-`,`*`,`/`等
    double e = 10.5;
    double f = 20.3;
    std::cout << "e + f = " << e+f << std::endl;
    std::cout << "e - f = " << e-f << std::endl;
    std::cout << "e * f = " << e*f << std::endl;
    std::cout << "e / f = " << e/f << std::endl;
}
```

== ASCII码表
计算机中字符是用ASCII码记录的，ASCII码为128字符（0-127）分配了唯一的数字编码，包括英文字母（大小写）、数字、标点符号和一些控制字符（如换行、回车等）。
#figure(caption: "ASCII表")[
  #image("ASCII表.png")
]
\
比如字符‘A’ 对应十进制的65，字符‘a'对应十进制的97.

所以字符也可以计算
```cpp
//字符变量支持计算，所谓计算就是我们熟悉的  `+` ,`-`,`*`,`/`等
char g = 'a';
char h = 'b';
std::cout << "g + h = " << (int)(g+h) << std::endl;
std::cout << "g - h = " << (int)(g-h) << std::endl;
std::cout << "g * h = " << (int)(g*h) << std::endl;
std::cout << "g / h = " << (int)(g/h) << std::endl;
```

== 类型划分
#tip-block[各种数据类型可以支持转换，double, float，int, char 这种C++给我们提供的基本类型也叫做*基本(内置)*类型（*fundamental type*）。

我们以后学习了结构体struct和class等自定义类型后，这些类型叫做复合类型，引用和指针也属于*复合*类型(*compound type*)。]

== 变量大小

前文提过变量是存储在存储单元中，那么计算机为不同的变量分配的大小也不一样, 可以通过sizeof计算类型的大小
#tufted.margin-note[
  `sizeof` 的结果由类型、平台位数和对象布局决定；数组退化、结构体对齐、字符串末尾的 `'\0'` 都会影响你看到的大小。
]

#tip-block[
  `sizeof`计算大小的小技巧：
  - 指针的大小永远是固定的，取决于处理器位数，32位就是 4 字节，64位就是 8 字节;
  - 数组作为函数参数时会退化为指针，大小要按指针的计算;
  - `struct` 结构体要考虑字节对齐;
  - 字符串数组要算上末尾的 `'\0'`;
]

```cpp
void sizeofnum(){
    std::cout << "Size of char: " << sizeof(char) << " bytes\n";
    std::cout << "Size of int: " << sizeof(int) << " bytes\n";
    std::cout << "Size of float: " << sizeof(float) << " bytes\n";
    std::cout << "Size of double: " << sizeof(double) << " bytes\n";
    std::cout << "Size of long long: " << sizeof(long long) << " bytes\n";
}
```

```cpp
Size of char: 1 bytes
Size of int: 4 bytes
Size of float: 4 bytes
Size of double: 8 bytes
Size of long long: 8 bytes
```

=== `sizeof` 和 `strlen`

`strlen` 是头文件 cstring 中的函数，而 `sizeof` 是 C++ 中的运算符。

==== `strlen`

`strlen` 是一个 C 标准库中的函数，用于计算 C 风格字符串（以空字符 `'\0'` 结尾的字符数组）的长度，即不包括结尾的空字符的字符个数。

```cpp
#include <iostream>
#include <cstring>

int main() {
  char str[] = "Hello, world!";
  std::cout << "Length of str: " << strlen(str) << std::endl; // 输出字符串 str 的长度
}
```

`strlen` 源代码如下:

```cpp
size_t strlen(const char *str) {
  size_t length = 0;
  while (*str++)
      ++length;
  return length;
}
```

==== `sizeof`

`sizeof`是一个 C++ 编译期间计算的操作符，用于计算数据类型或对象所占用的字节数。

```cpp
#include <iostream>

int main() {
  int a = 42;
  std::cout << "Size of int: " << sizeof(int) << std::endl;    // 输出 int 类型的大小
  std::cout << "Size of a: " << sizeof(a) << std::endl;        // 输出变量 a 的大小
  std::cout << "Size of double: " << sizeof(double) << std::endl; // 输出 double 类型的大小
}
```

== 类型转换
在 C 语言中，我们大多数是用 `(type_name) expression` 这种方式来做强制类型转换，但是在 C++ 中，更推荐使用四个转换操作符来实现显式类型转换：
- static_cast
- dynamic_cast
- const_cast
- reinterpret_cast

=== static_cast
用法: s`tatic_cast <new_type> (expression)`

其实 static_cast 和 C 语言 () 做强制类型转换基本是等价的。

主要用于以下场景:
==== 基本类型之间的转换
将一个基本类型转换为另一个基本类型，例如将整数转换为浮点数或将字符转换为整数。
```cpp
int a = 42;
double b = static_cast<double>(a); // 将整数a转换为双精度浮点数b
```

==== 指针类型之间的转换
将一个指针类型转换为另一个指针类型，尤其是在类层次结构中从基类指针转换为派生类指针。*_这种转换不执行运行时类型检查_*，可能不安全，*_要自己保证指针确实可以互相转换_*。

```cpp
class Base {};
class Derived : public Base {};

Base* base_ptr = new Derived();
Derived* derived_ptr = static_cast<Derived*>(base_ptr); // 将基类指针base_ptr转换为派生类指针derived_ptr
```

==== 引用类型之间的转换
类似于指针类型之间的转换，可以将一个引用类型转换为另一个引用类型。在这种情况下，也应注意安全性。
```cpp
Derived derived_obj;
Base& base_ref = derived_obj;
Derived& derived_ref = static_cast<Derived&>(base_ref); // 将基类引用base_ref转换为派生类引用derived_ref
```
`static_cast`在编译时执行类型转换，在进行指针或引用类型转换时，需要自己保证合法性。

如果想要运行时类型检查，可以使用`dynamic_cast`进行安全的向下类型转换。

=== dynamic_cast
#tufted.margin-note[
  `dynamic_cast` 依赖 RTTI。转换失败时，指针通常返回空指针，引用会抛出 `std::bad_cast`。
]

用法: `dynamic_cast <new_type> (expression)`
\ `dynamic_cast`在C++中主要应用于父子类层次结构中的安全类型转换。它在运行时执行类型检查，因此相比于`static_cast`，它更加安全。`dynamic_cast`的主要应用场景：

==== `dynamic_cast` 底层原理

`dynamic_cast`的底层原理依赖于*运行时类型信息（RTTI, Runtime Type Information）*。C++编译器在编译时为支持多态的类生成RTTI，它包含了类的类型信息和类层次结构。

当使用虚函数时，编译器会为每个类生成一个虚函数表（vtable），并在其中存储指向虚函数的指针。伴随虚函数表的还有 RTTI(运行时类型信息)，这些辅助的信息可以用来帮助我们运行时识别对象的类型信息。

首先，每个多态对象都有一个指向其vtable的指针，称为vptr。RTTI（就是上面图中的 type_info 结构)通常与vtable关联。`dynamic_cast`就是利用RTTI来执行运行时类型检查和安全类型转换。

简化地说，`dynamic_cast`会通过对象的 *vptr* 获取其*RTTI*，然后比较请求的目标类型与从*RTTI*获得的实际类型。如果目标类型是实际类型或其基类，则转换成功。

如果目标类型是派生类，`dynamic_cast`会检查类层次结构，以确定转换是否合法。如果在类层次结构中找到了目标类型，则转换成功；否则，转换失败。当转换成功时，`dynamic_cast`返回转换后的指针或引用。如果转换失败，对于指针类型，`dynamic_cast`返回空指针；对于引用类型，它会抛出一个`std::bad_cast`异常。

因为`dynamic_cast`*依赖于运行时类型信息，它的性能可能低于其他类型转换操作（如`static_cast`），static 是编译器静态转换，编译时期就完成了*。

==== 向下类型转换
当需要将基类指针或引用转换为派生类指针或引用时，`dynamic_cast可以确保类型兼容性。`

如果转换失败，`dynamic_cast`将返回空指针（对于指针类型）或抛出异常（对于引用类型）。
```cpp
class Base { virtual void dummy() {} };
class Derived : public Base { int a; };

Base* base_ptr = new Derived();
Derived* derived_ptr = dynamic_cast<Derived*>(base_ptr); // 将基类指针base_ptr转换为派生类指针derived_ptr，如果类型兼容，则成功
```

==== 用于多态类型检查
处理多态对象时，`dynamic_cast`可以用来确定对象的实际类型，例如：
```cpp
class Animal { public: virtual ~Animal() {} };
class Dog : public Animal { public: void bark() { /* ... */ } };
class Cat : public Animal { public: void meow() { /* ... */ } };

Animal* animal_ptr = /* ... */;

// 尝试将Animal指针转换为Dog指针
Dog* dog_ptr = dynamic_cast<Dog*>(animal_ptr);
if (dog_ptr) {
    dog_ptr->bark();
}

// 尝试将Animal指针转换为Cat指针
Cat* cat_ptr = dynamic_cast<Cat*>(animal_ptr);
if (cat_ptr) {
    cat_ptr->meow();
}
```
另外，要使用`dynamic_cast`有效，基类至少需要一个虚拟函数。

因为，`dynamic_cast`*只有在基类存在虚函数(虚函数表)的情况下才有可能将基类指针转化为子类*。

=== const_cast
用法: `const_cast <new_type> (expression)`
new_type 必须是一个指针、引用或者指向对象类型成员的指针。

==== 修改const对象
当需要修改`const`对象时，可以使用`const_cast`来删除`const`属性。
```cpp
const int a = 42;
int* mutable_ptr = const_cast<int*>(&a); // 删除const属性，使得可以修改a的值
*mutable_ptr = 43; // 修改a的值
```

==== const对象调用非const成员函数
当需要使用const对象调用非const成员函数时，可以使用const_cast删除对象的const属性。
```cpp
class MyClass {
public:
    void non_const_function() { /* ... */ }
};

const MyClass my_const_obj;
MyClass* mutable_obj_ptr = const_cast<MyClass*>(&my_const_obj); // 删除const属性，使得可以调用非const成员函数
mutable_obj_ptr->non_const_function(); // 调用非const成员函数
```

=== reinterpret_cast
用法: `reinterpret_cast <new_type> (expression)`\

`reinterpret_cast`用于在不同类型之间进行低级别的转换。\
首先从英文字面的意思理解，interpret是“解释，诠释”的意思，加上前缀“re”，就是“重新诠释”的意思；cast 在这里可以翻译成“转型”（在侯捷大大翻译的《深度探索C++对象模型》、《Effective C++（第三版）》中，cast都被翻译成了转型），这样整个词顺下来就是“重新诠释的转型”。\
它仅仅是重新解释底层比特（也就是对指针所指针的那片比特位换个类型做解释），而不进行任何类型检查。因此，`reinterpret_cast`可能导致未定义的行为，应谨慎使用。

在某些情况下，需要在不同指针类型之间进行转换，如将一个int指针转换为char指针。

这在 C 语言中用的非常多，C语言中就是直接使用 () 进行强制类型转换
```cpp
int a = 42;
int* int_ptr = &a;
char* char_ptr = reinterpret_cast<char*>(int_ptr); // 将int指针转换为char指针
```

== 变量作用域
在C++中，变量作用域（Scope）指的是程序中变量可以被访问的代码区域。作用域决定了变量的生命周期和可见性。

我可以解释几种常见的变量作用域类型：

*全局作用域*：在函数外部声明的变量具有全局作用域。它们可以在程序的任何地方被访问，但通常建议在需要时才使用全局变量，因为它们可能导致代码难以理解和维护。\

*局部作用域*：在函数内部、代码块（如if语句、for循环等）内部声明的变量具有局部作用域。它们只能在声明它们的代码块内被访问。一旦离开该代码块，这些变量就不再可见。\

*命名空间作用域*：在命名空间中声明的变量（实际上是实体，如变量、函数等）具有命名空间作用域。它们只能在相应的命名空间内被直接访问，但可以通过使用命名空间的名称作为前缀来从外部访问.\

*类作用域*：在类内部声明的成员变量和成员函数具有类作用域。成员变量和成员函数可以通过类的对象来访问，或者在某些情况下（如静态成员）可以通过类名直接访问.\

*块作用域*：这是局部作用域的一个特例，指的是由大括号{}包围的代码块内部声明的变量。这些变量只能在该代码块内被访问.\

== 存储区域

#figure(caption: "C++内存布局")[
  #image("C++内存分区.png")
]

#tufted.margin-note[
  这些区域是帮助理解 C++ 对象生命周期的概念模型，实际布局仍取决于编译器、操作系统和运行环境。
]

请注意，直接访问其内存地址并不是C++编程中的标准做法，因为字符串常量通常是只读的，并且其存储位置取决于编译器和操作系统的实现。

另外，请注意，func函数中分配了堆内存并通过`delete`操作符释放了它。这是管理堆内存时的一个重要实践，以避免内存泄漏。然而，在实际应用中，更复杂的内存管理策略（如智能指针）可能更为合适。\

当您编译这个程序时，编译器会将`main`函数和`func`函数的代码转换成机器指令，并将这些指令存储在可执行文件的代码区中（尽管实际上是在磁盘上的可执行文件中，但在程序运行时，操作系统会将这些指令加载到内存的代码区中）。然后，当您运行这个程序时，CPU会从内存的代码区中读取这些指令并执行它们。\

在C++中，内存存储通常可以大致分为几个区域，这些区域根据存储的*数据类型*、*生命周期*和*作用域*来划分。这些区域主要包括：

*代码区（Code Segment/Text Segment）*：
存储程序执行代码（即机器指令）的内存区域。这部分内存是共享的，只读的，且在程序执行期间不会改变。
举例说明：当你编译一个C++程序时，所有的函数定义、控制结构等都会被转换成机器指令，并存储在代码区。\

*全局/静态存储区（Global/Static Storage Area）*：
存储全局变量和静态变量的内存区域。这些变量在程序的整个运行期间都存在，但它们的可见性和生命周期取决于声明它们的作用域。
举例说明：全局变量（在函数外部声明的变量）和静态变量（使用static关键字声明的变量，无论是在函数内部还是外部）都会存储在这个区域。\

*栈区（Stack Segment）：*
存储局部变量、函数参数、返回地址等的内存区域。栈是一种后进先出（`LIFO`）的数据结构，用于存储函数调用和自动变量。
举例说明：在函数内部声明的变量（不包括静态变量）通常存储在栈上。当函数被调用时，其参数和局部变量会被推入栈中；当函数返回时，这些变量会从栈中弹出，其占用的内存也随之释放。\

*堆区（Heap Segment）：*
由程序员通过动态内存分配函数（如`new`和`malloc`）分配的内存区域。堆区的内存分配和释放是手动的，因此程序员需要负责管理内存，以避免内存泄漏或野指针等问题。
举例说明：当你使用`new`操作符在C++中动态分配一个对象或数组时，分配的内存就来自堆区。同样，使用`delete`操作符可以释放堆区中的内存。\

*常量区（Constant Area）：*
存储常量（如字符串常量、`const`修饰的全局变量等）的内存区域。这部分内存也是只读的，且通常在程序执行期间不会改变。
举例说明：在C++中，使用双引号括起来的字符串字面量通常存储在常量区。此外，使用const关键字声明的全局变量，如果其值在编译时就已确定，也可能存储在常量区.\
