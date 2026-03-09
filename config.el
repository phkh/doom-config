;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!

(setq doom-theme 'doom-ir-black)
(setq doom-font (font-spec :family "JetBrains Mono" :size 15))
(setq +doom-dashboard-functions
      '(doom-dashboard-widget-banner
        doom-dashboard-widget-footer))
(setq doom-dashboard-footer-icon nil)
(remove-hook '+doom-dashboard-functions #'doom-dashboard-widget-footer)

(after! doom-themes
  ;; Keep your normal doom-font as-is, but force Japanese to a mono CJK font:
  (set-fontset-font t 'japanese-jisx0208 (font-spec :family "Sarasa Mono J"))
  (set-fontset-font t 'kana            (font-spec :family "Sarasa Mono J"))
  (set-fontset-font t 'han             (font-spec :family "Sarasa Gothic SC")))

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

;; (defadvice! fixed+doom-dashboard--center (len s)
;;   :override #'+doom-dashboard--center
;;   (concat (make-string (ceiling (max 0 (- len (string-width s))) 2) ? )
;;           s))

(defun my-custom-dashboard-footer ()
  (insert
   "\n"
   (+doom-dashboard--center
    +doom-dashboard--width
    "face the strange")
   "\n"))

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

(after! treesit
  (setq treesit-language-source-alist
        '((typescript "https://github.com/tree-sitter/tree-sitter-typescript" "master" "typescript/src")
          (tsx        "https://github.com/tree-sitter/tree-sitter-typescript" "master" "tsx/src"))))

;; Always use tsx-ts-mode for .tsx files
(add-to-list 'auto-mode-alist '("\\.tsx\\'" . tsx-ts-mode))
(add-hook 'tsx-ts-mode-hook #'lsp)

(after! emmet-mode
  ;; Emmet expansion in TSX buffers
  (add-hook 'tsx-ts-mode-hook #'emmet-mode)
  ;; Treat TSX like JSX for Emmet parsing
  (add-to-list 'emmet-jsx-major-modes 'tsx-ts-mode))

(defun phil/tsx-autoclose-setup ()
  "Auto-close tags in tsx-ts-mode buffers."
  ;; Electric-pair will insert the closing part of pairs.
  (electric-pair-local-mode 1)

  ;; Make '>' trigger pairing with '</>'-style behavior for tags.
  ;; This is a lightweight trick; Emmet is the “real” tag generator.
  (setq-local electric-pair-pairs (append electric-pair-pairs '((?> . ?>))))
  (setq-local electric-pair-text-pairs electric-pair-pairs)

  ;; Optional: convenience key to expand Emmet easily
  ;; Type: div>span then C-j => <div><span></span></div>
  (local-set-key (kbd "C-j") #'emmet-expand-line))

(add-hook 'tsx-ts-mode-hook #'phil/tsx-autoclose-setup)
(add-hook 'tsx-ts-mode-hook #'emmet-mode)

(global-auto-revert-mode 1)

(after! vterm
  (define-key vterm-mode-map (kbd "<escape>") nil))
