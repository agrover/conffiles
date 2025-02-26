(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(auto-save-default nil)
 '(backward-delete-char-untabify-method 'hungry)
 '(column-number-mode t)
 '(company-idle-delay 0.7)
 '(cua-keep-region-after-copy t)
 '(cua-mode t nil (cua-base))
 '(cycbuf-buffer-sort-function 'cycbuf-sort-by-recency)
 '(desktop-save-mode t)
 '(fill-column 80)
 '(global-auto-revert-mode t)
 '(global-eldoc-mode nil)
 '(indicate-buffer-boundaries 'left)
 '(indicate-empty-lines t)
 '(inhibit-startup-screen t)
 '(isearch-lazy-count t)
 '(kill-whole-line t)
 '(lsp-enable-file-watchers nil)
 '(lsp-rust-analyzer-display-chaining-hints t)
 '(lsp-rust-analyzer-display-closure-return-type-hints t)
 '(lsp-rust-analyzer-display-lifetime-elision-hints-enable "skip_trivial")
 '(lsp-rust-analyzer-display-parameter-hints t)
 '(lsp-rust-analyzer-display-reborrow-hints "always")
 '(lsp-ui-doc-delay 0.7)
 '(make-backup-files nil)
 '(midnight-mode t)
 '(ns-alternate-modifier 'super)
 '(ns-command-modifier 'meta)
 '(org-cycle-emulate-tab nil)
 '(org-replace-disputed-keys t)
 '(org-support-shift-select t)
 '(package-selected-packages
   '(terraform-mode magit ace-window xref delight jinja2-mode typescript-mode
					minions strace-mode lua-mode salt-mode use-package lsp-ui
					yasnippet company clang-format+ expand-region smartparens
					rainbow-delimiters lsp-mode cycbuf dockerfile-mode rust-mode
					markdown-mode yaml-mode go-mode clang-format rg move-text
					multicolumn flycheck-rust ripgrep))
 '(prettify-symbols-unprettify-at-point 'right-edge)
 '(python-indent-offset 4)
 '(rg-command-line-flags '("--max-columns 1024 --max-count 512 -g '!submodules'"))
 '(rg-custom-type-aliases
   '(("gn" . "*.gn *.gni") ("gyp" . "*.gyp *.gypi") ("everything" . "*")
	 ("idl" . "*.idl *.webidl")))
 '(rust-rustfmt-switches '("--edition" "2024"))
 '(safe-local-variable-values '((test-case-name . twisted.test.test_internet)))
 '(save-place t nil (saveplace))
 '(save-place-file "~/.emacs.d/saveplace")
 '(scroll-conservatively 10000)
 '(scroll-margin 5)
 '(send-mail-function 'mailclient-send-it)
 '(sentence-end-double-space nil)
 '(show-paren-delay 0)
 '(tab-width 4)
 '(tool-bar-mode nil)
 '(tramp-default-method "ssh")
 '(tramp-mode t)
 '(uniquify-buffer-name-style 'forward nil (uniquify))
 '(user-mail-address "andy@groveronline.com")
 '(visual-line-fringe-indicators '(left-curly-arrow nil)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :stipple nil :background "black" :foreground "white" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight regular :height 98 :width normal :foundry "PfEd" :family "DejaVu Sans Mono"))))
 '(cycbuf-current-face ((t (:background "gray41" :weight bold))))
 '(cycbuf-header-face ((t (:foreground "DodgerBlue1" :weight bold))))
 '(rainbow-delimiters-base-error-face ((t (:inherit rainbow-delimiters-base-face :foreground "red"))))
 '(rainbow-delimiters-depth-1-face ((t (:inherit rainbow-delimiters-base-face :foreground "white"))))
 '(rainbow-delimiters-depth-2-face ((t (:inherit rainbow-delimiters-base-face :foreground "deep sky blue"))))
 '(rainbow-delimiters-depth-3-face ((t (:inherit rainbow-delimiters-base-face :foreground "yellow"))))
 '(rainbow-delimiters-depth-4-face ((t (:inherit rainbow-delimiters-base-face :foreground "burlywood"))))
 '(rainbow-delimiters-depth-5-face ((t (:inherit rainbow-delimiters-base-face :foreground "medium sea green"))))
 '(rainbow-delimiters-depth-6-face ((t (:inherit rainbow-delimiters-base-face :foreground "blue violet"))))
 '(rainbow-delimiters-depth-7-face ((t (:inherit rainbow-delimiters-base-face :foreground "khaki"))))
 '(rainbow-delimiters-depth-8-face ((t (:inherit rainbow-delimiters-base-face :foreground "green1"))))
 '(rainbow-delimiters-depth-9-face ((t (:inherit rainbow-delimiters-base-face :foreground "light sea green"))))
 '(rust-question-mark ((t (:inherit font-lock-builtin-face :foreground "orange red" :weight bold)))))

(setq load-path (cons "~/.emacs.d/lisp" load-path))
(setq grep-highlight-matches t)
(setq auto-save-list-file-name nil) ; Don't want any .saves files
(setq read-buffer-completion-ignore-case t)
(setq read-file-name-completion-ignore-case t)

(defalias 'yes-or-no-p 'y-or-n-p)

(require 'package)
(package-initialize)
(add-to-list 'package-archives
             '("melpa" . "http://melpa.org/packages/") t)
(unless package-archive-contents
  (package-refresh-contents))

;; http://www.emacswiki.org/emacs/SmoothScrolling
(setq mouse-wheel-scroll-amount '(1 ((shift) . 1)))
(setq mouse-wheel-progressive-speed t)

;; enable commands I use
(put 'downcase-region 'disabled nil)
(put 'upcase-region 'disabled nil)

;; Linux mode for C
(setq c-default-style
      '((c-mode . "linux") (other . "gnu")))

(defun duplicate-line-or-region (arg)
  "Duplicates the current line or region ARG times.
If there's no region, the current line will be duplicated. However, if
there's a region, all lines that region covers will be duplicated."
  (interactive "p")
  (let (beg end (origin (point)))
    (if (and mark-active (> (point) (mark)))
        (exchange-point-and-mark))
    (setq beg (line-beginning-position))
    (if mark-active
        (exchange-point-and-mark))
    (setq end (line-end-position))
    (let ((region (buffer-substring-no-properties beg end)))
      (dotimes (i arg)
        (goto-char end)
        (newline)
        (insert region)
        (setq end (point)))
      (goto-char (+ origin (* (length region) arg) arg)))))

(defun delete-word (arg)
  "Delete characters forward until encountering the end of a word.
With argument, do this that many times."
  (interactive "p")
  (if (use-region-p)
      (delete-region (region-beginning) (region-end))
    (delete-region (point) (progn (forward-word arg) (point)))))

(defun backward-delete-word (arg)
  "Delete characters backward until encountering the end of a word.
With argument, do this that many times."
  (interactive "p")
  (delete-word (- arg)))

(dolist (cmd '(delete-word backward-delete-word))
  (put cmd 'CUA 'move))

(defun insert-line-before (times)
  (interactive "p")
  (save-excursion
    (forward-line -1)
    (end-of-line)
    (open-line times)))

(defun insert-line-after (times)
  (interactive "p")
  (save-excursion
    (end-of-line)
    (open-line times)))

(defun kill-line-before (times)
  (interactive "p")
  (save-excursion
    (beginning-of-line)
    (kill-line (- times))))

(defun kill-line-current (times)
  (interactive "p")
  (beginning-of-visual-line)
  (kill-line times))

(defun kill-line-after (times)
  (interactive "p")
  (save-excursion
    (forward-line)
    (kill-line times)))

(defun delete-forward-char-and-spaces (&optional arg)
  (interactive "p")
  (if (eolp)
      (progn
		(delete-forward-char arg)
		(delete-horizontal-space))
    (delete-forward-char arg)))

(defun other-window-back (times)
  (interactive "p")
  (other-window (- times))
  )

(defun three-balanced-windows ()
  "Make three equal-width windows"
  (interactive)
  (delete-other-windows)
  (split-window-right)
  (split-window-right)
  (balance-windows))

(defun goto-match-paren (arg)
  "Go to the matching parenthesis if on parenthesis. Else go to the
   opening parenthesis one level up."
  (interactive "p")
  (cond ((looking-at "\\s\(") (forward-list 1))
		(t
		 (backward-char 1)
		 (cond ((looking-at "\\s\)")
				(forward-char 1) (backward-list 1))
			   (t
				(while (not (looking-at "\\s("))
				  (backward-char 1)
				  (cond ((looking-at "\\s\)")
						 (message "->> )")
						 (forward-char 1)
						 (backward-list 1)
						 (backward-char 1)))
				  ))))))

(require 'yaml-mode)

(add-hook 'yaml-mode-hook
		  (lambda ()
			(define-key yaml-mode-map "\C-m" 'newline-and-indent)
			))

;; use python mode for Cython files
(add-to-list 'auto-mode-alist '("\\.pyx\\'" . python-mode))
(add-to-list 'auto-mode-alist '("\\.pxd\\'" . python-mode))
(add-to-list 'auto-mode-alist '("\\.yml\\'" . yaml-mode))
(add-to-list 'auto-mode-alist '("\\.sls\\'" . yaml-mode))

(setq diff-switches "-u")

(require 'cycbuf)

(require 'delight)

(require 'ido)
(ido-mode t)
(setq ido-enable-flex-matching t)

(require 'uniquify)

(require 'expand-region)

;; custom ripgrep search params
(rg-define-search my-rg-search-all-files
  "Don't use default search params"
  :query ask
  :format literal
  :files "everything"
  :dir project)

(rg-define-search my-rg-search-all-curdir-files
  "Don't use default search params"
  :query ask
  :format literal
  :files "everything"
  :dir current)

(rg-define-search my-rg-search-gitdir-files
  "Don't use default search params"
  :query ask
  :format literal
  :files "everything"
  :dir (concat (getenv "HOME") "/git"))

;; clean up unused buffers
(require 'midnight)

;; org mode settings
(setq org-todo-keywords
      (quote ((sequence "TODO(t)"  "NEXT(n)" "|" "DONE(d)")
			  (sequence "REPEAT(r)"  "WAIT(w)"  "|"  "PAUSED(p)" "CANCELLED(c)" )
			  (sequence "IDEA(i)" "MAYBE(y)" "STAGED(s)" "WORKING(k)" "|" "USED(u)")
			  )))

(add-hook 'prog-mode-hook
		  (lambda ()
			(hs-minor-mode t)
			(delight 'hs-minor-mode nil t)
			(rainbow-delimiters-mode t)
			(set-variable `show-trailing-whitespace t)
			))

;; Flycheck for rust
(add-hook 'flycheck-mode-hook
		  (lambda ()
			(flycheck-rust-setup)
			))

(require 'lsp-mode)
(add-hook 'lsp-mode-hook
		  (lambda ()
			;;	    (lsp-ui-mode)
			(yas-minor-mode)
			(delight 'yas-minor-mode nil t)
			))

(add-hook 'rust-mode-hook #'lsp-deferred)

(add-hook 'rust-mode-hook
		  (lambda ()
			(flycheck-mode)
			(prettify-symbols-mode)
			(rust-enable-format-on-save)
			(setq indent-tabs-mode nil)
			(delight 'eldoc-mode nil "eldoc")
			(delight 'company-mode nil "company")
			(delight 'lsp-lens-mode nil "lsp-lens")
			))

(add-hook
 'rust-mode-hook
 (lambda ()
   (setq
    prettify-symbols-alist
    '(
      ("fn"         . ?ƒ)
      ("Fn"         . ?𝘍)
      ;; ("->"         . ?→)
      ;; ("=>"         . ?⇒)
      ;; (".."         . ?‥)
      ;; ("..."        . ?…)

      ;; ("*"          . ?×)
      ;; ("/"          . ?÷)
      )
    )
   )
 )

(add-hook 'grep-mode-hook
		  (lambda ()
			(local-set-key (kbd "M-RET") 'compilation-display-error)
			))

(add-hook 'org-mode-hook
		  (lambda ()
			(define-key org-mode-map "\M-e" nil)
			(flyspell-mode)
			(visual-line-mode)
			(auto-fill-mode -1)
			))

;; (add-hook 'c++-mode-hook
;; 	  (function (lambda ()
;; 	    (add-hook
;; 	     `before-save-hook 'clang-format-buffer nil 'local))))

(add-hook 'c-mode-common-hook #'clang-format+-mode)

(electric-indent-mode -1)

(require 'move-text)

;; ins/del lines before/after
(keymap-global-set "C-p" 'kill-line-before)
(keymap-global-set "s-<delete>" 'kill-line-current)
(keymap-global-set "s-<kp-delete>" 'kill-line-current)  ;; for macos
(keymap-global-set "C-n" 'kill-line-after)
(keymap-global-set "M-p" 'insert-line-before)
(keymap-global-set "M-n" 'insert-line-after)

; override mode-specific definitions
(bind-key* "M-p" 'insert-line-before)
(bind-key* "M-n" 'insert-line-after)

;; cycbuf keys
(bind-key* "M-q" 'cycbuf-switch-to-previous-buffer)
(bind-key* "M-e" 'cycbuf-switch-to-next-buffer)
(bind-key* "M-w" 'kill-current-buffer)

;; misc
(keymap-global-set "C-a" 'mark-whole-buffer)
(keymap-global-set "C-o" 'ido-find-file)
(keymap-global-set "C-t" 'hs-toggle-hiding)
(keymap-global-set "C-S-t" 'hs-hide-all)
(keymap-global-set "C-M-t" 'hs-show-all)
(keymap-global-set "C-b" 'goto-match-paren)
(keymap-global-set "C-s" 'isearch-forward)
(keymap-global-set "M-RET" 'completion-at-point)
(keymap-global-set "RET" 'newline-and-indent)
(keymap-global-set "<delete>" 'delete-forward-char-and-spaces)
(keymap-global-set "<backspace>" 'backward-delete-char-untabify)
(keymap-global-set "s-d" 'duplicate-line-or-region)
(keymap-global-set "s-e" 'other-window)
(keymap-global-set "s-q" 'other-window-back)
(keymap-global-set "M-<down>" 'scroll-up-line)
(keymap-global-set "M-<up>" 'scroll-down-line)
(keymap-global-set "C-M-b" 'three-balanced-windows)
(keymap-global-set "M-b" 'multicolumn-transpose-windows)
(keymap-global-set "M-c" 'comment-region)
(keymap-global-set "s-c" 'uncomment-region)
(keymap-global-set "s-f" 'fill-region)
(keymap-global-set "C-M-s-<up>" 'move-text-up)
(keymap-global-set "C-M-s-<down>" 'move-text-down)
(keymap-global-set "M-s-t" 'transpose-chars)
(keymap-global-set "C-<backspace>" 'backward-delete-word)
(keymap-global-set "C-<delete>" 'delete-word)
(keymap-global-set "s-n" 'flycheck-next-error)
(keymap-global-set "C-=" 'er/expand-region)
(keymap-global-set "C--" 'er/contract-region)
(keymap-global-set "s-r" 'lsp-find-references)

;; macos bs
(keymap-global-set "<end>" 'end-of-line)
(keymap-global-set "<home>" 'beginning-of-line)

;; isearch
(keymap-global-set "C-f" 'isearch-forward-symbol-at-point)

;; gg keys
(keymap-global-set "M-a" 'rg-dwim)
(keymap-global-set "M-s" 'my-rg-search-all-files)
(keymap-global-set "M-d" 'my-rg-search-all-curdir-files)
(keymap-global-set "M-f" 'my-rg-search-gitdir-files)

(defun query-replace-in-open-buffers (arg1 arg2)
  "query-replace in open files"
  (interactive "sQuery Replace in open Buffers: \nswith: ")
  (mapcar
   (lambda (x)
     (find-file x)
     (save-excursion
       (beginning-of-buffer)
       (query-replace arg1 arg2)))
   (delq
    nil
    (mapcar
     (lambda (x)
       (buffer-file-name x))
     (buffer-list)))))
