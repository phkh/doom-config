;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


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
      (expand-file-name "misc/hydra.png" doom-user-dir))

(after! org-modern
  (setq org-modern-star 'replace
        org-modern-replace-stars
        '("●"   ; level 1 (filled circle)
          "●"   ; level 2 (filled circle)
          "●"   ; level 3 (filled circle)
          "■"   ; level 4 (filled square)
          "■"))) ; level 5 (filled square)

(add-hook 'text-mode-hook
          (lambda ()
            (whitespace-mode 0)))


(map! :leader
      :desc "Open Dashboard"
      "b D" #'+doom-dashboard/open)


(remove-hook '+doom-dashboard-functions #'doom-dashboard-widget-loaded)


;; 1. Define your own footer WITHOUT the icon
(defun my-custom-dashboard-footer ()
  (insert
   "\n"
   (+doom-dashboard--center
    +doom-dashboard--width
    "fear eats the soul")
   "\n"))

;; 2. This line removes the default footer (which contains the GitHub icon)
(remove-hook '+doom-dashboard-functions #'+doom-dashboard-widget-footer)

;; 3. This adds your icon-free version to the bottom
(add-hook! '+doom-dashboard-functions :append #'my-custom-dashboard-footer)

(setq org-link-descriptive t)

(after! org
  (require 'toc-org)
  (add-hook 'org-mode-hook #'toc-org-mode))

(after! exec-path-from-shell
  (exec-path-from-shell-initialize))

(after! lsp-ui
  (setq lsp-ui-doc-enable t
        lsp-ui-doc-position 'at-point
        lsp-ui-sideline-enable t
        lsp-ui-sideline-show-diagnostics t
        lsp-ui-sideline-show-code-actions t))


(after! lsp-mode
  ;; Ensure the JS/TS LSP client definitions are loaded
  (require 'lsp-javascript nil t))


;; Start LSP automatically for TypeScript buffers (classic + tree-sitter)
(after! lsp-mode
  ;; If you're on Emacs 29+ / Doom tree-sitter, these modes are common:
  (add-to-list 'lsp-language-id-configuration '(typescript-ts-mode . "typescript"))
  (add-to-list 'lsp-language-id-configuration '(tsx-ts-mode . "typescriptreact"))

  ;; Auto-start LSP when entering TS/TSX buffers:
  (dolist (hook '(typescript-mode-hook
                  tsx-ts-mode-hook
                  typescript-ts-mode-hook
                  js-mode-hook
                  js-ts-mode-hook))
    (add-hook hook #'lsp-deferred))

  ;; Generally helpful defaults
  (setq lsp-auto-guess-root t
        lsp-keep-workspace-alive nil))

(after! lsp-ui
  (setq lsp-ui-sideline-enable nil))
