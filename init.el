;;; -*- lexical-binding: t -*-

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
  make-backup-files nil
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

;; avy: tree-based jump to char in visible buffer
(use-package avy
  :custom
  (avy-keys '(?a ?r ?s ?t ?n ?e ?i ?o)) ;; only select with colemak home row
  (avy-style 'at-full)                  ;; obscure text on search to prevent text shifts
  (avy-all-windows t)                   ;; use all windows in search jump
  :bind
  (("C-'" . avy-goto-char)
   ("C-\"" . avy-goto-char-timer)
   ("C-:" . avy-goto-word-0)))

;; ivy / counsel: enhanced completion for common emacs commands
(use-package counsel
  :custom
  (ivy-wrap t)
  (ivy-height 10)
  (ivy-use-virtual-buffers t)
  :config
  (setq-default enable-recursive-minibuffers t)
  (ivy-mode 1)
  :bind
  (("C-c C-r" . ivy-resume)
  ;; ivy-based interfaces for standard commands
  ("C-s" . swiper-isearch)
  ("M-x" . counsel-M-x)
  ("C-x C-f" . counsel-find-file)
  ("M-y" . counsel-yank-pop)
  ("<f1> f" . counsel-describe-function)
  ("<f1> v" . counsel-describe-variable)
  ("<f1> l" . counsel-find-library)
  ("<f2> i" . counsel-info-lookup-symbol)
  ("<f2> u" . counsel-unicode-char)
  ("<f2> j" . counsel-set-variable)
  ("C-x b" . ivy-switch-buffer)
  ("C-c v" . ivy-push-view)
  ("C-c V" . ivy-pop-view)
  ;; ivy-based interfaces for shell tools
  ("C-x l" . counsel-locate)
  ("C-c j" . counsel-file-jump)))

;; projectile: enable per-project capabilities
(use-package projectile
  :init
  (projectile-mode +1)
  :bind-keymap
  ("C-c p" . projectile-command-map))

;; flycheck: modern syntax checking
(use-package flycheck
  :demand
  :config
  (add-hook 'after-init-hook #'global-flycheck-mode))

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
  (add-hook 'neo-after-create-hook (lambda (&optional _) (display-line-numbers-mode -1)))
  (global-set-key [f8] 'neotree-toggle))

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

;; shell-pop: pop shell at the bottom of the frame
(use-package shell-pop
  :custom
  (shell-pop-full-span t)
  (shell-pop-universal-key "C-c s"))

;; beacon: find your cursor
(use-package beacon
  :custom
  (beacon-blink-when-point-moves-vertically 3)
  (beacon-blink-when-focused t)
  (beacon-color "#D6B4FC")
  (beacon-size 10)
  :config
  (beacon-mode 1))

;;;;;;;;;;;;;;;;;;;;
;; DEFAULT LAYOUT ;;
;;;;;;;;;;;;;;;;;;;;

(neotree-toggle)
