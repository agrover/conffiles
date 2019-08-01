(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(auto-save-default nil)
 '(backward-delete-char-untabify-method (quote hungry))
 '(column-number-mode t)
 '(cua-keep-region-after-copy t)
 '(cua-mode t nil (cua-base))
 '(desktop-save-mode t)
 '(fill-column 80)
 '(global-prettify-symbols-mode t)
 '(indicate-buffer-boundaries (quote left))
 '(indicate-empty-lines t)
 '(inhibit-startup-screen t)
 '(make-backup-files nil)
 '(midnight-mode t)
 '(org-cycle-emulate-tab nil)
 '(org-support-shift-select t)
 '(package-selected-packages
   (quote
    (yaml-mode go-mode clang-format rg cargo move-text rust-mode multicolumn flycheck-rust)))
 '(prettify-symbols-unprettify-at-point (quote right-edge))
 '(rg-command-line-flags (quote ("--max-columns 1024 --max-count 512")))
 '(rg-custom-type-aliases
   (quote
    (("gn" . "*.gn *.gni")
     ("gyp" . "*.gyp *.gypi")
     ("everything" . "*")
     ("idl" . "*.idl *.webidl"))))
 '(safe-local-variable-values (quote ((test-case-name . twisted\.test\.test_internet))))
 '(save-place t nil (saveplace))
 '(save-place-file "~/.emacs.d/saveplace")
 '(scroll-conservatively 10000)
 '(scroll-margin 5)
 '(send-mail-function (quote mailclient-send-it))
 '(show-paren-mode t)
 '(swbuff-clear-delay 2)
 '(text-mode-hook (quote (turn-on-auto-fill text-mode-hook-identify)))
 '(tool-bar-mode nil)
 '(tramp-default-method "ssh")
 '(tramp-mode t)
 '(uniquify-buffer-name-style (quote forward) nil (uniquify))
 '(user-mail-address "andy@groveronline.com")
 '(visual-line-fringe-indicators (quote (left-curly-arrow nil))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :stipple nil :background "black" :foreground "white" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 181 :width normal :foundry "CYRE" :family "Inconsolata"))))
 '(rust-question-mark-face ((t (:inherit font-lock-builtin-face :foreground "orange red" :weight bold)))))

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

;; use python mode for Cython files
(add-to-list 'auto-mode-alist '("\\.pyx\\'" . python-mode))
(add-to-list 'auto-mode-alist '("\\.pxd\\'" . python-mode))

(setq diff-switches "-u")

(require 'swbuff-x)
(setq swbuff-display-intermediate-buffers t)
(setq swbuff-delay-switch t)
(setq swbuff-this-frame-only nil)

(require 'ido)
(ido-mode t)
(setq ido-enable-flex-matching t)

(require 'uniquify)

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
	    (visual-line-mode t)
	    (set-variable `show-trailing-whitespace t)
	    ))

;; Flycheck for rust
(add-hook 'flycheck-mode-hook #'flycheck-rust-setup)
(add-hook 'rust-mode-hook
	  (lambda ()
	    (flycheck-mode)
	    (rust-enable-format-on-save)
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

(add-hook 'c++-mode-hook
	  (function (lambda ()
	    (add-hook
	     `before-save-hook 'clang-format-buffer nil 'local))))

(electric-indent-mode -1)

(require 'yaml-mode)
(add-to-list 'auto-mode-alist '("\\.yml\\'" . yaml-mode))

(add-hook 'yaml-mode-hook
	  '(lambda ()
	     (define-key yaml-mode-map "\C-m" 'newline-and-indent)))

(require 'move-text)

;; ins/del lines before/after
(global-set-key "\C-p" 'insert-line-before)
(global-set-key "\C-n" 'insert-line-after)
(global-set-key "\M-p" 'kill-line-before)
(global-set-key "\M-n" 'kill-line-after)

;; swbuff keys
(global-set-key [(control tab)] 'swbuff-switch-to-next-buffer)
(global-set-key (kbd "M-q") 'swbuff-switch-to-previous-buffer)
(global-set-key (kbd "M-e") 'swbuff-switch-to-next-buffer)
(global-set-key (kbd "M-w") 'swbuff-kill-this-buffer)

;; misc
(global-set-key "\C-a" 'mark-whole-buffer)
(global-set-key "\C-o" 'ido-find-file)
(global-set-key "\C-t" 'hs-toggle-hiding)
(global-set-key (kbd "C-S-t") 'hs-hide-all)
(global-set-key (kbd "C-M-t") 'hs-show-all)
(global-set-key (kbd "C-b") 'goto-match-paren)
(global-set-key "\C-s" 'isearch-forward-regexp)
(global-set-key (kbd "M-RET") 'completion-at-point)
(global-set-key (kbd "RET") 'newline-and-indent)
(global-set-key [delete] 'delete-forward-char-and-spaces)
(global-set-key [backspace] 'backward-delete-char-untabify)
(global-set-key (kbd "s-d") 'duplicate-line-or-region)
(global-set-key (kbd "s-e") 'other-window)
(global-set-key (kbd "s-q") 'other-window-back)
(global-set-key (kbd "M-<down>") 'scroll-up-line)
(global-set-key (kbd "M-<up>") 'scroll-down-line)
(global-set-key (kbd "C-M-b") 'three-balanced-windows)
(global-set-key (kbd "M-b") 'multicolumn-transpose-windows)
(global-set-key (kbd "M-c") 'comment-region)
(global-set-key (kbd "s-c") 'uncomment-region)
(global-set-key (kbd "s-f") 'fill-region)
(global-set-key (kbd "M-s-<up>") 'move-text-up)
(global-set-key (kbd "M-s-<down>") 'move-text-down)
(global-set-key (kbd "M-s-t") 'transpose-chars)
(global-set-key (kbd "<C-backspace>") 'backward-delete-word)
(global-set-key (kbd "<C-delete>") 'delete-word)
(global-set-key (kbd "s-n") 'flycheck-next-error)

;; isearch
(global-set-key "\C-f" 'isearch-forward-symbol-at-point)

;; gg keys
(global-set-key "\M-a" 'rg-dwim)
(global-set-key "\M-s" 'my-rg-search-all-files)
(global-set-key "\M-d" 'my-rg-search-all-curdir-files)

(defun query-replace-in-open-buffers (arg1 arg2)
  "query-replace in open files"
  (interactive "sQuery Replace in open Buffers: \nsquery with: ")
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
