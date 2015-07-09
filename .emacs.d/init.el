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
 '(indicate-buffer-boundaries (quote left))
 '(indicate-empty-lines t)
 '(inhibit-startup-screen t)
 '(make-backup-files nil)
 '(safe-local-variable-values (quote ((test-case-name . twisted\.test\.test_internet))))
 '(save-place t nil (saveplace))
 '(save-place-file "~/.emacs.d/saveplace")
 '(scroll-bar-mode nil)
 '(scroll-conservatively 10000)
 '(scroll-margin 5)
 '(send-mail-function (quote mailclient-send-it))
 '(show-paren-mode t)
 '(show-trailing-whitespace t)
 '(swbuff-clear-delay 2)
 '(text-mode-hook (quote (turn-on-auto-fill text-mode-hook-identify)))
 '(tool-bar-mode nil)
 '(tramp-mode t)
 '(uniquify-buffer-name-style (quote forward) nil (uniquify))
 '(user-mail-address "andy@groveronline.com")
 '(visual-line-fringe-indicators (quote (left-curly-arrow nil)))
 '(which-function-mode t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :stipple nil :background "black" :foreground "white" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 113 :width normal :foundry "unknown" :family "Inconsolata")))))

(setq load-path (cons "~/.emacs.d/lisp" load-path))
(setq grep-highlight-matches t)
(setq auto-save-list-file-name nil) ; Don't want any .saves files
(setq read-buffer-completion-ignore-case t)
(setq read-file-name-completion-ignore-case t)

(require 'package)
(package-initialize)
(add-to-list 'package-archives
             '("marmalade" . "http://marmalade-repo.org/packages/") t)
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

(defun my-scroll-up-line ()
  (interactive)
  (scroll-up-line)
;;  (next-line)
  )

(defun my-scroll-down-line ()
  (interactive)
  (scroll-down-line)
;;  (previous-line)
  )

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

;; clean up unused buffers
(require 'midnight)

(defun my-isearch-word-at-point ()
  (interactive)
  (call-interactively 'isearch-forward-regexp))

(defun my-isearch-yank-word-hook ()
  (when (equal this-command 'my-isearch-word-at-point)
    (let ((string (concat "\\_<"
                          (buffer-substring-no-properties
                           (progn (skip-syntax-backward "w_") (point))
                           (progn (skip-syntax-forward "w_") (point)))
                          "\\_>")))
      (if (and isearch-case-fold-search
               (eq 'not-yanks search-upper-case))
          (setq string (downcase string)))
      (setq isearch-string string
            isearch-message
            (concat isearch-message
                    (mapconcat 'isearch-text-char-description
                               string ""))
            isearch-yank-flag t)
      ;;(isearch-search-and-update)
      )))

(add-hook 'isearch-mode-hook 'my-isearch-yank-word-hook)

(defun git-grep (search)
  "git-grep the entire current repo"
  (interactive (list (read-string "Search for: " (current-word))))
  (grep-find (concat "git --no-pager grep --no-color -n -- \"" search "\" `git rev-parse --show-toplevel`")))

(defun git-grep-current (search)
  "git-grep from the current directory"
  (interactive (list (read-string "Search for: " (current-word))))
  (grep-find (concat "git --no-pager grep --no-color -n -- \"" search "\"")))

;; qemu style setup
(defconst qemu-c-style
  '((indent-tabs-mode . nil)
    (c-basic-offset . 4)
    (tab-width . 8)
    (c-comment-only-line-offset . 0)
    (c-hanging-braces-alist . ((substatement-open before after)))
    (c-offsets-alist . ((statement-block-intro . +)
                        (substatement-open . 0)
                        (label . 0)
                        (statement-cont . +)
                        (innamespace . 0)
                        (inline-open . 0)
                        ))
    (c-hanging-braces-alist .
                            ((brace-list-open)
                             (brace-list-intro)
                             (brace-list-entry)
                             (brace-list-close)
                             (brace-entry-open)
                             (block-close . c-snug-do-while)
                             ;; structs have hanging braces on open
                             (class-open . (after))
                             ;; ditto if statements
                             (substatement-open . (after))
                             ;; and no auto newline at the end
                             (class-close)
                             ))
    )
  "QEMU C Programming Style")

(c-add-style "qemu" qemu-c-style)

(defun maybe-qemu-style ()
  (when (and buffer-file-name
	     (string-match "/qemu/" buffer-file-name))
    (c-set-style "qemu")))

(add-hook 'c-mode-hook 'maybe-qemu-style)

;; Flycheck for rust
(require 'flycheck)

(add-hook 'rust-mode-hook (lambda () (flycheck-mode)))

(add-hook 'prog-mode-hook
	  (lambda ()
	    (hs-minor-mode t)
	    (visual-line-mode t)
	    (superword-mode t)
	    ))

(add-hook 'grep-mode-hook
	  (lambda ()
	    (local-set-key (kbd "M-RET") 'compilation-display-error)
	    ))

(unless (version< emacs-version "24.4")
  (global-prettify-symbols-mode))

(electric-indent-mode -1)

;; ins/del lines before/after
(global-set-key "\C-p" 'insert-line-before)
(global-set-key "\C-n" 'insert-line-after)
(global-set-key "\M-p" 'kill-line-before)
(global-set-key "\M-n" 'kill-line-after)

;; swbuff keys
(global-set-key [(control tab)] 'swbuff-switch-to-next-buffer)
(global-set-key "\M-q" 'swbuff-switch-to-previous-buffer)
(global-set-key "\M-w" 'swbuff-kill-this-buffer)
(global-set-key "\M-e" 'swbuff-switch-to-next-buffer)

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
(global-set-key (kbd "M-<down>") 'my-scroll-up-line)
(global-set-key (kbd "M-<up>") 'my-scroll-down-line)
(global-set-key (kbd "M-c") 'comment-region)
(global-set-key (kbd "s-c") 'uncomment-region)

;; isearch
(if (version< emacs-version "24.4")
    (global-set-key "\C-f" 'my-isearch-word-at-point)
  (global-set-key "\C-f" 'isearch-forward-symbol-at-point))

;; gg keys
(global-set-key "\M-s" 'git-grep)
(global-set-key "\M-d" 'git-grep-current)
