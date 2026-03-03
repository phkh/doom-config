;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
;; (setq user-full-name "John Doe"
;;       user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:

(setq doom-theme 'doom-ayu-dark)
(setq doom-font (font-spec :family "JetBrains Mono" :size 15))

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")
(setq org-modern-table-vertical 1)
(setq org-modern-table t)
;;(add-hook 'org-mode-hook #'hl-todo-mode)

(after! org
  ;; 1) TODO workflow (matches your screenshot vibe)
  (setq org-todo-keywords
        '((sequence
           "TODO(t)"
           "INPROGRESS(i)"
           "|"
           "DONE(d)"
           "CANCELLED(c)")))

  ;; 2) Colors for each keyword (adjust names if your theme differs)
  (setq org-todo-keyword-faces
        '(("TODO"       . (:weight bold))
          ("INPROGRESS" . (:foreground "DeepSkyBlue1" :weight bold))
          ("DONE"       . (:foreground "SpringGreen3" :weight bold))
          ("CANCELLED"  . (:foreground "tomato" :weight bold)))))

(after! org
  ;; Always show Org Agenda in a bottom window (full width)
  (set-popup-rule! "^\\*Org Agenda\\*$"
    :side 'bottom
    :size 0.30
    :select t
    :quit t))

;; Optional: keep your window layout when quitting agenda
(after! org
  (setq org-agenda-restore-windows-after-quit t))

;; Optional: if the Calendar buffer is also stealing a window
(after! calendar
  (add-to-list 'display-buffer-alist
               '("^\\*Calendar\\*"
                 (display-buffer-in-side-window)
                 (side . bottom)
                 (slot . 1)
                 (window-height . 0.30)
                 (inhibit-same-window . t))))

(setq dired-omit-files "^\\..*")

(custom-theme-set-faces!
'doom-ayu-dark
'(org-level-8 :inherit outline-3 :height 1.0)
'(org-level-7 :inherit outline-3 :height 1.0)
'(org-level-6 :inherit outline-3 :height 1.1)
'(org-level-5 :inherit outline-3 :height 1.2)
'(org-level-4 :inherit outline-3 :height 1.3)
'(org-level-3 :inherit outline-3 :height 1.4)
'(org-level-2 :inherit outline-2 :height 1.5)
'(org-level-1 :inherit outline-1 :height 1.6)
'(org-document-title  :height 1.8 :bold t :underline nil))


(add-to-list 'default-frame-alist '(fullscreen . maximized))

(after! org
  (setq org-capture-templates
        '(("t" "Todo" entry
           (file "~/org/todo.org")
           "* TODO %?\n"))))


(map! :leader
      :desc "Capture Todo"
      "n c" #'org-capture)


(after! org-agenda
  (custom-set-faces!
    '(org-agenda-deadline-today :weight bold :foreground "orange")
    '(org-deadline-announce     :weight bold :foreground "orange")
    '(org-scheduled-today       :weight bold :foreground "DeepSkyBlue1")
    '(org-agenda-date-today     :weight bold :foreground "DeepSkyBlue1")))

(after! org
  (setq org-deadline-warning-days 0))

(after! org
  (setq org-tag-alist
        '(("personal" . ?p)
          ("work" . ?w))))


(setq fancy-splash-image
      (expand-file-name "hydra.png" doom-user-dir))



; Whenever you reconfigure a package, make sure to wrap your config in an
;; `with-eval-after-load' block, otherwise Doom's defaults may override your
;; settings. E.g.
;;
;;   (with-eval-after-load 'PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look them up).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.
(after! org-modern
  (setq org-modern-star 'replace
        org-modern-replace-stars
        '("▼"   ; level 1 (thick right arrow)
          "●"   ; level 2 (filled circle)
          "●"   ; level 3 (empty circle)
          "■"   ; level 4 (filled square)
          "■"))) ; level 5 (empty square)

(add-hook 'text-mode-hook
          (lambda ()
            (whitespace-mode 0)))

