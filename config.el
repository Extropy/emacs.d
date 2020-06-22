(setq winner-mode-map (make-sparse-keymap))

(setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
		       ("melpa" . "http://melpa.org/packages/")))
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(use-package try :ensure t)

(use-package which-key
  :ensure t
  :config (which-key-mode))

(use-package rainbow-mode :ensure t)

(use-package markdown-mode :ensure t)

;; variables
(custom-set-variables
 '(ansi-color-names-vector
   ["#212526" "#ff4b4b" "#b4fa70" "#fce94f" "#729fcf" "#e090d7" "#8cc4ff" "#eeeeec"])
 '(c-basic-offset 2)
 '(python-indent-offset 4)
 '(js-indent-level 2)
 '(custom-enabled-themes (quote (manoj-dark)))
 '(display-time-24hr-format t)
 '(display-time-day-and-date t)
 '(display-time-mode t)
 '(inhibit-startup-screen t)
 '(left-margin-width 1 t)
 '(package-check-signature nil)
 '(package-selected-packages
   (quote
    (sr-speedbar company markdown-mode latex-extra latex-math-preview latex-preview-pane auctex math-symbol-lists multi-web-mode magit go-mode)))
 '(scroll-bar-mode nil)
 '(tool-bar-mode nil)
 '(winner-mode t)
)

(setq-default left-margin-width 2 right-margin-width 1) ; Define new widths.
(set-window-buffer nil (current-buffer)) ; Use them now.
(fringe-mode 0)
(setq-default line-spacing 0.1)
(set-frame-font "Noto Mono-8" nil t)

;; backup files
(setq backup-directory-alist
      `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))

;; autocomplete
(add-hook 'after-init-hook 'global-company-mode)

;; +org-mode

;; + org mode David O'Toole
(require 'org)
(define-key global-map "\C-cl" 'org-store-link)
(define-key global-map "\C-ca" 'org-agenda)
(setq org-log-done t)
(setq org-directory "~/Dropbox/org")
(setq org-default-notes-file "~/Dropbox/org/notes.org")
(setq org-agenda-files (list "~/Dropbox/org/tasks.org"
                             "~/Dropbox/org/projects.org" 
                             "~/Dropbox/org/notes.org" 
                             "~/Dropbox/org/schedule.org"))
(add-hook 'org-shiftup-final-hook 'windmove-up)
(add-hook 'org-shiftleft-final-hook 'windmove-left)
(add-hook 'org-shiftdown-final-hook 'windmove-down)
(add-hook 'org-shiftright-final-hook 'windmove-right)
(setq org-support-shift-select 'always)
;; -org-mode

;;
;;functions to support syncing .elfeed between machines
;;makes sure elfeed reads index from disk before launching

(defun zoom-in ()
  (interactive)
  (let ((x (+ (face-attribute 'default :height)
              10)))
    (set-face-attribute 'default nil :height x)))

(defun zoom-out ()
  (interactive)
  (let ((x (- (face-attribute 'default :height)
              10)))
    (set-face-attribute 'default nil :height x)))

(global-set-key (kbd "C-x w") 'elfeed)
(global-set-key (kbd "M-s s") 'sr-speedbar-toggle)
(global-set-key (kbd "<f6>") 'list-bookmarks)
(global-set-key (kbd "<f5>") 'bookmark-set)
(global-set-key (kbd "<f7>") 'sr-speedbar-toggle)
(global-set-key (kbd "C-c b") 'compile)
(global-set-key (kbd "C-x g") 'magit-status)
(define-key global-map (kbd "C-=") 'zoom-in)
(define-key global-map (kbd "C--") 'zoom-out)
(when (fboundp 'windmove-default-keybindings)
  (windmove-default-keybindings))
(global-set-key (kbd "C-c m c") 'mc/edit-lines)

(c-set-offset 'case-label '+)

;; + https://github.com/munen/emacs.d
(global-auto-revert-mode t)
(display-time-mode t)
(add-hook 'LaTeX-mode-hook 'latex-preview-pane-mode)
;; - https://github.com/munen/emacs.d


;; +sr-speedbar
(setq speedbar-show-unknown-files t) ; show all files
(setq sr-speedbar-right-side nil) ; put on left side
(setq sr-speedbar-width 30)
(setq speedbar-directory-unshown-regexp "^$")
;; -sr-speedbar

;; + https://github.com/gonsie/dotfiles/blob/master/emacs/theme.el
(setq-default mode-line-format
              (list
               ;; day and time
               '(:eval (propertize (format-time-string " %d %b %H:%M ")
                                   'face 'font-lock-builtin-face))


               '(:eval (propertize (substring vc-mode 5)
                                   'face 'font-lock-comment-face))

               ;; the buffer name; the file name as a tool tip
               '(:eval (propertize " %b "
                                   'face
                                   (let ((face (buffer-modified-p)))
                                     (if face 'font-lock-warning-face
                                       'font-lock-type-face))
                                   'help-echo (buffer-file-name)))

               ;; line and column
               ;; '%02' to set to 2 chars at least; prevents flickering
               "L" (propertize "%02l" 'face 'font-lock-keyword-face) " "
               "C" (propertize "%02c" 'face 'font-lock-keyword-face)

               ;; relative position, size of file
               " ["
               (propertize "%p" 'face 'font-lock-constant-face) ;; % above top
               "/"
               (propertize "%I" 'face 'font-lock-constant-face) ;; size
               "] "

               ;; spaces to align right
               '(:eval (propertize
                " " 'display
                `((space :align-to (- (+ right right-fringe right-margin)
                                      ,(+ 3 (string-width mode-name)))))))

               ;; the current major mode
               (propertize " %m " 'face 'font-lock-string-face)
               ;;minor-mode-alist
               ))

(set-face-attribute 'mode-line nil
                    :background "#353644"
                    :foreground "white"
                    :box '(:line-width 8 :color "#353644")
                    :overline nil
                    :underline nil)

(set-face-attribute 'mode-line-inactive nil
                    :background "#565063"
                    :foreground "white"
                    :box '(:line-width 8 :color "#565063")
                    :overline nil
                    :underline nil)
;; - https://github.com/gonsie/dotfiles/blob/master/emacs/theme.el

;; stop emacs from messing up configuration by writing to init.el
(setq custom-file (concat user-emacs-directory "custom.el"))
