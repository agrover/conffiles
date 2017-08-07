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
    (cargo move-text rust-mode multicolumn flycheck-rust)))
 '(prettify-symbols-unprettify-at-point (quote right-edge))
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
 '(tramp-mode t)
 '(uniquify-buffer-name-style (quote forward) nil (uniquify))
 '(user-mail-address "andy@groveronline.com")
 '(visual-line-fringe-indicators (quote (left-curly-arrow nil))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :stipple nil :background "black" :foreground "white" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 158 :width normal :foundry "PfEd" :family "Inconsolata")))))

(setq load-path (cons "~/.emacs.d/lisp" load-path))
(setq grep-highlight-matches t)
(setq auto-save-list-file-name nil) ; Don't want any .saves files
(setq read-buffer-completion-ignore-case t)
(setq read-file-name-completion-ignore-case t)

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

(require 'multicolumn)
(multicolumn-global-mode 1)

(require 'ido)
(ido-mode t)
(setq ido-enable-flex-matching t)

(require 'uniquify)

;; clean up unused buffers
(require 'midnight)

(defun git-grep (search)
  "git-grep the entire current repo"
  (interactive (list (read-string "Search for: " (current-word))))
  (grep-find (concat "git --no-pager grep --no-color -n -- \"" search "\" `git rev-parse --show-toplevel`")))

(defun git-grep-current (search)
  "git-grep from the current directory"
  (interactive (list (read-string "Search for: " (current-word))))
  (grep-find (concat "git --no-pager grep --no-color -n -- \"" search "\"")))

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
      ("->"         . ?→)
      ("=>"         . ?⇒)
      (".."         . ?‥)
      ("..."        . ?…)

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

(electric-indent-mode -1)

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
(global-set-key (kbd "M-s-<up>") 'move-text-region-up)
(global-set-key (kbd "M-s-<down>") 'move-text-region-down)

;; isearch
(global-set-key "\C-f" 'isearch-forward-symbol-at-point)

;; gg keys
(global-set-key "\M-s" 'git-grep)
(global-set-key "\M-d" 'git-grep-current)
