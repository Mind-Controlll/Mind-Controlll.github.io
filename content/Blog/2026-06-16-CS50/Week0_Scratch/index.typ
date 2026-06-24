#import "../../../index.typ": template, tufted
#show: template.with(
  title: "Scratch",
  description: "CS50x (2026 version)",
  date: datetime(year: 2026, month: 6, day: 16),
  tags: ("CS50x",),
)

#let callout(body, title: [注意], fill: rgb("#fff8dc"), color: rgb("#d97706")) = block(
  width: 100%,
  fill: fill,
  stroke: 1pt + color,
  radius: 4pt,
  inset: 10pt,
)[
  #strong(title)
  #linebreak()
  #body
]

== Chat.py

- Give a taste of programming our own chatbot `chat.py`.
- On a system already configured for using OpenAI's libraries, we can directly code as follows:
  ```bash
  code chat.py
  ```

- In the text editor, we can type:

  ```python
  from openai import OpenAI

  client = OpenAI()

  response = client.responses.create(
    input="In one sentence, what is CS50?",
    model="gpt-5",
  )

  print(response.output_text)
  ```

- If you want to ask the user what they want, store their message in a variable:

  ```python
  from openai import OpenAI

  client = OpenAI()

  prompt = input("prompt: ")

  response = client.responses.create(
    input=prompt,
    model="gpt-5",
  )

  print(response.output_text)
  ```

- If you want to set instructions for the model, include the system message in the input:

  ```python
  from openai import OpenAI

  client = OpenAI()

  user_prompt = input("prompt: ")

  response = client.responses.create(
    model="gpt-5",
    input=[
      {
        "role": "system",
        "content": "Limit your answer to one sentence.",
      },
      {
        "role": "user",
        "content": user_prompt,
      },
    ],
  )

  print(response.output_text)
  ```

== Computer science and Problem solving

Essentially, computer programming is about taking some input and creating some output - thus solving a problem. What happens in between the input and output, what we could call a *black box*, is the focus of this course.

#html.div(class: "marginnote margin-figure")[
  #image("blackbox.png", width: 80%, alt: "A black box with input and output")
  #par[A black box with input and output]
] <black-box>

For example, we may need to take attendance for a class. We could use a system called *unary* (also called *base-1*) to count one finger at a time.
Computers today count using a system called *binary* (also called *base-2*). It’s from the term binary digit that we get a familiar term called bit. A bit is a zero or one: on or off.

#tufted.margin-note[
  If you imagine using a light bulb, a single bulb can only count from zero to one.
However, if you were to have three light bulbs, there are more options open to you!
]

Inside your devices, such as your iPhone or computer, there are millions of metaphorical light bulbs called *transistors* that enable the activities conducted on these devices one may take for granted each day.


As a heuristic, we could imagine that the following values represent each possible place in our binary digit(bit):

4 2 1
Using three light bulbs, the following could represent zero:

4 2 1\
0 0 0
Similarly, the following would represent one:

4 2 1\
0 0 1
By this logic, we could propose that the following equals two:

4 2 1\
0 1 0
Extending this logic further, the following represents three:

4 2 1\
0 1 1
Four would appear as:

4 2 1\
1 0 0
We could, in fact, using only three light bulbs count as high as seven!

4 2 1\
1 1 1
Computers use base-2 to count. This can be pictured as follows:

$2^2$  $2^1$  $2^0$\
4    2    1
Therefore, you could say that it would require three bits (the four’s place, the two’s place, and the one’s place) to represent a number as high as seven.\
Similarly, to count a number as high as eight, values would be represented as follows:

8 4 2 1\
1 0 0 0\

Computers generally use eight bits (also known as a byte) to represent a number. For example, `00000101` is the number 5 in binary. `11111111` represents the number 255. You can imagine zero as follows:\
128 64 32 16 8 4 2 1\
0	0	0	0	0	0	0	0\

== ASCII
- Just as numbers are binary patterns of ones and zeros, letters are represented using ones and zeros, too!
- Since there is an overlap between the ones and zeros that represent numbers and letters, the ASCII standard was created to map specific letters to specific numbers.
- For example, the letter A was decided to map to the number 65. 01000001 represents the number 65 in binary. You can visualize this as follows:\
128 64 32 16 8 4 2 1\
0	0	0	0	0	0	0	0\


- If you received a text message, the binary under that message might represent the numbers 72, 73, and 33. Mapping these out to ASCII, your message would look as follows:
H   I   !\
72  73  33\
If you wish, you can learn more about #link("https://en.wikipedia.org/wiki/ASCII")[ASCII].

== Unicode
- As time has rolled on, there are more and more ways to communicate via text.
- Since there were not enough digits in binary to represent all the various characters that could be represented by humans, the Unicode standard expanded the number of bits that can be transmitted and understood by computers. Unicode includes not only special characters, but emoji as well.
- There are emoji that you probably use every day. The following may look familiar to you:

😀 😃 😄 😁 😆 😅 😂 🙂 🙃 😉 😊 😇 😍 😘 😗 😙 😚 😋 😛 😜 😝 🤑 🤓 😎 🤗 😏 😶 😐 😑 😒 🙄 😬 😕 ☹️ 😟 😮 😯 😲 😳 😦 😧 😨\

- While the pattern of zeros and ones is standardized within Unicode, each device manufacturer may display each emoji slightly differently than another manufacturer.
- More and more features are being added to the Unicode standard to represent further characters and emoji.

== RGB

- Zeros and ones can be used to represent color.
- Red, green, and blue (called `RGB`) are a combination of three numbers.

#html.div(class: "marginnote margin-figure")[
  #image("RGB.png", width: 80%, alt: "RGB color and corespending bit number")
  #par[RGB color and corespending bit number]
] <RGB>


- Taking our previously used 72, 73, and 33, which said `HI!` via text, would be interpreted by image readers as a `light shade of yellow`. The red value would be 72, the green value would be 73, and the blue would be 33.

- The three bytes required to represent various colors of red, blue, and green (or RGB) make up each pixel (or dot) of color in any digital image. Images are simply collections of RGB values.

- Zeros and ones can be used to represent images, videos, and music!
- Videos are sequences of many images that are stored together, just like a flipbook.
- Music can be represented similarly using various combinations of bytes.

== Algorithms

- Problem-solving is central to computer science and computer programming. An algorithm is a step-by-step set of instructions to solve a problem.
- Imagine the basic problem of trying to locate a single name in a phone book.
How might one go about this?
- One approach could be to simply read from page one to the next to the next until reaching the last page.
- Another approach could be to search two pages at a time.
- A final and perhaps better approach could be to go to the middle of the phone book and ask, “Is the name I am looking for to the left or to the right?” Then, repeat this process, cutting the problem in half and half and half.
- Each of these approaches could be called algorithms. The speed of each of these algorithms can be pictured as follows in what is called big-O notation:

#figure(
  image("phone_book_solutions.png", width: 80%, alt: "Three different algorithms to search a phone book, with corresponding big-O notation"),
  caption: [phone_book_solutions.png],
) <big-O>

== Pseudocode
#tufted.margin-note[
  Pseudocode --- 伪代码
]
- Pseudocode is human-readable instructions that often describe the steps of an algorithm.
- The ability to create pseudocode is central to one’s success in both this class and in computer programming.
- For example, considering the third algorithm above, we could compose pseudocode as follows:
```Pseudocode
  Pick up phone book
  Open to middle of phone book
  Look at page
  If person is on page
      Call person
  Else if person is earlier in book
      Open to middle of left half of book
      Go back to line 3
  Else if person is later in book
     Open to middle of right half of book
     Go back to line 3
 Else
     Quit
```

- pseudocode can help us consider the logic of our algorithms and the steps we need to take to solve a problem before we start coding; Help others understand our code; and help us understand your code decision and how your code works
- some lines include `if` and `if else`, this called conditions
- notice "go back to line 3", what we call "loops"


#callout[
  这里用中文书写这个课程的作业提交操作（week0比较特殊， 之后week problem sets可能比较一致只用写一次，同时这个week0作业提交操作也会包含第一次注册eDX还有绑定github账号等操作）：

  *Week 0 提交步骤*

+ 打开 Week 0 作业页：#link("https://cs50.harvard.edu/x/psets/0/scratch/")[Starting from Scratch]。
+ 在 scratch.mit.edu 做一个 Scratch 项目。项目至少要满足这些要求：至少 2 个角色、至少 3 段脚本、至少 1 个条件、1 个循环、1 个变量、1 个带输入的自定义积木。
+ 做完后，在 Scratch 里点 File > Save now，再点 File > Save to your computer，下载得到一个 .sb3 文件。
+ 先提交官方表单：CS50 form。这个表单会用到你的 edX/GitHub 信息，官方说明这一步要先做。
+ 然后访问 CS50 Submit 授权链接，用 GitHub 登录，点 Authorize cs50，勾选允许课程 staff 访问你的提交，然后点 Join course。
+ 打开 Week 0 上传页：submit.cs50.io/upload/cs50/problems/2026/x/scratch。
+ 点 Choose File，选择你刚才下载的 .sb3 文件，再点 Submit。官方提醒：如果报 “No files in this directory are expected...” 这类错误，通常是文件名不是以 .sb3 结尾。
+ 上传成功后，会跳到你的 submission 页面。点 submission link，再点 check50 link，可以看作业检查结果。你可以在截止时间前重复提交，系统会记录提交情况。
+ 之后查看进度用这个页面：#link("https://cs50.me/cs50x")[CS50 Gradebook]。

补充：Week 1 以后通常会在 cs50.dev 的 Codespace 里写代码，然后在终端运行类似 check50 ... 测试，再运行 submit50 ... 提交。比如 Week 1 的 “Hello, It’s Me” 官方提交命令是：
```bash
submit50 cs50/problems/2026/x/me
```
]
