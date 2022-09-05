;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
;; (setq user-full-name "ISouthRain"
;;       user-mail-address "isouthrain@gmail.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-unicode-font' -- for unicode glyphs
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
(setq doom-font (font-spec :family "Consolas" :size 20 :weight 'light)
      doom-variable-pitch-font (font-spec :family "Consolas" :size 21)
      doom-unicode-font (font-spec :family "LXGW Wenkai Mono" )
      )
;; (setq doom-font (font-spec :family "JetBrains Mono" :weight 'light :size 20)
;;       doom-variable-pitch-font (font-spec :family "CMU Typewriter Text")
;;       doom-unicode-font (font-spec :family "LXGW Wenkai Mono" )
;;       doom-big-font (font-spec :family "JetBrains Mono" :weight 'light :size 20)
;;       doom-serif-font(font-spec :family "CMU Typewriter Text" :weight 'light :size 20))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type 'relative)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!


;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 区分系统配置
(require 'subr-x)
(setq freedom/is-termux
      (string-suffix-p "Android" (string-trim (shell-command-to-string "uname -a"))))
(setq freedom/is-linux (and (eq system-type 'gnu/linux)))
(setq freedom/is-darwin (and (eq system-type 'darwin)))
(setq freedom/is-windows (and (eq system-type 'windows-nt)))
(setq freedom/is-gui (if (display-graphic-p) t))
(setq freedom/is-tui (not (display-graphic-p)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(when (string= "windows-nt" system-type)
  ;; (setq doom-unicode-font (font-spec :family "BabelStone Han"))
  ;; 调整启动时窗口位置/大小/最大化/全屏
  (set-face-attribute 'default nil :height 122)
  (setq initial-frame-alist
        '((top . 10) (left . 450) (width . 100) (height . 43)))
  ;; (add-hook 'window-setup-hook #'toggle-frame-maximized t)
  ;; (add-hook 'window-setup-hook #'toggle-frame-fullscreen t)
  )
(if freedom/is-linux
    (when (not freedom/is-termux)
      (set-face-attribute 'default nil :height 130)
      (setq initial-frame-alist
            '((top . 1) (left . 450) (width . 100) (height . 48)))
      ;; (add-hook 'window-setup-hook #'toggle-frame-maximized t)
      ;; (add-hook 'window-setup-hook #'toggle-frame-fullscreen t)
      )
  )
;; 自动换行
(+global-word-wrap-mode t)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 解决 server-start deamon 乱码问题
;; (when (eq system-type 'windows-nt)
;;   (setq locale-coding-system 'gb18030)  ;此句保证中文字体设置有效
;;   (setq w32-unicode-filenames 'nil)       ; 确保file-name-coding-system变量的设置不会无效
;;   (setq file-name-coding-system 'gb18030) ; 设置文件名的编码为gb18030
;;   )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 代理
(setq url-proxy-services '(
                           ("http" . "127.0.0.1:7890")
                           ("https" . "127.0.0.1:7890")))
(when freedom/is-linux
  (when (not freedom/is-termux)
    (setq url-proxy-services '(
                               ("http" . "192.168.31.241:7890")
                               ("https" . "192.168.31.241:7890")))
    )
  )
(defun freedom/evil-quit ()
  "Quit current window or buffer."
  (interactive)
  (if (> (seq-length (window-list (selected-frame))) 1)
      (delete-window)
    (previous-buffer)))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(add-to-list 'load-path (expand-file-name "core" doom-user-dir))
;; theme-changer defun
(require 'init-basic)
;; evil-collection
(require 'init-evil)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; hydra general
(require 'init-hydra)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; org-roam org-roam org-crypt cnfonts
(require 'init-org)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; aggressive-indent bm
(require 'init-edit)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; elfeed elfeed-org gnus mu4e telega
(require 'init-reader)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; calendar calfw
(require 'init-calendar)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; markdown-toc markdown-mode
(require 'init-markdown)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; go-translate
(require 'init-translate)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; pyim
(require 'init-pyim)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; dumb-jump
(require 'init-lsp)

(map! :nmv ";" #'evil-ex
      :nmv "m" #'hydra-bm/body
      :nmv "<f12>" #'dumb-jump-go
      :nmv "f" #'avy-goto-char
      :nm "q" #'freedom/evil-quit
      :nmv "Q" #'evil-record-macro
      :nmv "C-s" #'consult-line
      :v "q" #'evil-escape
      :map c-mode-map
      :n "gd" #'dumb-jump-go
      :leader
      (:prefix-map ("f" . "file")
       :desc "Translate text"  "y"   #'gts-do-translate)
      )

(server-start)
;; doom version commit
;; https://github.com/doomemacs/doomemacs/commit/c44bc81a05f3758ceaa28921dd9c830b9c571e61
