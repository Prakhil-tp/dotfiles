debug_print("Application: " .. get_application_name())
debug_print("Window: " .. get_window_name())

unshade()
undecorate_window()

if(get_application_name()=="Alacritty") then
  set_window_workspace(2)
  maximize()
  set_on_top()
  change_workspace(2)
  focus()
  --set_window_fullscreen(true)
end



