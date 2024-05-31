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
3. save the visual selections sets into a place that enables the "records" to be stored (will not be lost when exits Neovim)
4. load the visual selection sets from a place that has just been implemented before.
5. get visual selections by the set IDs.
6. get the current visual selection set ID.
7. get the next visual selection set ID (it should be cycling).
8. remove a visual selection in a selection set.
9. remove a visual selection set and preserve the order between other selection sets. 
10. a function that utilize git, update all the visual selection in all sets according to the git diff. This funciton is expected to run when the user execute a "save".


You should pay attention to the current setId if you want to directly remove it. 
It would make the current selection set with the known set ID wrong since the set ID no longer refers to the nth selection set.

Now please output the file "selection_manager.lua" wrapped in 
``` code ``` 
coding blocks.  
