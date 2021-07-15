;;; keybindings.el -*- lexical-binding: t; -*-

;; window switching
(map!
 "C-l" #'evil-window-right
 "C-h" #'evil-window-left
 "C-k" #'evil-window-up
 "C-j" #'evil-window-down
 "C-[" #'window-swap-states
 )

;; toggle display number
(map! :leader 
      :desc "set number" "n u" #'menu-bar--display-line-numbers-mode-absolute 
      :desc "set relative number" "r n u" #'menu-bar--display-line-numbers-mode-relative 
       )
