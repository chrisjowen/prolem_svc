defmodule Openai.EditText do
  def generate(%{"context" => context, "fragment" => fragment, "operation" => operation}) do
    with {:ok, response} <-
           OpenAI.chat_completion(
             model: "gpt-3.5-turbo",
             messages: [
               %{
                 role: "user",
                 content:
                   "Your job is take a context HTML document and a small part of that document.
                   You will be asked to either make that part longer, shorter or to simplify the language"
               },
               %{
                 role: "user",
                 content: hints()
               },
               %{
                 role: "user",
                 content: """
                 The conext HTML document is shown below:
                 ```#{context}```

                 The fragment of the document is shown below:
                 ```#{fragment}```

                 The operation to perform is shown below:
                 ```#{operation}```
                 """
               }
             ]
           ) do
      [choice | _] = response.choices
      content = choice["message"]["content"]
      {:ok, choice["message"]}
    end
  end

  defp hints(),
    do: """
      When doing your job remember:
        - Ensure that the response is applicable for the content of the whole document.
        - Only return the updates, no explinatory messages just the content.
        - The output should be a VALID HTML with text not enclosed in any tags.
        - Valid text tags are P, H1, H2, H3 and H4
        - Valid list tags are UL and OL
        - If required you may also use <Code> and <Pre> tags
    """
end
