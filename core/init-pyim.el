;; core/init-pyim.el -*- lexical-binding: t; -*-

(after! pyim
  :init
  (setq pyim-dcache-directory (format "%s.local/pyim" doom-user-dir))
  :defer 2
  :config
  (pyim-basedict-enable);; 为 pyim 添加词库
  (pyim-default-scheme 'xiaohe-shuangpin) ;;
  (setq pyim-page-length 5)
  (setq pyim-page-tooltip '(posframe popup minibuffer))
  (setq-default pyim-punctuation-translate-p '(no yes auto))   ;使用半角标点。
  ;; 使用 jk 将能进入 evil-normal-mode
  (defun my-pyim-self-insert-command (orig-func)
    (interactive "*")
    (if (and (local-variable-p 'last-event-time)
             (floatp last-event-time)
             (< (- (float-time) last-event-time) 0.2))
        (set (make-local-variable 'temp-evil-escape-mode) t)
      (set (make-local-variable 'temp-evil-escape-mode) nil)
      )
    (if (and temp-evil-escape-mode
             (equal (pyim-entered-get) "j")
             (equal last-command-event ?k))
        (progn
          (push last-command-event unread-command-events)
          (pyim-process-outcome-handle 'pyim-entered)
          (pyim-process-terminate))
      (progn
        (call-interactively orig-func)
        (set (make-local-variable 'last-event-time) (float-time))
        ))
    )
  (advice-add 'pyim-self-insert-command :around #'my-pyim-self-insert-command)

  ;; 设置光标颜色
  ;; (defun my-pyim-indicator-with-cursor-color (input-method chinese-input-p)
  ;;   (if (not (equal input-method "pyim"))
  ;;       (progn
  ;;         ;; 用户在这里定义 pyim 未激活时的光标颜色设置语句
  ;;         (set-cursor-color "red"))
  ;;     (if chinese-input-p
  ;;         (progn
  ;;           ;; 用户在这里定义 pyim 输入中文时的光标颜色设置语句
  ;;           (set-cursor-color "green"))
  ;;       ;; 用户在这里定义 pyim 输入英文时的光标颜色设置语句
  ;;       (set-cursor-color "blue"))))
  ;; (setq pyim-indicator-list (list #'my-pyim-indicator-with-cursor-color #'pyim-indicator-with-modeline))
  ;; 百度云拼音
  (setq pyim-cloudim 'baidu)
  ;; 设置PYIM图标
  (setq pyim-title "🌲 ")

;; (pyim-scheme-add
;;  '(ziranma-shuangpin
;;    :document "自然码双拼输入方案"
;;    :class shuangpin
;;    :first-chars "abcdefghijklmnpqrstuvwxyz"
;;    :rest-chars "abcdefghijklmnopqrstuvwxyz"
;;    :prefer-triggers nil
;;    :keymaps
;;    (("a" "a" "a")
;;     ("b" "b" "ou")
;;     ("c" "c" "iao")
;;     ("d" "d" "iang" "uang")
;;     ("e" "e" "e")
;;     ("f" "f" "en")
;;     ("g" "g" "eng")
;;     ("h" "h" "ang")
;;     ("i" "ch" "i")
;;     ("j" "j" "an")
;;     ("k" "k" "ao")
;;     ("l" "l" "ai")
;;     ("m" "m" "ian")
;;     ("n" "n" "in")
;;     ("o" "o" "uo" "o")
;;     ("p" "p" "un")
;;     ("q" "q" "iu")
;;     ("r" "r" "uan")
;;     ("s" "s" "iong" "ong")
;;     ("t" "t" "ue" "ve")
;;     ("u" "sh" "u")
;;     ("v" "zh" "v" "ui")
;;     ("w" "w" "ia" "ua")
;;     ("x" "x" "ie")
;;     ("y" "y" "ing" "uai")
;;     ("z" "z" "ei")
;;     ("aa" "a")
;;     ("ai" "ai")
;;     ("ah" "ang")
;;     ("ao" "ao")
;;     ("an" "an")
;;     ("ee" "e")
;;     ("ei" "ei")
;;     ("en" "en")
;;     ("eg" "eng")
;;     ("er" "er")
;;     ("oo" "o")
;;     ("ou" "ou")
;;     )))
;;   (pyim-default-scheme 'ziranma-shuangpin)

  );; pyim

(provide 'init-pyim)
