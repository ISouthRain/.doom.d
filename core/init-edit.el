;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; aggressive-indent 自动缩进
;; (use-package aggressive-indent
;;   :defer 3
;;   :load-path "~/.doom.d/core/plugins"
;;   :config
;;   (global-aggressive-indent-mode 1))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; bm 标记文件
(use-package! bm
  :defer 1
  :load-path "~/.doom.d/core/plugins"
  :hook '((after-init . bm-repository-load)
          (after-revert . bm-buffer-restore)
          (find-file . bm-buffer-restore)
          (after-save . bm-buffer-restore)
          (vc-before-checkin . bm-buffer-save)
          (kill-buffer . bm-buffer-save))
  :after (evil)
  :init
  ;; 在哪里存储持久文件
  (setq bm-repository-file "~/.emacs.d/.local/bm-repository"
        bm-restore-repository-on-load t)
  :config
  (setq bm-cycle-all-buffers t)
  ;; save bookmarks
  (setq-default bm-buffer-persistence t)
  ;; 必须先保存所有书签。
  (add-hook 'kill-emacs-hook #'(lambda nil
                                 (bm-buffer-save-all)
                                 (bm-repository-save)))
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
(provide 'init-edit)
