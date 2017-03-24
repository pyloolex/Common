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

;(electric-pair-mode t)
;(setq electric-pair-preserve-balance nil)
;(electric-indent-mode -1)


