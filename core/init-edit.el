;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; aggressive-indent 自动缩进
(use-package aggressive-indent
  :defer 3
  :load-path "~/.doom.d/core/plugins"
  :hook (elisp-mode . aggressive-indent-mode)
  :config
  ;; (global-aggressive-indent-mode 1)
  )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; bm Save the bookmark
;; Do not delay load
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
(provide 'init-edit)
