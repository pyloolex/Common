(setq c-default-style "bsd"
	  c-basic-offset 4)
(setq-default c-basic-offset 4
			  tab-width 4
			  indent-tabs-mode t)

(setq make-backup-files nil
	  auto-save-default nil
	  auto-save-list-file-name nil)


(global-set-key (kbd "RET") 'newline-and-indent)                           

(show-paren-mode t) ; Highlight expression between {}, (), []
(setq show-paren-style 'parenthesis) ; parenthesis | expression | mixed

(add-hook 'html-mode-hook
		    (lambda ()
			      ;; Default indentation is usually 2 spaces, changing to 4.
			      (set (make-local-variable 'sgml-basic-offset) 4)))
(setq font-lock-maximum-decoration
	  '((html-mode . 1)))

(setq column-number-mode t)


;(electric-pair-mode t)
;(setq electric-pair-preserve-balance nil)
;(electric-indent-mode -1)


