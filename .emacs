; ____________________________________________________________________________
; Installing packages
;_____________________________________________________________________________
; Attention!!! If you want to use xclip, first you must install it in ubuntu:
; sudo apt install xclip
;
; And then emacs will do the rest of work.

; list the packages you want
(setq package-list '(xclip))

; list the repositories containing them
(setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")))

; activate all the packages (in particular autoloads)
(package-initialize)

; fetch the list of packages available
(unless package-archive-contents
  (package-refresh-contents))

; install the missing packages
(dolist (package package-list)
  (unless (package-installed-p package)
    (package-install package)))


; ____________________________________________________________________________
; Including packages
;_____________________________________________________________________________

; It doesn't work in Emacs 27. I don't know why it was needed earlier.
; Not it seems to be not needed.
; (require 'cl)

(require 'xclip) ; M-x package-list-packages to install


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

(show-paren-mode t) ; Highlight expression between {}, (), []
(setq show-paren-style 'parenthesis) ; parenthesis | expression | mixed

; It doesn't work in Emacs 27. I don't know why it was needed earlier.
; Not it seems to be not needed.
; (setq font-lock-maximum-decoration '((html-mode . 1)))

(setq column-number-mode t)

(setq scroll-step 1)
(setq comint-input-ignoredups t) ; ignore duplicates in shell

;(electric-pair-mode t)
;(setq electric-pair-preserve-balance nil)
;(electric-indent-mode -1)

; Forbid auto-indent previous line
; (when (fboundp 'electric-indent-mode) (electric-indent-mode -1))
; Forbid auto-indent previous line (better version for Java)?
(setq-default electric-indent-inhibit t)


(setq forward-sexp-function nil)

(global-set-key (kbd "RET") 'newline-and-indent)
(global-set-key (kbd "M-s TAB") (lambda() (interactive) (insert "    ")))
(global-set-key (kbd "C-x <home>") (lambda() (interactive) (my-line-begin)))
(global-set-key (kbd "C-x %") 'query-replace)
(global-set-key (kbd "C-x g")
                (lambda() (interactive)
                    (execute-kbd-macro (kbd "C-x v g"))
                    (sleep-for 1)
                    (vc-annotate-mode)
                )
)
(global-set-key (kbd "M-a") 'move-beginning-of-line)
(global-set-key (kbd "M-e") 'move-end-of-line)
; Show file name shortcut.
(global-set-key (kbd "M-s b f n")
                (lambda() (interactive)
                    (message (buffer-file-name (window-buffer (minibuffer-selected-window))))
                )
)

; Auto reload files if they were changed on the disk.
(global-auto-revert-mode t)

; 80 letters rule (highlight)
(setq-default whitespace-line-column 78
              whitespace-style '(face lines-tail))
(add-hook 'prog-mode-hook #'whitespace-mode) ; only if I write code
(add-hook 'text-mode-hook #'whitespace-mode) ; and the other cases

; Resolves problems with 'end' button inside tmux
(define-key input-decode-map "\e[4~" [end])

; Allows copy and paste from Emacs
(setq xclip-mode 1)

; Associate .tac files with c++-mode
(add-to-list 'auto-mode-alist '("\\.tac\\'" . c++-mode))
(add-to-list 'auto-mode-alist '("\\.tin\\'" . c++-mode))

; If a region is selected, you can type something, and it will replace your
; selected region.
(delete-selection-mode 1)

; JS indentation = 2 spaces
(setq js-indent-level 2)
(setq tab-width 2)


; ____________________________________________________________________________
; Hooks
; ____________________________________________________________________________

; Remove all the trailing whitespaces during saving a buffer.
(add-hook 'before-save-hook 'delete-trailing-whitespace)

(add-hook 'c-mode-hook
    (lambda ()
        ;; Auto indent LPAREN
        (local-set-key (kbd "{")
            (lambda() (interactive)
                (insert "{")
                (indent-according-to-mode)
            )
        )
        (local-set-key (kbd "}")
            (lambda() (interactive)
                (insert "}")
                (indent-according-to-mode)
            )
        )
    )
)

(add-hook 'html-mode-hook
    (lambda ()
        ;; Default indentation is usually 4 spaces, changing to 2.
        (set (make-local-variable 'sgml-basic-offset) 2)
        (setq tab-width 2)

        (global-set-key (kbd "M-s TAB")
                        (lambda() (interactive) (insert "  ")))
    )
)

; Old version
;; (add-hook 'js-mode-hook
;;     (lambda()
;;         (local-set-key (kbd "{")
;;             (lambda() (interactive)
;;                 (my-bsd-lparen-align)
;;                 (insert "{")
;;             )
;;         )
;;         (local-set-key (kbd "}")
;;             (lambda() (interactive)
;;                 (insert "}")
;;                 (indent-according-to-mode)
;;                 ;(c-indent-command)
;;             )
;;         )
;;         (setq js-indent-level 2)
;;         (setq tab-width 2)
;;     )
;; )

; New version
(add-hook 'js-mode-hook
    (lambda()
        (local-set-key (kbd "{")
            (lambda() (interactive)
                (insert "{")
                (indent-according-to-mode)
            )
        )
        (local-set-key (kbd "}")
            (lambda() (interactive)
                (insert "}")
                (indent-according-to-mode)
            )
        )
    )
)


; ____________________________________________________________________________
; My own functions
; ____________________________________________________________________________

; my implementation auto-indenting bsd-style
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


; ____________________________________________________________________________
; Color scheme
; ____________________________________________________________________________

;(set-face-attribute 'default nil :family "Menlo" :height 120)
(set-face-attribute 'font-lock-builtin-face nil
                    :foreground "#77aadd" :weight 'bold)
(set-face-attribute 'font-lock-comment-face nil :foreground "#dd0000")
(set-face-attribute 'font-lock-constant-face nil :foreground "#883388")
(set-face-attribute 'font-lock-doc-face nil :foreground "#00a000")
(set-face-attribute 'font-lock-function-name-face nil
                    :foreground "#77aadd" :weight 'bold)
(set-face-attribute 'font-lock-keyword-face nil
                    :foreground "#00dddd" :weight 'bold)
(set-face-attribute 'font-lock-negation-char-face nil :foreground "#ff6666")
(set-face-attribute 'font-lock-string-face nil :foreground "#00a000")
(set-face-attribute 'font-lock-type-face nil :foreground "#00a000")
(set-face-attribute 'font-lock-variable-name-face nil :foreground "#ccbb00")

(set-face-foreground 'minibuffer-prompt "cyan")


; ____________________________________________________________________________
; Trashcan (it is filled automatically)
; ____________________________________________________________________________
(put 'narrow-to-region 'disabled nil)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages (quote (xclip)))
 '(safe-local-variable-values
   (quote
    ((eval ignore-errors
           (require
            (quote whitespace))
           (whitespace-mode 1))
     (whitespace-style face indentation)
     (eval progn
           (c-set-offset
            (quote case-label)
            (quote 0))
           (c-set-offset
            (quote innamespace)
            (quote 0))
           (c-set-offset
            (quote inline-open)
            (quote 0)))))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
