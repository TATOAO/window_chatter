Great, now lets do it again. Please help me write a piece of code for my Neovim plugin project. 

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
3. save the visual selections sets into a place that enables the "records" to be stored (will not be lost when exits Neovim)
4. load the visual selection sets from a place that has just been implemented before.
5. get visual selections by the set IDs.
6. get the current visual selection set ID.
7. get the next visual selection set ID (it should be cycling).
8. remove a visual selection in a selection set.
9. remove a visual selection set and preserve the order between other selection sets. 
10. find visual selections by [file name, starting points (line, and column) and ending points]. return all the selections that are overlapped or after the given region. 
11. a callback function `on_lines` that utilizes vim.api.nvim_buf_attach(buf, false, {on_lines = on_lines }) and the "10" function so that it can update the selection (positions) in a current buffer when some text is modified. (Do I need a mapping for the filename to the buffer?)


You should pay attention to the current setId if you want to directly remove it. 
It would make the current selection set with the known set ID wrong since the set ID no longer refers to the nth selection set.


To make functions 10 and 11 clearer, here is an example:
```

# There are two selection sets that range from 89 lines to 92 lines and 94 lines to 98 lines

89 --------
90
91
92 --------


94 --------
95 
96 
97 
98 --------

# if a new line added after 90

89 --------
90
91 +++++++++
92
93 --------


95 --------
96 
97 
98 
99 --------



# The first selection set should update to [89 to 93] and 
# The second selection set should update to [95 to 99] 

```

Now please output the file "selection_manager.lua" wrapped in 
``` code ``` 
coding blocks.  

