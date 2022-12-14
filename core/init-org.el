;;; core/init-org.el -*- lexical-binding: t; -*-

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; org 通知设置
(use-package! appt
  :defer 3
  :after org
  :config
  ;; 每小时同步一次appt,并且现在就开始同步
  (run-at-time nil 3600 'org-agenda-to-appt)
  ;; 更新agenda时，同步appt
  (add-hook 'org-agenda-finalize-hook 'org-agenda-to-appt)
  ;; 激活提醒
  (appt-activate 1)
  ;; 提前1分钟提醒, 单位: 分
  (setq appt-message-warning-time 1)
  (setq appt-audible t)
  ;;提醒间隔, 单位: 分
  (setq appt-display-interval 5)
  (require 'notifications)
  (defun appt-disp-window-and-notification (min-to-appt current-time appt-msg)
    (let ((title (format "%s分钟内有新的任务" min-to-appt)))
      (notifications-notify :timeout (* appt-display-interval 60000) ;一直持续到下一次提醒
                            :title title
                            :body appt-msg
                            )
      (appt-disp-window min-to-appt current-time appt-msg))) ;同时也调用原有的提醒函数
  (setq appt-display-format 'window) ;; 只有这样才能使用自定义的通知函数
  (setq appt-disp-window-function #'appt-disp-window-and-notification)
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; org 设置
(after! org
  :defer 2
  :config
  ;; org-mode 排除对中文的补全
  ;; (progn
  ;;   (push 'company-dabbrev-char-regexp company-backends)
  ;;   (setq company-dabbrev-char-regexp "[\\.0-9a-zA-Z-_'/]")
  ;;   (set-company-backend! 'org-mode
  ;;     'company-dabbrev-char-regexp 'company-yasnippet))

  (setq org-capture-bookmark nil)
  (when freedom/is-windows
    (setq org-directory "F:\\MyFile\\Org"
          org-roam-directory "F:\\MyFile\\Org")
    (setq org-agenda-files '("F:\\MyFile\\Org\\GTD"))
    (setq org-capture-templates
          '(
            ;;TODO
            ("t" "Todo" plain (file+function "F:\\MyFile\\Org\\GTD\\Todo.org" find-month-tree)
             "*** TODO %^{想做什么？}\n  :时间: %^T\n  %?\n  %i\n"  :kill-buffer t :immediate-finish t)

            ;;日志
            ("j" "Journal" entry (file+datetree "F:\\MyFile\\Org\\Journal.org")
             "* %^{记些什么} %?\n  %i\n" :kill-buffer t :immediate-finish t)

            ;;日程安排
            ("a" "日程安排" plain (file+function "F:\\MyFile\\Org\\GTD\\Agenda.org" find-month-tree)
             "*** [#%^{优先级}] %^{安排} \n SCHEDULED: %^T \n  :地点: %^{地点}\n" :kill-buffer t :immediate-finish t)

            ;;笔记
            ("n" "笔记" entry (file+headline "F:\\MyFile\\Org\\Note.org" "Note")
             "* %^{你想要记录的笔记} \n :时间: %T \n %?")

            ("y" "语录" entry (file+headline "F:\\Hugo\\content\\Quotation.zh-cn.md" "2022")
             "> %^{语录}  " :kill-buffer t :immediate-finish t)

            ;;消费
            ("zd" "账单" plain (file+function "F:\\MyFile\\Org\\Bill.org" find-month-tree)
             " | %<%Y-%m-%d %a %H:%M:%S> | %^{prompt|Breakfast|Lunch|Dinner|Shopping|Night Snack|Fruit|Transportation|Other} | %^{金额} |" :kill-buffer t :immediate-finish t)

            ;;英语单词
            ("e" "英语单词" entry (file+datetree "F:\\MyFile\\Org\\EnglishWord.org")
             "*  %^{英语单词} ----> %^{中文翻译}\n" :kill-buffer t :immediate-finish t)

            ;;Org-protocol网页收集
            ("w" "网页收集" entry (file "F:\\MyFile\\Org\\WebCollection.org")
             "* [[%:link][%:description]] \n %U \n %:initial \n" :kill-buffer t :immediate-finish t)

            ("b" "Bookmarks" plain (file+headline "F:\\MyFile\\Org\\Bookmarks.org" "Bookmarks")
             "+  %?" :kill-buffer t :prepend 1)
            ))
    )
  (when freedom/is-linux
    (setq org-directory "~/MyFile/Org"
          org-roam-directory "~/MyFile/Org")
    (setq org-agenda-files '("~/MyFile/Org/GTD"))
    (setq org-capture-templates
          '(
            ;;TODO
            ;; ("t" "Todo" entry (file+headline "~/MyFile/Org/GTD/Todo.org" "2022年6月")
            ("t" "Todo" plain (file+function "~/MyFile/Org/GTD/Todo.org" find-month-tree)
             "*** TODO %^{想做什么？}\n  :时间: %^T\n  %?\n  %i\n"  :kill-buffer t :immediate-finish t)

            ;;日志
            ("j" "Journal" entry (file+datetree "~/MyFile/Org/Journal.org")
             "* %^{记些什么} %?\n  %i\n" :kill-buffer t :immediate-finish t)

            ;;日程安排
            ("a" "日程安排" plain (file+function "~/MyFile/Org/GTD/Agenda.org" find-month-tree)
             "*** [#%^{优先级}] %^{安排} \n SCHEDULED: %^T \n  :地点: %^{地点}\n" :kill-buffer t :immediate-finish t)

            ;;笔记
            ;; ("n" "笔记" entry (file+headline "~/MyFile/Org/Note.org" "2022年6月")
            ("n" "笔记" entry (file+headline "~/MyFile/Org/Note.org" "Note.org")
             "* %^{你想要记录的笔记} \n :时间: %T \n %?")

            ;;消费
            ("zd" "账单" plain (file+function "~/MyFile/Org/Bill.org" find-month-tree)
             " | %<%Y-%m-%d %a %H:%M:%S> | %^{prompt|Breakfast|Lunch|Dinner|Shopping|Night Snack|Fruit|Transportation|Other} | %^{金额} |" :kill-buffer t :immediate-finish t)

            ;;英语单词
            ("e" "英语单词" entry (file+datetree "~/MyFile/Org/EnglishWord.org")
             "*  %^{英语单词} ----> %^{中文翻译}\n"  :kill-buffer t :immediate-finish t)

            ;;Org-protocol网页收集
            ("w" "网页收集" entry (file "~/MyFile/Org/WebCollection.org")
             "* [[%:link][%:description]] \n %U \n %:initial \n")
            ("b" "Bookmarks" plain (file+headline "~/MyFile/Org/Bookmarks.org" "Bookmarks")
             "+  %?" :kill-buffer t :prepend 1)
            ))
    )
  (when freedom/is-darwin
    (setq org-directory "~/Desktop/MyFile/Org"
          org-roam-directory "~/Desktop/MyFile/Org")
    (setq org-agenda-files '("~/Desktop/MyFile/Org/GTD"))
    (setq org-capture-templates
          '(
            ;;TODO
            ("t" "Todo" plain (file+function "~/Desktop/MyFile/Org/GTD/Todo.org" find-month-tree)
             "*** TODO %^{想做什么？}\n  :时间: %^T\n  %?\n  %i\n"  :kill-buffer t :immediate-finish t)

            ;;日志
            ("j" "Journal" entry (file+datetree "~/Desktop/MyFile/Org/Journal.org" )
             "* %^{记些什么} %?\n  %i\n" :kill-buffer t :immediate-finish t)

            ;;日程安排
            ("a" "日程安排" plain (file+function "~/Destop/MyFile/Org/GTD/Agenda.org" find-month-tree)
             "*** [#%^{优先级}] %^{安排} \n SCHEDULED: %^T \n  :地点: %^{地点}\n" :kill-buffer t :immediate-finish t)

            ;;笔记
            ("n" "笔记" entry (file+headline "~/Desktop/MyFile/Org/Note.org" "Note")
             "* %^{你想要记录的笔记} \n :时间: %T \n %?")

            ;;消费
            ("zd" "账单" plain (file+function "~/Desktop/MyFile/Org/Bill.org" find-month-tree)
             " | %<%Y-%m-%d %a %H:%M:%S> | %^{prompt|Breakfast|Lunch|Dinner|Shopping|Night Snack|Fruit|Transportation|Other} | %^{金额} |" :kill-buffer t :immediate-finish t)

            ;;英语单词
            ("e" "英语单词" entry (file+datetree "~/Desktop/MyFile/Org/EnglishWord.org")
             "*  %^{英语单词} ----> %^{中文翻译}\n" :kill-buffer t :immediate-finish t)

            ;;Org-protocol网页收集
            ("w" "网页收集" entry (file "~/Desktop/MyFile/Org/WebCollection.org")
             "* [[%:link][%:description]] \n %U \n %:initial \n")
            ("b" "Bookmarks" plain (file+headline "~/Desktop/MyFile/Org/Bookmarks.org" "New-Bookmarks")
             "+  %?" :kill-buffer t :prepend 1)
            ))
    )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  (add-to-list 'org-capture-templates '("z" "账单"));;与上面的账单相对应
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  (defun get-year-and-month ()
    (list (format-time-string "%Y") (format-time-string "%Y-%m")))
  (defun find-month-tree ()
    (let* ((path (get-year-and-month))
           (level 1)
           end)
      (unless (derived-mode-p 'org-mode)
        (error "Target buffer \"%s\" should be in Org mode" (current-buffer)))
      (goto-char (point-min))             ;移动到 buffer 的开始位置
      ;; 先定位表示年份的 headline，再定位表示月份的 headline
      (dolist (heading path)
        (let ((re (format org-complex-heading-regexp-format
                          (regexp-quote heading)))
              (cnt 0))
          (if (re-search-forward re end t)
              (goto-char (point-at-bol))  ;如果找到了 headline 就移动到对应的位置
            (progn                        ;否则就新建一个 headline
              (or (bolp) (insert "\n"))
              (if (/= (point) (point-min)) (org-end-of-subtree t t))
              (insert (make-string level ?*) " " heading "\n"))))
        (setq level (1+ level))
        (setq end (save-excursion (org-end-of-subtree t t))))
      (org-end-of-subtree)))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;; 字体格式化-颜色调整
  (defface my-org-emphasis-bold
    '((default :inherit bold)
      (((class color) (min-colors 88) (background light))
       :foreground "#a60000")
      (((class color) (min-colors 88) (background dark))
       :foreground "#ff8059"))
    "My bold emphasis for Org.")
  (defface my-org-emphasis-italic
    '((default :inherit italic)
      (((class color) (min-colors 88) (background light))
       :foreground "#005e00")
      (((class color) (min-colors 88) (background dark))
       :foreground "#44BCAB"))
    "My italic emphasis for Org.")
  (defface my-org-emphasis-underline
    '((default :inherit underline)
      (((class color) (min-colors 88) (background light))
       :foreground "#813e00")
      (((class color) (min-colors 88) (background dark))
       :foreground "#d0bc00"))
    "My underline emphasis for Org.")
  (defface my-org-emphasis-strike-through
    '((((class color) (min-colors 88) (background light))
       :strike-through "#972500" :foreground "#505050")
      (((class color) (min-colors 88) (background dark))
       :strike-through "#ef8b50" :foreground "#a8a8a8"))
    "My strike-through emphasis for Org.")
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  (setq org-emphasis-alist
        '(("*" my-org-emphasis-bold)
          ("/" my-org-emphasis-italic)
          ("_" my-org-emphasis-underline)
          ("=" org-verbatim verbatim)
          ("~" org-code verbatim)
          ("+" (my-org-emphasis-strike-through :strike-through t))))

  );; use-package org
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; org 标题加密， 只需添加 :crypt:
(after! org-crypt
  :defer 2
  :config
  (org-crypt-use-before-save-magic)
  (setq org-tags-exclude-from-inheritance '("crypt"))
  (setq org-crypt-key "885AC4F89BA7A3F8")
  (setq auto-save-default nil)
  (setq epg-gpg-program "gpg2")
  ;; 解决 ^M 解密问题
  (defun freedom/org-decrypt-entry ()
    "Replace DOS eolns CR LF with Unix eolns CR"
    (interactive)
    (goto-char (point-min))
    (while (search-forward "\r" nil t) (replace-match ""))
    (org-decrypt-entry))

  )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; org-roam
(use-package! org-roam
  :config
  ;; 创建左边显示子目录分类
  (cl-defmethod org-roam-node-type ((node org-roam-node))
    "Return the TYPE of NODE."
    (condition-case nil
        (file-name-nondirectory
         (directory-file-name
          (file-name-directory
           (file-relative-name (org-roam-node-file node) org-roam-directory))))
      (error "")))
  (setq org-roam-node-display-template
        (concat "${type:15} ${title:*} " (propertize "${tags:10}" 'face 'org-tag)))
  (add-to-list 'org-roam-node-template-prefixes '("tags" . "#"))
  (add-to-list 'org-roam-node-template-prefixes '("type" . "@"))
  )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; org-roam-ui
(use-package! websocket
  :after org-roam)
(use-package! org-roam-ui
  :after org-roam ;; or :after org
  :config
  (setq org-roam-ui-sync-theme t
        org-roam-ui-follow t
        org-roam-ui-update-on-save t
        org-roam-ui-open-on-start t))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; org-download
(use-package org-download
  :defer 1
  :load-path "~/.doom.d/core/plugins"
  :config
  (add-hook 'dired-mode-hook 'org-download-enable)
  (setq org-download-heading-lvl nil)
  ;; 文件目录
  ;; (setq-default org-download-image-dir (concat "./Attachment/" (file-name-nondirectory (file-name-sans-extension (buffer-file-name)))))
  (defun my-org-download--dir-1 ()
    (or org-download-image-dir (concat "./Attachment/" (file-name-nondirectory (file-name-sans-extension (buffer-file-name))) )))
  (advice-add #'org-download--dir-1 :override #'my-org-download--dir-1)
  )

(provide 'init-org)
