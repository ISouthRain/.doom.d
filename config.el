(use-package! server
  :config
  (unless (server-running-p)
    (server-start)))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 解决 Windows 系统 server-start deamon 乱码问题
(use-package! emacs
  :defer t
  :config
  (when (eq system-type 'windows-nt)
    (setq locale-coding-system 'gb18030)  ;此句保证中文字体设置有效
    (setq w32-unicode-filenames 'nil)       ; 确保file-name-coding-system变量的设置不会无效
    (setq file-name-coding-system 'gb18030) ; 设置文件名的编码为gb18030
    )
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 区分系统配置
(use-package! subr-x
  :defer t
  :config
  (setq freedom/is-termux
        (string-suffix-p "Android" (string-trim (shell-command-to-string "uname -a"))))
  (setq freedom/is-linux (and (eq system-type 'gnu/linux)))
  (setq freedom/is-darwin (and (eq system-type 'darwin)))
  (setq freedom/is-windows (and (eq system-type 'windows-nt)))
  (setq freedom/is-gui (if (display-graphic-p) t))
  (setq freedom/is-tui (not (display-graphic-p)))
  )

(use-package! emacs
  :defer t
  :config
  ;; 显示 行号 方式
  (setq display-line-numbers-type 'relative)
  ;; 自动换行
  (if (not freedom/is-termux)
      (+global-word-wrap-mode t))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;; basic configuration
  (display-time-mode 1) ;; 常显
  (setq display-time-24hr-format t) ;;格式
  (setq display-time-day-and-date t) ;;显示时间、星期、日期
  ;; 显示电池
  (if (display-graphic-p)
      (display-battery-mode 1))
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package! emacs
  :defer t
  :config
  (when (string= "windows-nt" system-type)
    ;; (setq doom-unicode-font (font-spec :family "BabelStone Han"))
    ;; 调整启动时窗口位置/大小/最大化/全屏
    (set-face-attribute 'default nil :height 122)
    (setq initial-frame-alist
          '((top . 10) (left . 450) (width . 90) (height . 36)));; 39 ==> 43
    ;; (add-hook 'window-setup-hook #'toggle-frame-maximized t)
    ;; (add-hook 'window-setup-hook #'toggle-frame-fullscreen t)
    (setq doom-font (font-spec :family "Iosevka" :size 22 :weight 'light))
    ;; (setq doom-unicode-font (font-spec :family "霞鹜文楷" :size 22 :weight 'light))
    )
  (if freedom/is-linux
      (when (not freedom/is-termux)
        (set-face-attribute 'default nil :height 130)
        (setq doom-font (font-spec :family "Iosevka" :size 22 :weight 'light))
        (setq initial-frame-alist
              '((top . 1) (left . 450) (width . 95) (height . 34)))
        ;; (add-hook 'window-setup-hook #'toggle-frame-maximized t)
        ;; (add-hook 'window-setup-hook #'toggle-frame-fullscreen t)
        )
    )
  (when freedom/is-darwin
    (setq initial-frame-alist
          '((top . 1) (left . 450) (width . 100) (height . 45)))
    ;; (add-hook 'window-setup-hook #'toggle-frame-maximized t)
    ;; (add-hook 'window-setup-hook #'toggle-frame-fullscreen t)
    )
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 代理
(use-package! emacs
  :defer t
  :config
  (setq url-proxy-services '(
                             ("http" . "127.0.0.1:7890")
                             ("https" . "127.0.0.1:7890")))
  (when freedom/is-linux
    (when (not freedom/is-termux)
      (setq url-proxy-services '(
                                 ("http" . "192.168.1.4:7890")
                                 ("https" . "192.168.1.4:7890"))))
    )
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; function define
(use-package! emacs
  :defer t
  :config
  (defun freedom/evil-quit ()
    "Quit current window or buffer."
    (interactive)
    (if (> (seq-length (window-list (selected-frame))) 1)
        (delete-window)
      (previous-buffer)))

  (defun freedom-hugo-home ()
    (interactive)
    (if freedom/is-windows
        (find-file "F:\\Hugo\\content\\posts\\Home.md"))
    (if freedom/is-termux
        (find-file "~/Ubuntu/ubuntu-fs/root/Hugo/content/posts/Home.md"))
    (if freedom/is-darwin
        (find-file "~/Desktop/Hugo/content/posts/Home.md"))
    (if freedom/is-linux
        (if (not freedom/is-termux)
            (find-file "~/f/Hugo/content/posts/Home.md")))
    )
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 窗口透明
(defun sanityinc/adjust-opacity (frame incr)
  "Adjust the background opacity of FRAME by increment INCR."
  (unless (display-graphic-p frame)
    (error "Cannot adjust opacity of this frame"))
  (let* ((oldalpha (or (frame-parameter frame 'alpha) 100))
         (oldalpha (if (listp oldalpha) (car oldalpha) oldalpha))
         (newalpha (+ incr oldalpha)))
    (when (and (<= frame-alpha-lower-limit newalpha) (>= 100 newalpha))
      (modify-frame-parameters frame (list (cons 'alpha newalpha))))))
(defhydra hydra-freedom-AdjustOpacity(:color pink
                                      :hint nil
                                      :foreign-keys warn ;; 不要使用hydra以外的键
                                      )
  "
_j_: 增加 _k_: 减少 _g_: 重置
"
  ("j"  (sanityinc/adjust-opacity nil 2) :exit nil)
  ("k"  (sanityinc/adjust-opacity nil -2) :exit nil)
  ("g"  (modify-frame-parameters nil `((alpha . 100))) :exit nil)
  ("q" nil "cancel")
  ("<escape>" nil "cancel")
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Automatically replace the topic according to time
(when (not freedom/is-termux)
  (use-package! theme-changer
    ;; :unless IS-MAC
    :init
    (setq calendar-location-name "香洲, GD")
    ;; (setq calendar-latitude 39.9)
    ;; (setq calendar-longitude 116.3)
    (setq calendar-latitude 22.17)
    (setq calendar-longitude 113.34)
    :config
    ;; Automatic replacement icon
    (add-hook! 'doom-load-theme-hook
      (setq fancy-splash-image
            (let ((banners (directory-files (expand-file-name "banner" doom-private-dir)
                                            'full
                                            (rx ".png" eos))))
              (elt banners (random (length banners))))))

    ;; The theme list of automatic replacement
    (defconst +list-light-theme '(doom-one-light
                                  doom-nord-light
                                  doom-opera-light
                                  doom-tomorrow-day))
    (defconst +list-dark-theme  '(doom-one
                                  doom-vibrant
                                  doom-city-lights
                                  doom-challenger-deep
                                  doom-dracula
                                  doom-gruvbox
                                  doom-horizon
                                  doom-Iosvkem
                                  doom-material
                                  doom-molokai
                                  doom-monokai-classic
                                  doom-monokai-pro
                                  doom-moonlight
                                  doom-oceanic-next
                                  doom-palenight
                                  doom-peacock
                                  doom-rouge
                                  doom-snazzy
                                  doom-spacegrey
                                  doom-tomorrow-night))
    (add-hook! after-init
               :append
               (change-theme +list-light-theme
                             +list-dark-theme)))
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; evil-collection
(use-package! evil-collection
  :defer t
  :config
  (defun freedom-evil-collection-nov-setup ()
    "Set up `evil' bindings for `nov'."
    (evil-collection-define-key 'normal 'nov-mode-map
      "gr" 'nov-render-document
      "s" 'nov-view-source
      "S" 'nov-view-content-source
      "g?" 'nov-display-metadata
      "gn" 'nov-next-document
      (kbd "C-j") 'nov-next-document
      (kbd "M-j") 'nov-next-document
      "]]" 'nov-next-document
      "gp" 'nov-previous-document
      (kbd "C-k") 'nov-previous-document
      (kbd "M-k") 'nov-previous-document
      "gk" 'nov-scroll-down
      "gj" 'nov-scroll-up
      "[[" 'nov-previous-document

      "t" 'nov-goto-toc
      "i" 'nov-goto-toc
      (kbd "RET") 'nov-browse-url
      (kbd "<follow-link>") 'mouse-face
      (kbd "<mouse-2>") 'nov-browse-url
      (kbd "TAB") 'shr-next-link
      (kbd "M-TAB") 'shr-previous-link
      (kbd "<backtab>") 'shr-previous-link
      (kbd "SPC") 'nov-scroll-up
      (kbd "S-SPC") 'nov-scroll-down
      (kbd "DEL") 'nov-scroll-down))
  (advice-add #'evil-collection-nov-setup :override #'freedom-evil-collection-nov-setup)
  )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; org mode cycle global
(after! evil-org
  :defer t
  :config
  (remove-hook 'org-tab-first-hook #'+org-cycle-only-current-subtree-h))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; general
(after! general
  :defer-incrementally t
  :config
  (general-evil-setup)
  (general-imap ";"
    (general-key-dispatch 'self-insert-command
      :timeout 0.5
      ";" 'freedom-english-translate
      "'" 'toggle-input-method))
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; org 设置
(use-package! org
  :defer t
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
             "* %<%H:%M> %^{记些什么} %?\n  %i\n" :kill-buffer t :immediate-finish t :prepend 1)

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
             " | %<%Y-%m-%d %a %H:%M:%S> | %^{prompt|Breakfast|Lunch|Dinner|Shopping|Night Snack|Fruit|Transportation|Other} | %^{支付金额} | %^{收入金额} |" :kill-buffer t :immediate-finish t)

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
             "* %<%H:%M> %^{记些什么} %?\n  %i\n" :kill-buffer t :immediate-finish t :prepend 1)

            ;;日程安排
            ("a" "日程安排" plain (file+function "~/MyFile/Org/GTD/Agenda.org" find-month-tree)
             "*** [#%^{优先级}] %^{安排} \n SCHEDULED: %^T \n  :地点: %^{地点}\n" :kill-buffer t :immediate-finish t)

            ;;笔记
            ;; ("n" "笔记" entry (file+headline "~/MyFile/Org/Note.org" "2022年6月")
            ("n" "笔记" entry (file+headline "~/MyFile/Org/Note.org" "Note.org")
             "* %^{你想要记录的笔记} \n :时间: %T \n %?")

            ;;消费
            ("zd" "账单" plain (file+function "~/MyFile/Org/Bill.org" find-month-tree)
             " | %<%Y-%m-%d %a %H:%M:%S> | %^{prompt|Breakfast|Lunch|Dinner|Shopping|Night Snack|Fruit|Transportation|Other} | %^{支付金额} | %^{收入金额} |" :kill-buffer t :immediate-finish t)

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
             "* %<%H:%M> %^{记些什么} %?\n  %i\n" :kill-buffer t :immediate-finish t :prepend 1)

            ;;日程安排
            ("a" "日程安排" plain (file+function "~/Destop/MyFile/Org/GTD/Agenda.org" find-month-tree)
             "*** [#%^{优先级}] %^{安排} \n SCHEDULED: %^T \n  :地点: %^{地点}\n" :kill-buffer t :immediate-finish t)

            ;;笔记
            ("n" "笔记" entry (file+headline "~/Desktop/MyFile/Org/Note.org" "Note")
             "* %^{你想要记录的笔记} \n :时间: %T \n %?")

            ;;消费
            ("zd" "账单" plain (file+function "~/Desktop/MyFile/Org/Bill.org" find-month-tree)
             " | %<%Y-%m-%d %a %H:%M:%S> | %^{prompt|Breakfast|Lunch|Dinner|Shopping|Night Snack|Fruit|Transportation|Other} | %^{支付金额} | %^{收入金额} |" :kill-buffer t :immediate-finish t)

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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; org 通知设置
(use-package! appt
  :defer t
  :after org
  :hook (org-agenda-finalize . org-agenda-to-appt)
  :init
  ;; 每小时同步一次appt,并且现在就开始同步
  (run-at-time nil 3600 'org-agenda-to-appt)
  :config
  ;; 更新agenda时，同步appt
  ;; (add-hook 'org-agenda-finalize-hook 'org-agenda-to-appt)
  ;; 激活提醒
  (appt-activate 1)
  ;; 提前1分钟提醒, 单位: 分
  (setq appt-message-warning-time 1)
  (setq appt-audible t)
  ;;提醒间隔, 单位: 分
  (setq appt-display-interval 5
        appt-display-duration 20);; 提醒多少秒后消失提醒信息

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
;; org 标题加密， 只需添加 :crypt:
(use-package! org-crypt
  :defer t
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
  :defer t
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
(add-hook 'dired-mode-hook 'org-download-enable)
(setq org-download-heading-lvl nil)
(setq org-download-timestamp "%Y%m%dT%H%M%S_")
;; 文件目录
;; (setq-default org-download-image-dir (concat "./Attachment/" (file-name-nondirectory (file-name-sans-extension (buffer-file-name)))))
(defun my-org-download--dir-1 ()
  (or org-download-image-dir (concat "./Attachment/" (file-name-nondirectory (file-name-sans-extension (buffer-file-name))) )))
(advice-add #'org-download--dir-1 :override #'my-org-download--dir-1)

(use-package! org-journal
  :defer t
  :config
  (if freedom/is-windows
    (setq org-journal-dir "f:\\MyFile\\Org\\Journal"))
  (if freedom/is-linux
    (setq org-journal-dir "~/MyFile/Org/Journal"))
  (if freedom/is-darwin
    (setq org-journal-dir "~/Desktop/MyFile/Org/Journal"))
  (setq org-journal-enable-agenda-integration t)
  )

(use-package! org-html-themify
  :hook (org-mode . org-html-themify-mode)
  :defer t
  :config
  (setq org-html-themify-themes
        '((dark . doom-one)
          (light . doom-solarized-light)))
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; aggressive-indent 自动缩进
(use-package aggressive-indent
  :defer t
  :load-path "~/.doom.d/core/plugins"
  :hook (emacs-lisp-mode . aggressive-indent-mode)
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; bm Save the bookmark
(use-package! bm
  :load-path "~/.doom.d/core/plugins"
  :demand t
  :init
  (setq bm-restore-repository-on-load t)
  :config
  (setq bm-cycle-all-buffers t)
  (setq bm-repository-file "~/.doom.d/.local/bm-repository")
  (setq-default bm-buffer-persistence t)
  (add-hook 'after-init-hook 'bm-repository-load)
  (add-hook 'kill-buffer-hook #'bm-buffer-save)
  (add-hook 'kill-emacs-hook #'(lambda nil
                                 (bm-buffer-save-all)
                                 (bm-repository-save)))
  (add-hook 'after-save-hook #'bm-buffer-save)
  (add-hook 'find-file-hooks   #'bm-buffer-restore)
  (add-hook 'after-revert-hook #'bm-buffer-restore)
  (add-hook 'vc-before-checkin-hook #'bm-buffer-save)

  (defhydra hydra-bm (:color pink
                      :hint nil
                      :foreign-keys warn ;; 不要使用hydra以外的键
                      )
    "
_j_: bm-next             _k_: bm-previous      _m_: mark
_s_: view mark           _S_: view all
_r_: restore
_c_: remove mark         _C_: remove all
"
    ("j" bm-next  :exit t)
    ("k" bm-previous  :exit t)
    ("m" bm-toggle  :exit t)
    ("s" bm-show  :exit t)
    ("S" bm-show-all  :exit t)
    ("r" bm-buffer-restore  :exit t)
    ("c" bm-remove-all-current-buffer :exit t)
    ("C" bm-remove-all-all-buffers :exit t)
    ;;   (""  :exit nil)
    ("q" nil "cancel")
    ("<escape>" nil "cancel")
    )
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; elfeed
(use-package! elfeed
  :defer t
  :init
  (setq url-queue-timeout 30)
  ;; (setq elfeed-db-directory (concat doom-user-dir ".local/.elfeed/db/"))
  :config
  ;; recentf 排除
  (when recentf-mode
    (push elfeed-db-directory recentf-exclude))
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; elfeed-org
(use-package! elfeed-org
  :defer t
  :config
  (elfeed-org)
  (setq rmh-elfeed-org-files (list (expand-file-name "elfeed.org" doom-user-dir)))
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; gnus
(use-package! gnus
  :commands (gnus)
  :init
  (setq auth-sources '("~/.doom.d/.authinfo.gpg"))
  :config
  (defcustom freedom-email-select 'QQ
    "Set Email.
`QQ': QQ email.
`Gmail': Gmail.
tags: Use tag Email.
nil means disabled."
    :group 'freedom
    :type '(choice (const :tag "QQ" QQ)
                   (const :tag "Gmail" Gmail)
                   (const :tag "Not" nil)
                   ))
  (pcase freedom-email-select
    ('QQ
     (setq user-mail-address "isouthrain@qq.com"
           user-full-name "ISouthRain")
     (setq my-mail "isouthrain@qq.com")
     ;; ;; 收取首要邮件来源
     (setq gnus-select-method
           '(nnimap "QQ"
                    (nnimap-address "imap.qq.com")  ; it could also be imap.googlemail.com if that's your server.
                    (nnimap-server-port "993")
                    (nnimap-stream ssl)
                    ))
     ;; ;; 邮件源设置
     (setq mail-sources                                 ;邮件源设置
           '((maildir :path "~/Maildir/QQ/"           ;本地邮件存储位置
                      :subdirs ("cur" "new" "tmp"))))   ;本地邮件子目录划分
     ;; 设置邮件发送方法
     (setq smtpmail-smtp-server "smtp.qq.com")))
  (pcase freedom-email-select
    ('Gmail
     (setq user-mail-address "isouthrain@gmail.com"
           user-full-name "ISouthRain")
     (setq my-mail "isouthrain@gmail.com")
     ;; ;; 收取首要邮件来源
     (setq gnus-select-method
           '(nnimap "Gmail"
                    (nnimap-address "imap.gmail.com")  ; it could also be imap.googlemail.com if that's your server.
                    (nnimap-server-port "993")
                    (nnimap-stream ssl)
                    ))
     ;; ;; 第二个收取邮件来源
     ;; (setq gnus-secondary-select-methods                  ;次要选择方法
     ;;       '(
     ;;         (nnmaildir "Gmail"                        ;nnmaildir后端, 从本地文件中读邮件 (getmail 抓取)
     ;;                    (directory "~/Maildir/Gmail/")) ;读取目录
     ;;         ))
     ;; ;; 邮件源设置
     (setq mail-sources                                 ;邮件源设置
           '((maildir :path "~/Maildir/Gmail/"           ;本地邮件存储位置
                      :subdirs ("cur" "new" "tmp"))))   ;本地邮件子目录划分
     ;; 设置邮件发送方法
     (setq smtpmail-smtp-server "smtp.gmail.com")))
;;;;;; freedom-email-select End
  (setq smtpmail-stream-type 'ssl
        smtpmail-smtp-service 465
        ;; 发送方法
        send-mail-function 'smtpmail-send-it
        message-send-mail-function 'smtpmail-send-it ;设置消息发送方法
        ;; sendmail-program "/usr/bin/msmtp"            ;设置发送程序
        mail-specify-envelope-from t                 ;发送邮件时指定信封来源
        mail-envelope-from 'header                  ;信封来源于 header       "nnmaildir+Gmail:inbox")))                ;邮件归档
        gnus-ignored-newsgroups "^to\\.\\|^[0-9. ]+\\( \\|$\\)\\|^[\"]\"[#'()]")
  ;; ;; 存储设置
  (setq gnus-startup-file "~/.emacs.d/.local/Cache/Gnus/.newsrc")                  ;初始文件
  (setq gnus-default-directory "~/.emacs.d/.local/Cache/Gnus/")                    ;默认目录
  (setq gnus-home-directory "~/.emacs.d/.local/Cache/Gnus/")                       ;主目录
  (setq gnus-dribble-directory "~/.emacs.d/.local/Cache/Gnus/")                    ;恢复目录
  (setq gnus-directory "~/.emacs.d/.local/Cache/Gnus/News/")                       ;新闻组的存储目录
  (setq gnus-article-save-directory "~/.emacs.d/.local/Cache/Gnus/News/")          ;文章保存目录
  (setq gnus-kill-files-directory "~/.emacs.d/.local/Cache/Gnus/News/trash/")      ;文件删除目录
  (setq gnus-agent-directory "~/.emacs.d/.local/Cache/Gnus/News/agent/")           ;代理目录
  (setq gnus-cache-directory "~/.emacs.d/.local/Cache/Gnus/News/cache/")           ;缓存目录
  (setq gnus-cache-active-file "~/.emacs.d/.local/Cache/Gnus/News/cache/active")   ;缓存激活文件
  (setq message-directory "~/.emacs.d/.local/Cache/Gnus/Mail/")                    ;邮件的存储目录
  (setq message-auto-save-directory "~/.emacs.d/.local/Cache/Gnus/Mail/drafts")    ;自动保存的目录
  (setq mail-source-directory "~/.emacs.d/.local/Cache/Gnus/Mail/incoming")        ;邮件的源目录
  (setq nnmail-message-id-cache-file "~/.emacs.d/.local/Cache/Gnus/.nnmail-cache") ;nnmail的消息ID缓存
  (setq nnml-newsgroups-file "~/.emacs.d/.local/Cache/Gnus/Mail/newsgroup")        ;邮件新闻组解释文件
  (setq nntp-marks-directory "~/.emacs.d/.local/Cache/Gnus/News/marks")            ;nntp组存储目录
  (setq mml-default-directory "~/.emacs.d/.local/Cache/Gnus/.gnus/")                            ;附件的存储位置

  ;;Debug
  (setq smtpmail-debug-info t)
  (setq smtpmail-debug-verb t)
  ;; 常规设置
  (gnus-agentize)                                     ;开启代理功能, 以支持离线浏览
  (setq gnus-inhibit-startup-message t)               ;关闭启动时的画面
  ;; (setq gnus-novice-user nil)                         ;关闭新手设置, 不进行确认
  (setq gnus-expert-user t)                           ;不询问用户
  (setq gnus-show-threads t)                          ;显示邮件线索
  (setq gnus-interactive-exit nil)                    ;退出时不进行交互式询问
  ;; (setq gnus-use-dribble-file nil)                    ;不创建恢复文件
  ;; (setq gnus-always-read-dribble-file nil)            ;不读取恢复文件
  (setq gnus-asynchronous t)                          ;异步操作
  (setq gnus-large-newsgroup 100)                     ;设置大容量的新闻组默认显示的大小
  (setq gnus-large-ephemeral-newsgroup nil)           ;和上面的变量一样, 只不过对于短暂的新闻组
  (setq gnus-summary-ignore-duplicates t)             ;忽略具有相同ID的消息
  (setq gnus-treat-fill-long-lines t)                 ;如果有很长的行, 不提示
  (setq message-confirm-send t)                       ;防止误发邮件, 发邮件前需要确认
  (setq message-kill-buffer-on-exit t)                ;设置发送邮件后删除buffer
  (setq message-from-style 'angles)                   ;`From' 头的显示风格
  (setq message-syntax-checks '((sender . disabled))) ;语法检查
  (setq nnmail-expiry-wait 7)                         ;邮件自动删除的期限 (单位: 天)
  (setq nnmairix-allowfast-default t)                 ;加快进入搜索结果的组
  ;; 窗口布局
  (gnus-add-configuration
   '(article
     (vertical 1.0
               (summary .35 point)
               (article 1.0))))
  ;; 显示设置
  (setq mm-inline-large-images t)                       ;显示内置图片
  (auto-image-file-mode)                                ;自动加载图片
  (add-to-list 'mm-attachment-override-types "image/*") ;附件显示图片

  ;; 概要显示设置
  (setq gnus-summary-gather-subject-limit 'fuzzy) ;聚集题目用模糊算法
  (setq gnus-summary-line-format "%4P %U%R%z%O %{%5k%} %{%14&user-date;%}   %{%-20,20n%} %{%ua%} %B %(%I%-60,60s%)\n")
  (defun gnus-user-format-function-a (header) ;用户的格式函数 `%ua'
    (let ((myself (concat "<" my-mail ">"))
          (references (mail-header-references header))
          (message-id (mail-header-id header)))
      (if (or (and (stringp references)
                   (string-match myself references))
              (and (stringp message-id)
                   (string-match myself message-id)))
          "X" "│")))

  (setq gnus-user-date-format-alist             ;用户的格式列表 `user-date'
        '(((gnus-seconds-today) . "TD %H:%M")   ;当天
          (604800 . "W%w %H:%M")                ;七天之内
          ((gnus-seconds-month) . "%d %H:%M")   ;当月
          ((gnus-seconds-year) . "%m-%d %H:%M") ;今年
          (t . "%y-%m-%d %H:%M")))              ;其他

  ;; 线程的可视化外观, `%B'
  (setq gnus-summary-same-subject "")
  (setq gnus-sum-thread-tree-indent "    ")
  (setq gnus-sum-thread-tree-single-indent "◎ ")
  (setq gnus-sum-thread-tree-root "● ")
  (setq gnus-sum-thread-tree-false-root "☆")
  (setq gnus-sum-thread-tree-vertical "│")
  (setq gnus-sum-thread-tree-leaf-with-other "├─► ")
  (setq gnus-sum-thread-tree-single-leaf "╰─► ")
  ;; 时间显示
  (add-hook 'gnus-article-prepare-hook 'gnus-article-date-local) ;将邮件的发出时间转换为本地时间
  (add-hook 'gnus-select-group-hook 'gnus-group-set-timestamp)   ;跟踪组的时间轴
  (add-hook 'gnus-group-mode-hook 'gnus-topic-mode)              ;新闻组分组
  ;; 设置邮件报头显示的信息
  (setq gnus-visible-headers
        (mapconcat 'regexp-quote
                   '("From:" "Newsgroups:" "Subject:" "Date:"
                     "Organization:" "To:" "Cc:" "Followup-To" "Gnus-Warnings:"
                     "X-Sent:" "X-URL:" "User-Agent:" "X-Newsreader:"
                     "X-Mailer:" "Reply-To:" "X-Spam:" "X-Spam-Status:" "X-Now-Playing"
                     "X-Attachments" "X-Diagnostic")
                   "\\|"))
  ;; 用 Supercite 显示多种多样的引文形式
  (setq sc-attrib-selection-list nil
        sc-auto-fill-region-p nil
        sc-blank-lines-after-headers 1
        sc-citation-delimiter-regexp "[>]+\\|\\(: \\)+"
        sc-cite-blank-lines-p nil
        sc-confirm-always-p nil
        sc-electric-references-p nil
        sc-fixup-whitespace-p t
        sc-nested-citation-p nil
        sc-preferred-header-style 4
        sc-use-only-preference-p nil)
  ;; 线程设置
  (setq
   gnus-use-trees t                                                       ;联系老的标题
   gnus-tree-minimize-window nil                                          ;用最小窗口显示
   gnus-fetch-old-headers 'some                                           ;抓取老的标题以联系线程
   gnus-generate-tree-function 'gnus-generate-horizontal-tree             ;生成水平树
   gnus-summary-thread-gathering-function 'gnus-gather-threads-by-subject ;聚集函数根据标题聚集
   )
  ;; 排序
  (setq gnus-thread-sort-functions
        '(
          (not gnus-thread-sort-by-date)                               ;时间的逆序
          (not gnus-thread-sort-by-number)))                           ;跟踪的数量的逆序
  ;; 自动跳到第一个没有阅读的组
  (add-hook 'gnus-switch-on-after-hook 'gnus-group-first-unread-group) ;gnus切换时
  (add-hook 'gnus-summary-exit-hook 'gnus-group-first-unread-group)    ;退出Summary时
  ;; 斑纹化
  (setq gnus-summary-stripe-regexp        ;设置斑纹化匹配的正则表达式
        (concat "^[^"
                gnus-sum-thread-tree-vertical
                "]*"))
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; mu4e
;; (when freedom/is-linux
;;   (add-to-list 'load-path "/usr/share/emacs/site-lisp/mu4e")
;;   (when freedom/is-termux
;;     (add-to-list 'load-path "/data/data/com.termux/files/usr/share/emacs/site-lisp/mu4e"))
;;   (require 'mu4e)
;;   (setq mu4e-maildir "~/Maildir")
;;   (setq mu4e-change-filenames-when-moving t)
;;   (pcase freedom-email-select
;;     ('Gmail
;;      (setq mu4e-get-mail-command "offlineimap -c ~/.doom.d/.offlineimaprc;mu init --maildir ~/Maildir --my-address isouthrain@gmail.com;mu index --maildir $HOME/Maildir")
;;      (setq mu4e-reply-to-address "isouthrain@gmail.com"
;;            user-mail-address "isouthrain@gmail.com"
;;            user-full-name "ISouthRain")
;;      (setq mu4e-drafts-folder "/Gmail/[Gmail].Drafts")
;;      (setq mu4e-sent-folder "/Gmail/[Gmail].Sent Mail")
;;      (setq mu4e-trash-folder "/Gmail/[Gmail].Trash")
;;      (setq mu4e-maildir-shortcuts
;;            '( ("/Gmail/INBOX" . ?i)
;;               ("/Gmail/[Gmail].Sent Mail" . ?s)
;;               ("/Gmail/[Gmail].Trash" . ?t)
;;               ("/Gmail/[Gmail].Drafts" . ?d)
;;               ("/Gmail/[Gmail].Starred" . ?m)
;;               ("/Gmail/[Gmail].All Mail" . ?a)
;;               ("/Gmail/[Gmail].Spam" . ?p)
;;               ("/Gmail/[Gmail].Important" . ?z)))))

;;   (pcase freedom-email-select
;;     ('QQ
;;      (setq mu4e-get-mail-command "offlineimap -c ~/.doom.d/.offlineimaprc;mu init --maildir ~/Maildir --my-address isouthrain@qq.com;mu index --maildir $HOME/Maildir")
;;      (setq mu4e-reply-to-address "isouthrain@qq.com"
;;            user-mail-address "isouthrain@qq.com"
;;            user-full-name "ISouthRain")
;;      (setq mu4e-drafts-folder "/QQ/Drafts")
;;      (setq mu4e-sent-folder "/QQ/Sent Messages")
;;      (setq mu4e-trash-folder "/QQ/Deleted Messages")
;;      (setq mu4e-maildir-shortcuts
;;            '( ("/QQ/INBOX" . ?i)
;;               ("/QQ/Sent Messages" . ?s)
;;               ("/QQ/Sent Mail" . ?m)
;;               ("/QQ/Deleted Messages" . ?t)
;;               ("/QQ/Drafts" . ?d)
;;               ("/QQ/Junk" . ?j)))))

;;   ;; ;; (setq message-signature-file "~/.emacs.d/.signature") ; put your signature in this file
;;   ;; ;; get mail
;;   ;; (setq mu4e-get-mail-command "mbsync -a -c ~/.emacs.d/.mbsyncrc;mu init -m ~/Maildir/QQ --my-address=isouthrain@gmail.com;mu index"
;;   (setq mu4e-html2text-command "w3m -T text/html"
;;         mu4e-update-interval 120
;;         mu4e-headers-auto-update t
;;         mu4e-compose-signature-auto-include nil)
;;   ;; show images
;;   (setq mu4e-show-images t)
;;   ;; use imagemagick, if available
;;   (when (fboundp 'imagemagick-register-types)
;;     (imagemagick-register-types))
;;   ;; don't save message to Sent Messages, IMAP takes care of this
;;   (setq mu4e-sent-messages-behavior 'delete)
;;   )

;; )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; calfw
(use-package! calfw
  :defer 1
  :config
  ;; Month
  (setq calendar-month-name-array
        ["一月" "二月" "三月" "四月" "五月"   "六月"
         "七月" "八月" "九月" "十月" "十一月" "十二月"])
  ;; Week days
  (setq calendar-day-name-array
        ["周末" "周一" "周二" "周三" "周四" "周五" "周六"])
  ;; First day of the week
  (setq calendar-week-start-day 0) ; 0:Sunday, 1:Monday
  (defun cfw:freedom-calendar ()
    (interactive)
    (cfw:open-calendar-buffer
     :contents-sources
     (list
      (cfw:org-create-source "Orange")  ; orgmode source
      (cfw:ical-create-source "RainISouth" "https://calendar.google.com/calendar/ical/isouthrain%40gmail.com/public/basic.ics" "Blue") ; google calendar ICS
      (cfw:ical-create-source "ChinaHoliday" "https://calendar.google.com/calendar/ical/zh-cn.china%23holiday%40group.v.calendar.google.com/public/basic.ics" "IndianRed") ; google calendar ICS
      )))

  ;; (advice-add #'calendar :override #'cfw:freedom-calendar)
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; cal-china-x
(use-package cal-china-x
  :defer t
  :load-path "~/.doom.d/core/plugins"
  :after calendar
  :commands cal-china-x-setup
  :init (cal-china-x-setup)
  :config
  ;; Holidays
  (setq calendar-mark-holidays-flag t
        cal-china-x-important-holidays cal-china-x-chinese-holidays
        cal-china-x-general-holidays '((holiday-lunar 1 15 "元宵节")
                                       (holiday-fixed 1 1 "春节")
                                       (holiday-fixed 3 8 "妇女节")
                                       (holiday-fixed 3 12 "植树节")
                                       (holiday-fixed 5 4 "青年节")
                                       (holiday-fixed 6 1 "儿童节")
                                       (holiday-lunar 7 7 "七夕节")
                                       (holiday-lunar 8 15 "中秋节")
                                       (holiday-fixed 9 10 "教师节")
                                       (holiday-fixed 10 1 "国庆节")
                                       )
        holiday-other-holidays '((holiday-fixed 2 14 "情人节")
                                 (holiday-fixed 4 1 "愚人节")
                                 (holiday-fixed 9 1 "全国开学日")
                                 (holiday-fixed 12 25 "圣诞节")
                                 (holiday-float 5 0 2 "母亲节")
                                 (holiday-float 6 0 3 "父亲节")
                                 (holiday-float 11 4 4 "感恩节")
                                 )
        holiday-custom-holidays '((holiday-lunar 7 29 "Happy Birthday")
                                  (holiday-lunar 2 3 "纪念奶奶")
                                  )
        calendar-holidays (append cal-china-x-important-holidays
                                  cal-china-x-general-holidays
                                  holiday-other-holidays
                                  holiday-custom-holidays
                                  )))

(use-package! markdown-toc
  :defer t
  :hook (markdown-mode . markdown-toc-mode)
  :config
  (add-hook 'markdown-mode-hook #'markdown-toc-mode)
  (defun freedom-hugo-home ()
    (interactive) ; 如果不需要定义成命令，这句可以不要。
    (when (string= "gnu/linux" system-type)
      (find-file "~/Ubuntu/ubuntu-fs/root/Hugo/content/posts/Home.md"))
    (when (string= "darwin" system-type)
      (find-file "~/Desktop/Hugo/content/posts/Home.md"))
    (when (string= "windows-nt" system-type)
      (find-file "F:\\Hugo\\content\\posts\\Home.md"))
    )
  )

(use-package! google-translate
  :config
 (setq google-translate-default-source-language "auto"
       google-translate-default-target-language "zh-CN")
 (setq google-translate-translation-directions-alist
      '(("en" . "zh-CN") ("zh-CN" . "en")))
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 输入中文后自动翻译
(use-package insert-translated-name
  :defer 1
  :load-path "~/.doom.d/core/plugins/"
  :config
  ;; (setq insert-translated-name-translate-engine "google");; ;google  youdao
  (setq insert-translated-name-translate-engine "youdao");; ;google  youdao
  (defun freedom-english-translate ()
    (interactive))
  (advice-add #'freedom-english-translate :override #'insert-translated-name-insert)
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 对英文单词编写进行提示
(use-package company-english-helper
  :defer 1
  :load-path "~/.doom.d/core/plugins/"
  :config
  (defun freedom-english-company ()
    (interactive)
    (toggle-company-english-helper))
  )

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

    (setq pyim-cloudim 'baidu)

;; (setq pyim-dicts
      ;; '((:name "搜狗词库" :file "~/.doom.d/.local/pyim/dicts/sogou.txt")
        ;; (:name "王者荣耀" :file "~/.doom.d/.local/pyim/dicts/王者荣耀.txt")
        ;; ))
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

  ;; 添加对 meow 支持
  ;; (defalias 'pyim-probe-meow-normal-mode #'(lambda nil
  ;;                                                 (meow-normal-mode-p)))
  ;; (setq-default pyim-english-input-switch-functions
  ;;               '(pyim-probe-meow-normal-mode))

  );; pyim

(setq dumb-jump-force-searcher 'rg)
(setq dumb-jump-prefer-searcher 'rg)

(map! :nmv ";" #'evil-ex
      :nmv "m" #'hydra-bm/body
      :nmv "<f12>" #'dumb-jump-go
      :nmv "gD" #'better-jumper-jump-backward
      :nmv "f" #'avy-goto-char
      :nm "q" #'freedom/evil-quit
      :nmv "Q" #'evil-record-macro
      :nmv "C-s" #'consult-line
      :nmv "/" #'consult-line
      :nmv "\"" #'consult-yank-pop
      :v "q" #'evil-escape
      :leader
      (:prefix-map ("f" . "file")
       ;; :desc "Translate text"  "y" #'gts-do-translate)
       :desc "Translate text"  "y" #'google-translate-smooth-translate
       )
      (:prefix-map ("c" . "code")
       :desc "对齐代码"  "SPC"     #'align-regexp)
      (:prefix-map ("p" . "project")
       :desc "ripgre"  "s"     #'projectile-ripgrep
       :desc "save buffer" "S" #'projectile-save-project-buffers)

      )
