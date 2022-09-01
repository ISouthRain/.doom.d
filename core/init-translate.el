;;; core/init-translate.el -*- lexical-binding: t; -*-

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package go-translate
  ;; :defer-incrementally t
  :defer 2
  :config
  ;; 配置多个翻译语言对
  (setq gts-translate-list '(("en" "zh") ("fr" "zh")))
  ;; 设置为 t 光标自动跳转到buffer
  (setq gts-buffer-follow-p t)
  (if (display-graphic-p)
      (if (posframe-workable-p)
          (setq gts-default-translator
                (gts-translator
                 :picker (gts-noprompt-picker)
                 :engines (list (gts-google-rpc-engine) (gts-bing-engine))
                 :render (gts-posframe-pop-render :forecolor "#ffffff" :backcolor "#111111")))
        )
    (setq gts-default-translator
          (gts-translator
           :picker (gts-noprompt-picker)
           :engines (list (gts-google-rpc-engine) (gts-bing-engine))
           :render (gts-buffer-render)))
    )
  );; go-translate


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; sdcv 翻译
;; (when freedom/is-termux
;;     (use-package sdcv
;;       :defer 3
;;       :ensure nil
;;       :load-path "~/.doom.d/core/plugins"
;;       :config
;;       ;; 翻译后是否说话
;;       (setq sdcv-say-word-p nil)
;;       ;; sdcv 字典目录
;;       ;; (setq sdcv-dictionary-data-dir (expand-file-name ".stardict/dic" doom-local-dir))
;;       (setq sdcv-dictionary-data-dir "/data/data/com.termux/files/home/.doom.d/.local/.stardict/dic")

;;       (setq sdcv-dictionary-simple-list    ;setup dictionary list for simple search
;;             '(
;;               "懒虫简明英汉词典"
;;               "计算机词汇"
;;               "牛津高阶英汉双解"
;;               ))
;;       (setq sdcv-dictionary-complete-list     ;setup dictionary list for complete search
;;             '(
;;               "懒虫简明英汉词典"
;;               "懒虫简明汉英词典"
;;               "牛津高阶英汉双解"
;;               ))
;;       ;; 修改调用 popup-tip 弹窗
;;       (when freedom/is-termux
;;         (defun freedom-sdcv-search-simple (&optional word)
;;           "Search WORD simple translate result."
;;           (when (ignore-errors (require 'posframe))
;;             (let ((result (sdcv-search-with-dictionary word sdcv-dictionary-simple-list)))
;;               ;; Show tooltip at point if word fetch from user cursor.
;;               (popup-tip result '(max-width)))))
;;         (advice-add #'sdcv-search-simple :override #'freedom-sdcv-search-simple))

;;       )
;;   )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 输入中文后自动翻译
;; (use-package insert-translated-name
;;   :defer 3
;;   :ensure nil
;;   :load-path "~/.doom.d/core/plugins/"
;;   :config
;;   (setq insert-translated-name-translate-engine "google");; ;google  youdao
;;   )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 对英文单词编写进行提示
;; (use-package company-english-helper
;;   :ensure nil
;;   :defer 6
;;   :load-path "~/.doom.d/core/plugins/"
;;   )

(provide 'init-translate)
