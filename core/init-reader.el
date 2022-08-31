;;; core/init-reader.el -*- lexical-binding: t; -*-

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; elfeed
(use-package elfeed
  :defer 3
  :init (setq url-queue-timeout 30)
  :config
  (when recentf-mode
    ;; recentf 排除
    (push elfeed-db-directory recentf-exclude))
  )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; elfeed-org
(use-package elfeed-org
  :defer 3
  :config
  (elfeed-org)
  (setq rmh-elfeed-org-files (list (expand-file-name "elfeed.org" doom-user-dir))
        elfeed-db-directory (expand-file-name ".local/.elfeed" doom-user-dir))
  )


(provide 'init-reader)
