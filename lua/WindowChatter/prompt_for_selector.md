Please help me write a piece of code for my Neovim plugin project. 

Now we only force on a small part of the whole functionality.

Here is a file called "selection_manager.lua" that should be filled. 

Like the name, this fill should write code that makes the following happen.

Firstly, define "visual selections":
1. "visual selections" is the user that uses a visual mode that selects and executes a "record" function. 
2. "visual selections" should contain at least this information: file name, starting points (line, and column) and ending points


Secondly, define "visual selections set":
1. A "visual selections set" can contain multiple "visual selections" with no upper limit. Each visual selection set should contain an Id. 
2. There can be many "visual selection sets" in the use case.
3. The visual selection sets have an order. 



Thirdly, implement the following methods:
1. create a visual selection set.
2. records a visual selection positions into a "set"
3. save the visual selections sets into a place that enables the "records" can be stored (will not be lost when exits Neovim)
4. load the visual selection sets from a place that has just implemented before.
5. get visual selections by the set IDs.
6. get the current visual selection set ID.
7. get the next visual selection set ID (it should be cycling)

Now please output the file "selection_manager.lua" wrapped in 
``` code ``` 
coding blocks.  

