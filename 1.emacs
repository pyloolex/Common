; ____________________________________________________________________________
; Including packages
;_____________________________________________________________________________

(require 'cl)

; ____________________________________________________________________________
; Using default emacs's settings
; ____________________________________________________________________________

(setq c-default-style "bsd" 
		c-basic-offset 4)
(setq-default c-basic-offset 4
			  tab-width 4
			  indent-tabs-mode nil)

(setq make-backup-files nil
	  auto-save-default nil
	  auto-save-list-file-name nil)


(global-set-key (kbd "RET") 'newline-and-indent)                           

(show-paren-mode t) ; Highlight expression between {}, (), []
(setq show-paren-style 'parenthesis) ; parenthesis | expression | mixed

(add-hook 'html-mode-hook
		    (lambda ()
			      ;; Default indentation is usually 2 spaces, changing to 4.
			      (set (make-local-variable 'sgml-basic-offset) 2)
				  (setq tab-width 2)
			)
)

(setq font-lock-maximum-decoration
	  '((html-mode . 1)))

(setq column-number-mode t)

;(electric-pair-mode t)
;(setq electric-pair-preserve-balance nil)
;(electric-indent-mode -1)


; 80 letters rule (highlight)
(setq-default
  whitespace-line-column 78
   whitespace-style       '(face lines-tail))
(add-hook 'prog-mode-hook #'whitespace-mode) ; only if I write code
(add-hook 'text-mode-hook #'whitespace-mode) ; and the other cases

; my implementation auto-indenting bsd-style
(add-hook 'js-mode-hook
    (lambda()
        (local-set-key (kbd "{")
            (lambda() (interactive)
                (my-bsd-lparen-align)
                (insert "{")               
            )
        )
        (local-set-key (kbd "}")
            (lambda() (interactive)
                (insert "}")
                (c-indent-command)         
            )
        )
    )
)





;(global-set-key (kbd "\C-h") (lambda() (interactive)
;            (my-bsd-lparen-align)))




; ____________________________________________________________________________
; My own functions
; ____________________________________________________________________________


(defun my-bsd-lparen-align()
    (skip-chars-forward " \t")
	(setq cur_pos (point))
    (my-line-begin)
    (setq new_pos (point))
    (goto-char cur_pos)
    (if (eq cur_pos new_pos)
        (__my-bsd-lparen-put)
    )
)

(defun my-line-begin()
  (beginning-of-line)
  (skip-chars-forward " \t")
  (current-column)
)

(defun __my-bsd-lparen-put()
	(setq init_pos (point))
    (setq cur_start (my-line-begin))
    (forward-line -1)
    (setq block_start (my-line-begin))
    (setq diff (- cur_start block_start))
    (goto-char init_pos)
    (if (>= diff 0)
        (delete-backward-char diff)
        (loop for i from 1 to (- diff) do (insert " "))
    )
)


          
