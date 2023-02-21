# chatGPT ShinyApp
A minimal R Shiny App application that enables users to interact with GPT-3. 

It is built upon the [{gptchatteR}](https://github.com/isinaltinkaya/gptchatteR/issues/) package by [Isin Altinkaya](https://github.com/isinaltinkaya). For this example I used all the default specifications.

---

On the left side bar of the app there is a text area input to let users submit their prompts to GPT. Upon submission, a table with populate displaying both, the prompt and the GPT response. Users can select and delete any rows from the table at any time. 

![image](https://user-images.githubusercontent.com/40781886/220246697-3ef8146c-6e46-415b-ad26-01e5db84298e.png)

The table is able to display html content. A set of buttons are included to let users export, copy and print the table.

---

App Code: [here](https://github.com/josedv82/chatGPT_shinyapp/blob/main/shiny_gpt.R)

Live Version: [here](https://maximus0.shinyapps.io/chatGPT_shinyapp/)

