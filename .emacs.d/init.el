(setq custom-file "~/.emacs.d/custom.el")
(load custom-file 'noerror)

(setq load-path (cons "~/.emacs.d/lisp" load-path))
(setq grep-highlight-matches t)
(setq auto-save-list-file-name nil) ; Don't want any .saves files
(setq read-buffer-completion-ignore-case t)
(setq read-file-name-completion-ignore-case t)

(require 'package)
(package-initialize)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/") t)
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
  (other-window (- times)))

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

(use-package cycbuf
  :ensure t
  :bind* (("M-q" . cycbuf-switch-to-previous-buffer)
          ("M-e" . cycbuf-switch-to-next-buffer)
	  ("M-w" . kill-current-buffer)
	  ))

(require 'delight)

(require 'ido)
(ido-mode t)
(setq ido-enable-flex-matching t)

(require 'uniquify)

(use-package expand-region
  :bind (("C-=" . er/expand-region)
         ("C--" . er/contract-region)))

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
			(set-variable 'show-trailing-whitespace t)
			))

;; Flycheck for rust
(add-hook 'flycheck-mode-hook
		  (lambda ()
			(flycheck-rust-setup)
			))

(use-package lsp-mode
  :ensure t
  :hook (rust-mode . lsp-deferred)
  :config
  (add-hook 'lsp-mode-hook
            (lambda ()
	      ;;	    (lsp-ui-mode)
              (yas-minor-mode)
              (delight 'yas-minor-mode nil t))))

(add-hook 'rust-mode-hook
		  (lambda ()
			(flycheck-mode)
			(prettify-symbols-mode)
			(rust-enable-format-on-save)
			(setq indent-tabs-mode nil)
			(delight 'eldoc-mode nil "eldoc")
			(delight 'company-mode nil "company")
			(delight 'lsp-lens-mode nil "lsp-lens")
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
			 )))

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

(electric-indent-mode -1)

(require 'move-text)

(use-package copilot
  :bind (("s-z"       . copilot-mode)
         ("C-S-n"     . copilot-next-completion)
         ("C-S-p"     . copilot-previous-completion)
         ("C-S-a"     . copilot-accept-completion)
         ("C-S-<right>" . copilot-accept-completion-by-word)))

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
(keymap-global-set "s-q" 'other-window-back)
(keymap-global-set "s-w" 'ellama-transient-main-menu)
(keymap-global-set "s-e" 'other-window)
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

(defun query-replace-in-open-buffers (from to)
  "Run `query-replace' for FROM → TO across all file-visiting buffers."
  (interactive "sQuery replace: \nsWith: ")
  (cl-loop for buf in (buffer-list)
           when (buffer-file-name buf)
           do (with-current-buffer buf
                (save-excursion
                  (save-match-data
                    (goto-char (point-min))
                    (query-replace from to))))))
