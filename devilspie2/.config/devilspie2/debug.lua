debug_print("Application: " .. get_application_name())
debug_print("Window: " .. get_window_name())

unshade()
undecorate_window()

if(get_application_name()=="Alacritty") then
  maximize()
  set_on_top()
  focus()

  --change_workspace(2)
  --set_window_workspace(2)
  --set_window_fullscreen(true)
end

if(get_application_name()=="emacs") then
  maximize()
  set_on_top()
  focus()
  --set_window_fullscreen(true)
end
