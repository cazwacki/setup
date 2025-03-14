;; run nerd-icons-install-fonts on first setup, then reload
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

(setq backup-directory-alist `(("." . ,(concat user-emacs-directory "backups"))))
(setq backup-by-copying t)
(setq auto-save-file-name-transforms `(("." . ,(concat user-emacs-directory "autosaves"))))

;; quit Emacs directly even if there are running processes
(setq confirm-kill-processes nil)

;; the toolbar is just a waste of valuable screen estate
(when (fboundp 'tool-bar-mode)
  (tool-bar-mode -1))

;; the blinking cursor is nothing, but an annoyance
(blink-cursor-mode -1)

;; DISABLE splash screen
(setq inhibit-startup-screen t)

;; Automatically reread from disk if the underlying file changes
(setopt auto-revert-avoid-polling t)

(setopt line-number-mode t)           ;; Show current line in modeline
(setopt column-number-mode t)         ;; Show column as well
(pixel-scroll-precision-mode)         ;; Smooth scrolling

;; built-in and fastest option these days
(global-display-line-numbers-mode 1)
(setopt display-line-numbers-width 3) ;; Set a minimum width
 
;; default indent to 2 spaces
(setq-default indent-tabs-mode nil)   ;; don't use tabs to indent
(setq-default tab-width 2)            ;; but maintain correct appearance

;; Newline at end of file
(setq require-final-newline t)

;; Wrap lines at 80 characters
(setq-default fill-column 80)

(electric-pair-mode 1)                ;; Auto-close delimiters
(delete-selection-mode 1)             ;; Delete highlighted region on type
(show-paren-mode 1)                   ;; See matching character pairs           

;;; use-package setup
(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(require 'use-package)

(setq use-package-always-ensure t)
(setq use-package-verbose t)

;; Easily resize and cycle through frames, replacing the
;; buffer swap command -- rebound for colemak
(use-package win-switch
  :config
  (win-switch-set-keys '("u") 'up)
  (win-switch-set-keys '("e") 'down)
  (win-switch-set-keys '("n") 'left)
  (win-switch-set-keys '("i") 'right)
  (win-switch-set-keys '("U") 'enlarge-vertically)
  (win-switch-set-keys '("E") 'shrink-vertically)
  (win-switch-set-keys '("N") 'shrink-horizontally)
  (win-switch-set-keys '("I") 'enlarge-horizontally)
  (win-switch-set-keys '("h") 'next-window)
  (win-switch-set-keys '("o") 'previous-window)
  (win-switch-set-keys '(" ") 'other-frame)
  (win-switch-set-keys '([return]) 'exit)
  (win-switch-set-keys '("d") 'delete-window)
  (win-switch-set-keys '("-") 'split-vertically)
  (win-switch-set-keys '("|") 'split-horizontally)
  (setq win-switch-idle-time 5))
(global-set-key "\C-xo" 'win-switch-enter)

;; which-key: shows a popup of available keybindings when typing a long key
;; sequence (e.g. C-x ...)
(use-package which-key
  :config
  (which-key-mode))

(use-package dimmer)
(dimmer-configure-which-key)
(dimmer-configure-helm)
(dimmer-mode t)
(setq dimmer-fraction 0.4)

;; spatial-navigate: directional navigation through whitespace
(use-package spatial-navigate)
(global-set-key (kbd "<M-u>") 'spatial-navigate-backward-vertical-bar)
(global-set-key (kbd "<M-e>") 'spatial-navigate-forward-vertical-bar)
(global-set-key (kbd "<M-n>") 'spatial-navigate-backward-horizontal-bar)
(global-set-key (kbd "<M-i>") 'spatial-navigate-forward-horizontal-bar)

;; Use `nerd-icons' as Neotree's icon backend
(use-package nerd-icons)
(use-package neotree
  :after (nerd-icons))
(global-set-key [f8] 'neotree-toggle)
(setq neo-theme (if (display-graphic-p) 'nerd-icons 'arrow))
(setq-default neo-show-hidden-files t)
(neotree-toggle)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes '(modus-vivendi))
 '(package-selected-packages '(nerd-icons use-package)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
