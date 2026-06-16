#import "../../../index.typ": template, tufted
#show: template.with(
  title: "Scratch",
  description: "CS50x (2026 version)",
  date: datetime(year: 2026, month: 6, day: 16),
  tags: ("CS50x",),
)


== Chat.Py

- Give a taste of programing our own charbox ```chat.py```
- On a system already configured for using OpenAI's libraries, we can directly code as follows:
 + ```bash 
   code chat.py
   ```
 + In the text editor, we can type to program:
 ```Python
 form openai to import OpenAI
 client = OpenAI();
 
 response = client.response.creat(
  input = "In one sentence, what is CS50?",
  model = "gpt-5"
 )

 print(response.output_text)
 ```
 