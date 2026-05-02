(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(auto-save-default nil)
 '(backward-delete-char-untabify-method 'hungry)
 '(column-number-mode t)
 '(company-idle-delay 0.7)
 '(copilot-max-char 1000000)
 '(cua-keep-region-after-copy t)
 '(cua-mode t nil (cua-base))
 '(cycbuf-buffer-sort-function 'cycbuf-sort-by-recency)
 '(desktop-save-mode t)
 '(fill-column 80)
 '(global-auto-revert-mode t)
 '(global-eldoc-mode nil)
 '(global-font-lock-mode t)
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
   '(ace-window company copilot cycbuf delight dockerfile-mode ellama expand-region
		flycheck-rust go-mode gptel jinja2-mode lsp-mode lsp-ui lua-mode
		magit markdown-mode minions move-text multicolumn
		rainbow-delimiters rg ripgrep rust-mode salt-mode smartparens
		strace-mode terraform-mode typescript-mode use-package xref
		yaml-mode yasnippet))
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
 '(tab-width 8)
 '(tool-bar-mode nil)
 '(tramp-default-method "ssh")
 '(tramp-mode t)
 '(uniquify-buffer-name-style 'forward nil (uniquify))
 '(use-short-answers t)
 '(user-mail-address "andy@groveronline.com")
 '(visual-line-fringe-indicators '(left-curly-arrow nil)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :stipple nil :background "black" :foreground "white" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight regular :height 163 :width normal :foundry "CYRE" :family "Inconsolata"))))
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
