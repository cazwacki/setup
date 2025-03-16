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
  fill-column 80)

;; Automatically reread from disk if the underlying file changes
(setopt auto-revert-avoid-polling t)
(global-auto-revert-mode 1)

(electric-pair-mode 1)                ;; Auto-close delimiters
(delete-selection-mode 1)             ;; Delete highlighted region on type
(show-paren-mode 1)                   ;; See matching character pairs

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
  (setq-default win-switch-idle-time 5))
(global-set-key "\C-xo" 'win-switch-enter)

;; spatial-navigate: directional navigation through whitespace
(use-package spatial-navigate)
(global-set-key (kbd "<M-u>") 'spatial-navigate-backward-vertical-bar)
(global-set-key (kbd "<M-e>") 'spatial-navigate-forward-vertical-bar)
(global-set-key (kbd "<M-n>") 'spatial-navigate-backward-horizontal-bar)
(global-set-key (kbd "<M-i>") 'spatial-navigate-forward-horizontal-bar)

;;;;;;;;;;;;;;;;
;; APPEARANCE ;;
;;;;;;;;;;;;;;;;

;; DISABLE SOME  annoying UI elements
(menu-bar-mode -1)
(tool-bar-mode -1)
(blink-cursor-mode -1)
(scroll-bar-mode -1)

(setopt line-number-mode t)           ;; Show current line in modeline
(setopt column-number-mode t)         ;; Show column as well
(pixel-scroll-precision-mode)         ;; Smooth scrolling

;; built-in and fastest option these days
(global-display-line-numbers-mode 1)
(setopt display-line-numbers-width 3) ;; Set a minimum width

;; doom-themes: quality themes and some magic
(use-package doom-themes
  :config
  ;; Global settings (defaults)
  (setq-default
    doom-themes-enable-bold t    
    doom-themes-enable-italic t) 
  (load-theme 'doom-challenger-deep t)
  ;; Enable custom neotree theme (nerd-icons must be installed!)
  (doom-themes-neotree-config)
  ;; Corrects (and improves) org-mode's native fontification.
  (doom-themes-org-config))

;; Use `nerd-icons' as icon backend for relevant packages
(use-package nerd-icons)

;; which-key: shows a popup of available keybindings when typing a long key
;; sequence (e.g. C-x ...)
(use-package which-key
  :config
  (which-key-mode))

;; dimmer: dim all windows that aren't the currently selected one
(use-package dimmer)
(dimmer-configure-which-key)
(dimmer-configure-helm)
(dimmer-mode t)
(setq-default dimmer-fraction 0.4)

;; neotree: simple, pretty file navigation
(use-package neotree
  :after (nerd-icons)
  :config
  ;; disable line numbers for neotree
  (add-hook 'neo-after-create-hook (lambda (&optional dummy) (display-line-numbers-mode -1)))
  (setq-default
    neo-theme (if (display-graphic-p) 'nerd-icons 'arrow)
    neo-show-hidden-files t
    neo-autorefresh t
    neo-window-width 40
    neo-hide-cursor t)
  (global-set-key [f8] 'neotree-toggle)
  (neotree-toggle))

;; centaur-tabs: easy, intuitive tabs per window
(use-package centaur-tabs
  :demand
  :init
  (setq-default centaur-tabs-enable-key-bindings t)
  :config
  ;; enable and cycle through visible tabs
  (centaur-tabs-mode t)
  (setq-default centaur-tabs-cycle-scope 'tabs)
  ;; order tabs alphabetically
  (centaur-tabs-enable-buffer-alphabetical-reordering)
  (setq-default centaur-tabs-adjust-buffer-order t)
  (setq-default
    centaur-tabs-set-icons t             ;; display icons on tabs
    centaur-tabs-icon-type 'nerd-icons   ;; set icons to nerd-icons
    centaur-tabs-set-modified-marker t   ;; display modification indicator
    centaur-tabs-set-close-button nil    ;; hide close button
    centaur-tabs-show-new-tab-button nil ;; hide new tab button
    )
  :bind
  ("C-<tab>" . centaur-tabs-backward)
  ("C-S-<tab>" . centaur-tabs-forward))
