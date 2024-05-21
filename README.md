

# Window Chatter

Interacting with a series of Window floatting in the top-right corner to interact with LLM.

TODO: demo.gif


# Install/Config


### Lazy
{"TATOAO/window_chatter"}


### config

Default using open.ai, "GPT3.5 turbo", you can config this way :









### usages

require("WindowChatter").send_visual_selection_to_window()
require("WindowChatter").remove_window()
require("WindowChatter").output_to_current_cursor()
require("WindowChatter").ouput_to_register()



### keybinding example:

```
-- somewhere in Neovim init



```




# Development

## Set up

Start the project and enter Neovim
```
git clone https://github.com/TATOAO/window_chatter.git
cd window_chatter
nvim -c 'set rtp+=./'
```

execurate the function, for example:
```
lua require("WindowChatter").toggle_window()
```



## Content

.git                      
.log                    
- lua                     
  - WindowChatter         
    - api_integration.lua   
    - display_controller.lua
    - init.lua              
    - logger.lua            
    - output_manager.lua    
    - selection_manager.lua 
    - ui.lua     
    - utils.lua             
    - window_manager.lua  
.gitignore                
README.md

### Cross Functional Flowchart

v1
<img src="./neovim_plugin_window_chatter.drawio.svg" alt="Image Failed" width="700">



# TODO 

1. deleting
2. highlighting issue (buffer enter event not triggered)
