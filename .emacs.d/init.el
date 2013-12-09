(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(auto-save-default nil)
 '(column-number-mode t)
 '(cua-highlight-region-shift-only t)
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
 '(scroll-bar-mode (quote right))
 '(scroll-conservatively 10000)
 '(scroll-margin 5)
 '(send-mail-function (quote mailclient-send-it))
 '(show-paren-mode t)
 '(size-indication-mode t)
 '(text-mode-hook (quote (turn-on-auto-fill text-mode-hook-identify)))
 '(tramp-mode t)
 '(user-mail-address "andy@groveronline.com"))
(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :stipple nil :background "black" :foreground "white" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 110 :width normal :foundry "unknown" :family "DejaVu Sans Mono")))))

(setq load-path (cons "~/.emacs.d/lisp" load-path))
(setq grep-highlight-matches t)
(setq auto-save-list-file-name nil) ; Don't want any .saves files
(setq read-buffer-completion-ignore-case t)
(setq read-file-name-completion-ignore-case t)

; Linux mode for C
(setq c-default-style
      '((c-mode . "linux") (other . "gnu")))

(add-hook 'c-mode-common-hook 
  (lambda ()
    (which-function-mode t)
    (hs-minor-mode t)))

; use python mode for Cython files
(add-to-list 'auto-mode-alist '("\\.pyx\\'" . python-mode))
(add-to-list 'auto-mode-alist '("\\.pxd\\'" . python-mode))

(setq diff-switches "-u")

; set some more gedit-like bindings
(global-set-key "\M-w" 'kill-this-buffer)
;(global-set-key "\C-o" 'menu-find-file-existing)
(global-set-key "\C-o" 'ido-find-file)
(global-set-key "\C-p" 'open-line)
(global-set-key "\C-f" 'grep-find)
(global-set-key "\C-t" 'hs-toggle-hiding)
(global-set-key "\C-s" 'isearch-forward-regexp)

(require 'ido)
(ido-mode t)
(setq ido-enable-flex-matching t)

(require 'swbuff)
(global-set-key [(control tab)] 'swbuff-switch-to-next-buffer)
(global-set-key "\M-e" 'swbuff-switch-to-next-buffer)
(global-set-key "\M-q" 'swbuff-switch-to-previous-buffer)

; clean up unused buffers
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

(global-set-key "\M-8" 'my-isearch-word-at-point)

(defun git-grep (search)
  "git-grep the entire current repo"
  (interactive (list (completing-read "Search for: " nil nil nil (current-word))))
  (grep-find (concat "git --no-pager grep --no-color -n " search " `git rev-parse --show-toplevel`")))

(global-set-key "\M-s" 'git-grep)

(put 'downcase-region 'disabled nil)
