;; run nerd-icons-install-fonts on first setup, then reload

;; setup melpa and use-package
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

(unless (package-installed-p 'use-package)
  (package-install 'use-package))
(require 'use-package)

;; keep customizations out of init
(setq custom-file (concat user-emacs-directory "custom.el"))
(when (file-exists-p custom-file)
  (load custom-file))

;;;;;;;;;;;;;;;;
;; FUNCTIONAL ;;
;;;;;;;;;;;;;;;;

(setq-default
  default-directory "~/"
  ;; always install packages that aren't present
  use-package-always-ensure t
  use-package-verbose t
  ;; backups don't clutter the file tree
  create-lockfiles nil
  backup-directory-alist `(("." . ,(concat user-emacs-directory "backups")))
  backup-by-copying t
  delete-old-versions t
  ;; quit Emacs directly even if there are running processes
  confirm-kill-processes nil
  ;; disable annoying startup stuff
  inhibit-startup-screen t
  initial-scratch-message nil
  ;; newline at end of file
  require-final-newline t
  ;; use two spaces for indentation
  indent-tabs-mode nil
  tab-width 2
  ;; wrap lines at 80 charaters
  fill-column 80
  ;; replace yes/no prompts with y/n
  use-short-answers t)

;; Automatically reread from disk if the underlying file changes
(setopt auto-revert-avoid-polling t)
(global-auto-revert-mode 1)

(electric-pair-mode 1)                ;; Auto-close delimiters
(delete-selection-mode 1)             ;; Delete highlighted region on type
(show-paren-mode 1)                   ;; See matching character pairs

;; Easily resize and cycle through frames, replacing the
;; buffer swap command -- rebound for colemak
(use-package win-switch
  :custom
  (win-switch-idle-time 5)
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
  (global-set-key "\C-xo" 'win-switch-enter))

;; spatial-navigate: directional navigation through whitespace
(use-package spatial-navigate
  :config
  (global-set-key (kbd "<M-u>") 'spatial-navigate-backward-vertical-bar)
  (global-set-key (kbd "<M-e>") 'spatial-navigate-forward-vertical-bar)
  (global-set-key (kbd "<M-n>") 'spatial-navigate-backward-horizontal-bar)
  (global-set-key (kbd "<M-i>") 'spatial-navigate-forward-horizontal-bar))

;; scroll-on-jump: selectively add smooth scrolling to jumping commands
(use-package scroll-on-jump
  :custom
  (scroll-on-jump-smooth t)
  (scroll-on-jump-duration 0.4)
  (scroll-on-jump-curve-power 4.0)
  :config
  ;; define actions to smooth
  (scroll-on-jump-advice-add beginning-of-buffer)
  (scroll-on-jump-advice-add end-of-buffer)
  (scroll-on-jump-with-scroll-advice-add scroll-up)
  (scroll-on-jump-with-scroll-advice-add scroll-down)
  (scroll-on-jump-advice-add forward-paragraph)
  (scroll-on-jump-advice-add backward-paragraph)
  (scroll-on-jump-with-scroll-advice-add recenter-top-bottom))

;; avy: tree-based jump to char in visible buffer
(use-package avy
  :custom
  (avy-keys '(?a ?r ?s ?t ?n ?e ?i ?o)) ;; only select with colemak home row
  (avy-style 'at-full)                  ;; obscure text on search to prevent text shifts
  (avy-all-windows t)                   ;; use all windows in search jump
  :config
  (global-set-key (kbd "C-'") 'avy-goto-char)
  (global-set-key (kbd "C-\"") 'avy-goto-char-timer)
  (global-set-key (kbd "C-:") 'avy-goto-word-0))

;; ivy / counsel: enhanced completion for common emacs commands
(use-package counsel
  :custom
  (ivy-wrap t)
  (ivy-height 10)
  :config
  (ivy-mode 1)
  (global-set-key (kbd "C-c C-r") 'ivy-resume)
  ;; ivy-based interfaces for standard commands
  (global-set-key (kbd "C-s") 'swiper-isearch)
  (global-set-key (kbd "M-x") 'counsel-M-x)
  (global-set-key (kbd "C-x C-f") 'counsel-find-file)
  (global-set-key (kbd "M-y") 'counsel-yank-pop)
  (global-set-key (kbd "<f1> f") 'counsel-describe-function)
  (global-set-key (kbd "<f1> v") 'counsel-describe-variable)
  (global-set-key (kbd "<f1> l") 'counsel-find-library)
  (global-set-key (kbd "<f2> i") 'counsel-info-lookup-symbol)
  (global-set-key (kbd "<f2> u") 'counsel-unicode-char)
  (global-set-key (kbd "<f2> j") 'counsel-set-variable)
  (global-set-key (kbd "C-x b") 'ivy-switch-buffer)
  (global-set-key (kbd "C-c v") 'ivy-push-view)
  (global-set-key (kbd "C-c V") 'ivy-pop-view)
  ;; ivy-based interfaces for shell tools
  (global-set-key (kbd "C-x l") 'counsel-locate)
  (global-set-key (kbd "C-c j") 'counsel-file-jump))

;;;;;;;;;;;;;;;;
;; APPEARANCE ;;
;;;;;;;;;;;;;;;;

;; Disable some annoying UI elements
(menu-bar-mode -1)
(tool-bar-mode -1)
(blink-cursor-mode -1)
(scroll-bar-mode -1)

(setopt line-number-mode t)           ;; Show current line in modeline
(setopt column-number-mode t)         ;; Show column as well
(pixel-scroll-precision-mode 1)       ;; Smooth scrolling

;; built-in and fastest option these days
(global-display-line-numbers-mode 1)
(setopt display-line-numbers-width 3) ;; Set a minimum width

;; Use `nerd-icons' as icon backend for relevant packages
(use-package nerd-icons)

;; which-key: shows a popup of available keybindings when typing a long key
;; sequence (e.g. C-x ...)
(use-package which-key
  :config
  (which-key-mode))

;; neotree: simple, pretty file navigation
(use-package neotree
  :after (nerd-icons)
  :custom
  (neo-theme (if (display-graphic-p) 'nerd-icons 'arrow))
  (neo-show-hidden-files t)
  (neo-autorefresh t)
  (neo-window-width 40)
  (neo-hide-cursor t)
  :config
  ;; disable line numbers for neotree
  (add-hook 'neo-after-create-hook (lambda (&optional dummy) (display-line-numbers-mode -1)))
  (global-set-key [f8] 'neotree-toggle)
  (neotree-toggle))

;; centaur-tabs: easy, intuitive tabs per window
(use-package centaur-tabs
  :demand
  :init
  (setq-default centaur-tabs-enable-key-bindings t)
  :custom
  (centaur-tabs-cycle-scope 'tabs)       ;; enable and cycle through visible tabs
  (centaur-tabs-adjust-buffer-order t)   
  (centaur-tabs-set-icons t)             ;; display icons on tabs
  (centaur-tabs-icon-type 'nerd-icons)   ;; set icons to nerd-icons
  (centaur-tabs-set-modified-marker t)   ;; display modification indicator
  (centaur-tabs-set-close-button nil)    ;; hide close button
  (centaur-tabs-show-new-tab-button nil) ;; hide new tab button
  :config
  (centaur-tabs-mode t)
  (centaur-tabs-enable-buffer-alphabetical-reordering) ;; order tabs alphabetically
  :bind
  ("C-<tab>" . centaur-tabs-backward)
  ("C-<iso-lefttab>" . centaur-tabs-forward))

;; doom-themes: quality themes and some magic
(use-package doom-themes
  :custom
  (doom-themes-enable-bold t)
  (doom-themes-enable-italic t)
  :config
  (load-theme 'doom-challenger-deep t)
  (doom-themes-neotree-config)        ;; Enable custom neotree theme (nerd-icons must be installed!)
  (doom-themes-org-config))           ;; Corrects (and improves) org-mode's native fontification.

;; dimmer: dim all windows that aren't the currently selected one
(use-package dimmer
  :custom
  (dimmer-fraction 0.4)
  :config
  (dimmer-configure-which-key)
  (dimmer-mode t))

;; mini-frame: show minibuffer with another frame
(use-package mini-frame
  :demand
  :custom
  mini-frame-show-parameters
  '((top . 50)
    (width . 0.7)
    (left . 0.5))
  :config
  (mini-frame-mode))
